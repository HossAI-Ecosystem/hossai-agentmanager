// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "HossAIAgentManager",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "HossAIAgentManager", targets: ["HossAIAgentManager"])
    ],
    targets: [
        .executableTarget(
            name: "HossAIAgentManager",
            path: ".",
            sources: [
                "HossAIAgentManagerApp.swift",
                "Theme.swift",
                "Models.swift",
                "AXService.swift",
                "VoiceService.swift",
                "AppVM.swift",
                "RootView.swift",
                "Sidebar.swift",
                "WindowsTab.swift",
                "ControlTab.swift",
                "LogsTab.swift"
            ]
        )
    ]
)
