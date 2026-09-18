import SwiftUI
import WebKit

struct MarkdownAnswer: NSViewRepresentable {
    var markdown: String
    var pronounce: (String) -> Void
    @Binding var selectedText: String
    func makeCoordinator() -> Coordinator { Coordinator(selectedText: $selectedText, pronounce: pronounce) }
    func makeNSView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .nonPersistent()
        config.userContentController.add(context.coordinator, name: "selection")
        config.userContentController.add(context.coordinator, name: "pronounce")
        let view = WKWebView(frame: .zero, configuration: config)
        view.setValue(false, forKey: "drawsBackground")
        view.navigationDelegate = context.coordinator
        context.coordinator.view = view
        if let url = Bundle.main.url(forResource: "answer", withExtension: "html") {
            view.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        return view
    }
    func updateNSView(_ view: WKWebView, context: Context) { context.coordinator.update(markdown) }
    final class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var selectedText: Binding<String>
        var pronounce: (String) -> Void
        init(selectedText: Binding<String>, pronounce: @escaping (String) -> Void) { self.selectedText = selectedText; self.pronounce = pronounce }
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if let text = message.body as? String {
                if message.name == "pronounce", ["US", "UK"].contains(text) { pronounce(text) }
                else if message.name == "selection" { selectedText.wrappedValue = String(text.prefix(50000)) }
            }
        }
        weak var view: WKWebView?
        var ready = false
        var latest = ""
        var rendered: String?
        var pending: DispatchWorkItem?
        func update(_ text: String) {
            latest = text
            guard ready, pending == nil, rendered != text else { return }
            let work = DispatchWorkItem { [weak self] in
                guard let self else { return }
                self.pending = nil; self.rendered = self.latest
                self.view?.callAsyncJavaScript("window.renderAnswer(markdown)", arguments: ["markdown": self.latest], in: nil, in: .page) { _ in }
            }
            pending = work
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08, execute: work)
        }
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { ready = true; update(latest) }
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .linkActivated {
                if let url = navigationAction.request.url, ["https", "http"].contains(url.scheme?.lowercased() ?? "") { NSWorkspace.shared.open(url) }
                decisionHandler(.cancel)
            } else { decisionHandler(navigationAction.request.url?.isFileURL == true ? .allow : .cancel) }
        }
    }
}
