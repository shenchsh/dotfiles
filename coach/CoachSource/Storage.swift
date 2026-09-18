import Foundation

struct CoachingEntry: Codable, Identifiable {
    let id: UUID
    let createdAt: Date
    let input: String
    let response: String
    let provider: String
    let model: String
    let instructions: String
    let mode: String
    let authorship: String
    let englishLevel: String
    let explanationDetail: String
    let chineseSupport: Bool
    let pronunciations: [String]
    init(input: String, response: String, provider: String, model: String, instructions: String) {
        id = UUID(); createdAt = Date(); self.input = input; self.response = response
        self.provider = provider; self.model = model; self.instructions = instructions
        mode = (response.localizedCaseInsensitiveContains("Why these changes") || response.contains("为什么这样改")) ? "rewrite" : "explain"
        authorship = "unknown"; englishLevel = "Advanced"; explanationDetail = "Detailed"
        chineseSupport = true; pronunciations = ["American", "British"]
    }
}
struct HistoryExport: Encodable {
    let schemaVersion = 1
    let app = "Coach"
    let exportedAt = Date()
    let entries: [CoachingEntry]
    let analysisNote = "Source material, not a diagnosis. Input authorship is unknown and may be quoted. Do not assume corrections or lookups prove learner weaknesses. Support inferred patterns with entry IDs."
}
struct HistoryStore {
    let url: URL
    init(url: URL? = nil) {
        self.url = url ?? FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("Coach/history.json")
    }
    static func encoder() -> JSONEncoder {
        let encoder = JSONEncoder(); encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601; encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
    func load() throws -> [CoachingEntry] {
        guard FileManager.default.fileExists(atPath: url.path) else { return [] }
        let decoder = JSONDecoder(); decoder.dateDecodingStrategy = .iso8601; decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([CoachingEntry].self, from: Data(contentsOf: url))
    }
    func save(_ entries: [CoachingEntry]) throws {
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: [.posixPermissions: 0o700])
        try Self.encoder().encode(entries).write(to: url, options: .atomic)
        try FileManager.default.setAttributes([.posixPermissions: 0o600], ofItemAtPath: url.path)
    }
}

enum Provider: String, CaseIterable, Identifiable {
    case openAI = "OpenAI", openRouter = "OpenRouter"
    var id: String { rawValue }
    var example: String { self == .openAI ? "gpt-4.1-mini" : "openai/gpt-4.1-mini" }
    var endpoint: URL { URL(string: self == .openAI ? "https://api.openai.com/v1/responses" : "https://openrouter.ai/api/v1/chat/completions")! }
    var modelKey: String { self == .openAI ? "model" : "openRouterModel" }
}
struct CoachFailure: LocalizedError {
    let message: String
    var errorDescription: String? { message }
}
struct StreamEvent {
    var text = ""
    var completed = false
    static func parse(_ payload: String, provider: Provider) throws -> StreamEvent {
        if payload == "[DONE]" { return StreamEvent() }
        guard let data = payload.data(using: .utf8), let event = try JSONSerialization.jsonObject(with: data) as? [String: Any] else { throw CoachFailure(message: "Invalid response from \(provider.rawValue).") }
        if event["error"] != nil { throw CoachFailure(message: "\(provider.rawValue) could not complete the response. Check your model and account, then retry.") }
        if provider == .openRouter {
            let choice = (event["choices"] as? [[String: Any]])?.first
            let finish = choice?["finish_reason"] as? String
            if let finish, finish != "stop" { throw CoachFailure(message: "Response ended with \(finish). Try a shorter selection or another model.") }
            return StreamEvent(text: (choice?["delta"] as? [String: Any])?["content"] as? String ?? "", completed: finish == "stop")
        }
        switch event["type"] as? String {
        case "response.output_text.delta", "response.refusal.delta": return StreamEvent(text: event["delta"] as? String ?? "")
        case "response.completed": return StreamEvent(completed: true)
        case "response.incomplete", "response.failed", "error": throw CoachFailure(message: "The response was incomplete. Try a shorter selection or another model.")
        default: return StreamEvent()
        }
    }
}
enum CoachAPI {
    static func request(provider: Provider, model: String, token: String, instructions: String, input: String) throws -> URLRequest {
        var request = URLRequest(url: provider.endpoint)
        request.httpMethod = "POST"; request.timeoutInterval = 120
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var body: [String: Any]
        if provider == .openAI {
            body = ["model": model, "instructions": instructions, "input": input, "store": false, "stream": true, "max_output_tokens": 6000]
            if model.hasPrefix("gpt-5.6") || model.hasPrefix("gpt-5.4") { body["reasoning"] = ["effort": "none"] }
        } else {
            body = ["model": model, "messages": [["role": "system", "content": instructions], ["role": "user", "content": input]], "stream": true, "max_tokens": 6000]
        }
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        return request
    }
    @MainActor static func stream(provider: Provider, model: String, token: String, instructions: String, input: String, onText: (String) -> Void) async throws {
        let request = try request(provider: provider, model: model, token: token, instructions: instructions, input: input)
        let (bytes, response) = try await URLSession.shared.bytes(for: request)
        guard let http = response as? HTTPURLResponse else { throw CoachFailure(message: "No response from \(provider.rawValue).") }
        guard (200..<300).contains(http.statusCode) else {
            let reason: String
            switch http.statusCode {
            case 401: reason = "rejected the API key. Update it in Settings."
            case 402, 429: reason = "quota, credit, or rate limit reached. Check billing or try later."
            case 400, 403, 404: reason = "could not use this model. Check the model ID and account access."
            default: reason = "request failed. Try again."
            }
            throw CoachFailure(message: "\(provider.rawValue) \(reason) (HTTP \(http.statusCode))")
        }
        var completed = false; var hasText = false
        for try await line in bytes.lines {
            try Task.checkCancellation()
            guard line.hasPrefix("data:") else { continue }
            let event = try StreamEvent.parse(String(line.dropFirst(5)).trimmingCharacters(in: .whitespaces), provider: provider)
            completed = completed || event.completed
            if !event.text.isEmpty { hasText = true; onText(event.text) }
        }
        try Task.checkCancellation()
        guard completed && hasText else { throw CoachFailure(message: "The response ended early. Please retry.") }
    }
}
