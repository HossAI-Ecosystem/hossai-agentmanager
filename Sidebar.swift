import SwiftUI

struct Sidebar: View {
    @EnvironmentObject var vm: AppVM
    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                Text("Agent Status").font(.title3).bold().frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                ForEach(vm.agents) { agent in AgentCard(agent: agent) }
            }
            .padding(.vertical, 8)
        }
        .frame(minWidth: 340)
    }
}

struct AgentCard: View {
    @EnvironmentObject var vm: AppVM
    let agent: Agent

    var pillColor: Color {
        switch agent.health {
        case .healthy: return T.good
        case .degraded: return T.warn
        case .offline: return T.bad
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(agent.name).font(.headline).foregroundStyle(.white)
                Spacer()
                Label(agent.health.rawValue.capitalized, systemImage: "circle.fill")
                    .labelStyle(.titleAndIcon)
                    .foregroundStyle(pillColor)
                    .padding(.horizontal, 10).padding(.vertical, 4)
                    .background(.ultraThinMaterial).clipShape(Capsule())
            }
            Text("Repo: \(agent.repo)").font(.caption).foregroundStyle(.secondary)
            Text("Windows: \(agent.windows)").font(.caption2).foregroundStyle(.secondary)

            HStack(spacing: 10) {
                Button { vm.refreshWindows() } label: {
                    Label("Test", systemImage: "play.fill")
                }
                .buttonStyle(.borderedProminent).tint(.green)

                Button {
                    if let url = agent.repoURL { NSWorkspace.shared.open(url) }
                } label: { Label("GitHub", systemImage: "globe") }
                .buttonStyle(.bordered).tint(.blue)

                Button { vm.runTask(for: agent) } label: {
                    Label("Task", systemImage: "bolt.fill")
                }
                .buttonStyle(.borderedProminent).tint(.pink)
                .disabled(!agent.ready)

                Button {
                    vm.input = "ping from \(agent.name)"
                    vm.sendToCursor()
                } label: { Label("Send", systemImage: "paperplane.fill") }
                .buttonStyle(.bordered).tint(.orange)
            }
        }
        .padding(T.pad)
        .background(T.cardBG())
        .padding(.horizontal, 12)
    }
}
