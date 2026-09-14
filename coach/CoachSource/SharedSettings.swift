import Foundation

struct SharedCoachSettings: Codable, Equatable {
    var schema = 1
    var id: String
    var modified: Date
    var model: String
    var prompt: String
}
struct SharedSettingsStore {
    let directory: URL
    var file: URL { directory.appendingPathComponent("settings.json") }
    static var shared: SharedSettingsStore {
        SharedSettingsStore(directory: FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("dotfiles/coach/config", isDirectory: true))
    }
    private func decode(_ url: URL) throws -> SharedCoachSettings {
        let item = try JSONDecoder().decode(SharedCoachSettings.self, from: Data(contentsOf: url))
        guard item.schema == 1, !item.model.isEmpty, !item.prompt.isEmpty else {
            throw NSError(domain: "Coach", code: 10, userInfo: [NSLocalizedDescriptionKey: "Shared settings are invalid. Check ~/dotfiles/coach/config/settings.json."])
        }
        return item
    }
    static func newest(_ items: [SharedCoachSettings]) -> SharedCoachSettings? {
        items.max { a, b in a.modified == b.modified ? a.id < b.id : a.modified < b.modified }
    }
    private func write(_ item: SharedCoachSettings, to url: URL) throws {
        let encoder = JSONEncoder(); encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        try encoder.encode(item).write(to: url, options: .atomic)
    }
    private func coordinated<T>(_ action: (URL) throws -> T) throws -> T {
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        var coordinationError: NSError?
        var result: Result<T, Error>?
        NSFileCoordinator().coordinate(writingItemAt: file, options: [], error: &coordinationError) { url in
            result = Result { try action(url) }
        }
        if let coordinationError { throw coordinationError }
        guard let result else { throw CocoaError(.fileWriteUnknown) }
        return try result.get()
    }
    // Read each conflict before marking it resolved; unreadable data is never discarded.
    private func resolvedCurrent(at url: URL) throws -> SharedCoachSettings? {
        var items: [SharedCoachSettings] = []
        if FileManager.default.fileExists(atPath: url.path) { items.append(try decode(url)) }
        let conflicts = NSFileVersion.unresolvedConflictVersionsOfItem(at: url) ?? []
        for version in conflicts { items.append(try decode(version.url)) }
        guard let winner = Self.newest(items) else { return nil }
        if !conflicts.isEmpty {
            try write(winner, to: url)
            for version in conflicts { version.isResolved = true }
            try NSFileVersion.removeOtherVersionsOfItem(at: url)
        }
        return winner
    }
    func migrate(from legacy: SharedSettingsStore) throws {
        var candidates: [(URL, SharedCoachSettings)] = []
        for folder in Set([directory, legacy.directory]) {
            let urls = (try? FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: [.isUbiquitousItemKey], options: .skipsHiddenFiles)) ?? []
            for url in urls where url.pathExtension == "json" && UUID(uuidString: url.deletingPathExtension().lastPathComponent) != nil {
                if (try? url.resourceValues(forKeys: [.isUbiquitousItemKey]))?.isUbiquitousItem == true {
                    try? FileManager.default.startDownloadingUbiquitousItem(at: url)
                }
                if let item = try? decode(url) { candidates.append((url, item)) }
            }
        }
        guard !candidates.isEmpty else { return }
        try coordinated { url in
            let current = try resolvedCurrent(at: url)
            let winner = Self.newest(candidates.map { $0.1 } + (current.map { [$0] } ?? []))!
            if current != winner { try write(winner, to: url) }
            // Only remove recognized revisions after their settings are safely consolidated.
            for (oldURL, original) in candidates {
                var removalError: NSError?
                var failure: Error?
                NSFileCoordinator().coordinate(writingItemAt: oldURL, options: .forDeleting, error: &removalError) { path in
                    do {
                        if try decode(path) == original { try FileManager.default.removeItem(at: path) }
                    } catch { failure = error }
                }
                if let removalError { throw removalError }
                if let failure { throw failure }
            }
        }
    }
    func latest() throws -> SharedCoachSettings? {
        try migrate(from: self)
        guard hasFiles() else { return nil }
        return try coordinated { try resolvedCurrent(at: $0) }
    }
    func hasFiles() -> Bool {
        ((try? FileManager.default.contentsOfDirectory(atPath: directory.path)) ?? []).contains { $0.contains(".json") }
    }
    @discardableResult func publish(model: String, prompt: String) throws -> SharedCoachSettings {
        try migrate(from: self)
        return try coordinated { url in
            let current = try resolvedCurrent(at: url)
            let revision = SharedCoachSettings(id: UUID().uuidString, modified: max(Date(), (current?.modified ?? .distantPast).addingTimeInterval(0.001)), model: model, prompt: prompt)
            try write(revision, to: url)
            try NSFileVersion.removeOtherVersionsOfItem(at: url)
            return revision
        }
    }
}
