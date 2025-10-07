import SwiftUI

struct WindowsTab: View {
    @EnvironmentObject var vm: AppVM
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack { Spacer()
                Button("Refresh") { vm.refreshWindows() }
                    .buttonStyle(.borderedProminent).tint(T.hi)
            }
            Text("Detected Windows").font(.headline)
            VStack(spacing: 8) {
                ForEach(vm.detected) { w in
                    HStack { Text(w.title).foregroundStyle(.white); Spacer() }
                        .padding(.horizontal, 14).padding(.vertical, 8)
                        .background(T.cardBG())
                }
            }
            Divider().opacity(0.3)
            Text("Agent Allocations").font(.headline)
            VStack(spacing: 12) {
                ForEach(vm.allocations) { a in
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Agent: \(a.agentName)").bold()
                        ForEach(a.windows, id: \.self) { Text("• \( $0 )") }
                        if !a.activities.isEmpty {
                            Text("Activities: \(a.activities.joined(separator: ", "))")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                    }
                    .padding(T.pad)
                    .background(T.cardBG())
                }
            }
            Spacer(minLength: 8)
        }
        .padding(.horizontal)
    }
}
