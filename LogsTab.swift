import SwiftUI

struct LogsTab: View {
    @EnvironmentObject var vm: AppVM
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 6) {
                    ForEach(vm.log) { e in
                        HStack(spacing: 10) {
                            Text(e.ts.formatted(date: .omitted, time: .standard))
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundStyle(.secondary)
                            Text("[\(e.level.rawValue.uppercased())]").font(.system(size: 12, design: .monospaced)).foregroundStyle(.secondary)
                            Text(e.message).font(.system(size: 12, design: .monospaced))
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .onChange(of: vm.log.count) { _ in if let last = vm.log.last { withAnimation { proxy.scrollTo(last.id, anchor: .bottom) } } }
        }
        .padding(.top, 8)
    }
}
