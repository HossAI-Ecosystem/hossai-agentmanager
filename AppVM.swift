import SwiftUI

@MainActor
final class AppVM: ObservableObject {
    // Agents
    @Published var agents: [Agent] = [
        .init(name: "ProductOwner Agent", repo: "hossai-docs",
              repoURL: URL(string: "https://github.com/hossai/hossai-docs")),
        .init(name: "DevPortal Agent", repo: "hossai-portal",
              repoURL: URL(string: "https://github.com/hossai/hossai-portal")),
        .init(name: "AIEng Agent", repo: "hossai-agent-framework",
              repoURL: URL(string: "https://github.com/hossai/hossai-agent-framework")),
        .init(name: "DevOps Agent", repo: "hossai-infrastructure",
              repoURL: URL(string: "https://github.com/hossai/hossai-infrastructure")),
        .init(name: "QA Agent", repo: "hossai-qa",
              repoURL: URL(string: "https://github.com/hossai/hossai-qa"))    // NEW
    ]

    // Windows/allocations
    @Published var detected: [WindowInfo] = []
    @Published var allocations: [Allocation] = []

    // Chat
    @Published var messages: [ChatMessage] = [
        .init(role: .assistant, content: .markdown("**Welcome to HossAI Core.**"))
    ]
    @Published var input: String = ""
    @Published var selectedAgentName = "DevPortal Agent"
    @Published var speakReplies = false

    // Logs
    @Published var log: [LogEvent] = []

    // Timers
    private var scanTimer: Timer?

    // MARK: - Public actions
    func refreshWindows() {
        append(.scanner, "Scanning windows (AX)…")
        let wins = AXService.listWindows()
        detected = wins.map { .init(title: $0.title) }
        rebuildAllocations(from: wins.map { $0.title })
        append(.scanner, "Window scan complete")
    }

    func sendToCursor() {
        let text = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        messages.append(.init(role: .user, content: .markdown(text)))
        append(.messenger, "Sending to Cursor…")
        let ok = AXService.send(text)
        let reply = ok ? "✅ Delivered" : "❌ Delivery failed"
        messages.append(.init(role: .assistant, content: .markdown(reply)))
        append(ok ? .info : .error, reply)
        input = ""
    }

    func runTask(for agent: Agent) {
        if let i = agents.firstIndex(of: agent) {
            agents[i].ready = false
            append(.info, "Task started for \(agent.name)")
            DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
                self.agents[i].ready = true
                self.append(.info, "Task finished for \(agent.name)")
            }
        }
    }

    func startAutoScan(interval: TimeInterval = 12.0) {  // was 8.0
        scanTimer?.invalidate()
        scanTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.refreshWindows() }
        }
    }
    func stopAutoScan() { scanTimer?.invalidate(); scanTimer = nil }

    // MARK: - Allocation & health
    private func rebuildAllocations(from titles: [String]) {
        var buckets: [String:[String]] = [
            "ProductOwner Agent": [], "DevPortal Agent": [], "AIEng Agent": [], "DevOps Agent": [], "QA Agent": []
        ]
        for t in titles {
            let s = t.lowercased()
            if s.contains("docs")                 { buckets["ProductOwner Agent"]?.append(t) }
            else if s.contains("portal")          { buckets["DevPortal Agent"]?.append(t) }
            else if s.contains("framework")       { buckets["AIEng Agent"]?.append(t) }
            else if s.contains("infrastructure")  { buckets["DevOps Agent"]?.append(t) }
            else if s.contains("qa")              { buckets["QA Agent"]?.append(t) }
            else if s.contains("agentmanager") || s.contains("agentorch") {
                buckets["AIEng Agent"]?.append(t) // catch-all for orchestration window
            }
        }
        allocations = buckets.compactMap { name, wins in
            guard !wins.isEmpty else { return nil }
            let acts = Array(Set(wins.flatMap(activities(for:)))).sorted()
            return Allocation(agentName: name, windows: wins, activities: acts)
        }.sorted(by: { $0.agentName < $1.agentName })

        // health = windows>0 && ready ? healthy : offline/degraded
        for i in agents.indices {
            let count = buckets[agents[i].name]?.count ?? 0
            agents[i].windows = count
            if count == 0 { agents[i].health = .offline }
            else { agents[i].health = agents[i].ready ? .healthy : .degraded }
        }
    }

    private func activities(for title: String) -> [String] {
        let t = title.lowercased()
        if t.contains("docs")           { return ["Documentation","Policy Files","Project Management"] }
        if t.contains("portal")         { return ["Web Interface","Dashboard","API Routes"] }
        if t.contains("framework")      { return ["Agent Framework","LangGraph","Kestra"] }
        if t.contains("infrastructure") { return ["DevOps","Docker","Deployment"] }
        if t.contains("qa")             { return ["Testing","Quality Assurance","Test Cases"] }
        return ["Project Files","Code Editor","Terminal"]
    }

    private func append(_ level: LogEvent.Level, _ msg: String) {
        log.append(.init(level: level, message: msg))
    }
}
