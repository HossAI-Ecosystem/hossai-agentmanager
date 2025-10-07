import Foundation

enum AgentHealth: String, Codable { case healthy, degraded, offline }

struct Agent: Identifiable, Hashable, Codable {
    let id = UUID()
    var name: String
    var repo: String
    var repoURL: URL? = nil      // NEW
    var windows: Int = 0
    var ready: Bool = true
    var health: AgentHealth = .offline
}

struct WindowInfo: Identifiable { let id = UUID(); let title: String }

struct Allocation: Identifiable {
    let id = UUID()
    let agentName: String
    let windows: [String]
    let activities: [String]
}

enum Role { case user, assistant }
enum ChatContent: Hashable {
    case markdown(String)
    case code(String, lang: String?)
}

struct ChatMessage: Identifiable, Hashable {
    let id = UUID()
    let role: Role
    let content: ChatContent
    let ts = Date()
}

struct LogEvent: Identifiable {
    enum Level: String { case scanner, messenger, info, error }
    let id = UUID(); let ts = Date(); let level: Level; let message: String
}
