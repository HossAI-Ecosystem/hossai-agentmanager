import SwiftUI

struct ControlTab: View {
    @EnvironmentObject var vm: AppVM
    @ObservedObject var voice: VoiceService

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Picker("Agent", selection: $vm.selectedAgentName) {
                    ForEach(vm.agents.map{$0.name}, id: \.self) { Text($0).tag($0) }
                }.pickerStyle(.menu)

                Button {
                    voice.toggle()
                } label: {
                    Label(voice.listening ? "Stop Mic" : "Mic", systemImage: voice.listening ? "stop.circle.fill" : "mic.circle.fill")
                }
                .buttonStyle(.borderedProminent)
                .tint(voice.listening ? .red : .purple)
            }

            if voice.listening {
                Text("Listening… \(voice.transcript)").font(.caption).foregroundStyle(.secondary)
            }

            ZStack(alignment: .leading) {
                if vm.input.isEmpty { Text("Type here…").foregroundStyle(.secondary) }
                TextEditor(text: Binding(
                    get: { vm.input.isEmpty ? voice.transcript : vm.input },
                    set: { vm.input = $0 }
                ))
                .frame(minHeight: 80, maxHeight: 140)
                .padding(6)
            }
            .background(T.cardBG())

            HStack {
                Button { vm.sendToCursor() } label: { Label("Send", systemImage: "paperplane.fill") }
                    .buttonStyle(.borderedProminent).tint(T.hi)
                Spacer()
            }

            Divider().opacity(0.3)
            Text("Chat").font(.headline)
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(vm.messages) { m in MessageBubble(m: m).id(m.id) }
                    }
                }
                .onChange(of: vm.messages.count) { _ in if let last = vm.messages.last { withAnimation { proxy.scrollTo(last.id, anchor: .bottom) } } }
            }
        }
        .padding(.horizontal)
    }
}

struct MessageBubble: View {
    let m: ChatMessage
    var isUser: Bool { m.role == .user }
    var body: some View {
        HStack(alignment: .top) {
            if isUser { Spacer(minLength: 40) }
            VStack(alignment: .leading, spacing: 8) {
                switch m.content {
                case .markdown(let md):
                    if let attr = try? AttributedString(markdown: md) { Text(attr) } else { Text(md) }
                case .code(let code, _):
                    ScrollView(.horizontal) {
                        Text(code).font(.system(.body, design: .monospaced)).padding(8)
                    }
                    .background(T.cardBG())
                }
                Text(m.ts.formatted(date: .omitted, time: .shortened)).font(.caption2).foregroundStyle(.secondary)
            }
            .padding(T.pad)
            .background(T.cardBG())
            if !isUser { Spacer(minLength: 40) }
        }
        .padding(.horizontal)
    }
}
