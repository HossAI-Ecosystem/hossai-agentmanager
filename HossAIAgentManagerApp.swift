import SwiftUI
import AppKit

@main
struct HossAIAgentManagerApp: App {
    @StateObject var vm = AppVM()

    init() {
        DispatchQueue.main.async {
            NSApp.setActivationPolicy(.regular)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                NSApplication.shared.activate(ignoringOtherApps: true)
            }
        }
    }

    var body: some Scene {
        WindowGroup("HossAI Agent Manager") {
            RootView()
                .environmentObject(vm)
                .frame(minWidth: 1200, minHeight: 720)
        }
        .windowToolbarStyle(.unifiedCompact)
        .defaultSize(width: 1280, height: 800)
    }
}
