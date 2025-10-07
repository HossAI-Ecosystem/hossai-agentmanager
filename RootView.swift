import SwiftUI

struct RootView: View {
    @EnvironmentObject var vm: AppVM
    @StateObject private var voice = VoiceService()
    @State private var tab: Tab = .windows
    enum Tab: String, CaseIterable, Identifiable { case windows = "Windows", control = "Control", logs = "Logs"; var id: String { rawValue } }

    var body: some View {
        ZStack { T.background
            NavigationSplitView {
                Sidebar()
            } detail: {
                VStack(spacing: 12) {
                    Header(voice: voice)
                    Picker("", selection: $tab) {
                        ForEach(Tab.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    switch tab {
                    case .windows: WindowsTab()
                    case .control: ControlTab(voice: voice)
                    case .logs: LogsTab()
                    }
                }
                .padding(.bottom, 8)
            }
        }
        .onAppear { vm.startAutoScan(); vm.refreshWindows() }
        .onDisappear { vm.stopAutoScan() }
    }
}

struct Header: View {
    @EnvironmentObject var vm: AppVM
    @ObservedObject var voice: VoiceService
    var body: some View {
        HStack(spacing: 12) {
            // Logo + title
            Circle().fill(LinearGradient(colors: [.purple.opacity(0.6), T.hi.opacity(0.6)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 36, height: 36)
                .overlay(Circle().stroke(T.stroke, lineWidth: 1))
            VStack(alignment: .leading, spacing: 2) {
                Text("HossAI Core").font(.headline).foregroundStyle(.white)
                Text("Aura — Your AI Agent").font(.caption).foregroundStyle(.white.opacity(0.7))
            }
            Spacer()
            Button {
                voice.toggle()                    // this requests permission on first use
            } label: {
                Label(voice.listening ? "Mic On" : "Mic", systemImage: voice.listening ? "waveform.circle.fill" : "mic.circle.fill")
                    .labelStyle(.titleAndIcon)
            }
            .buttonStyle(.borderedProminent)
            .tint(voice.listening ? .red : .purple)

            Toggle("Speak replies", isOn: $vm.speakReplies).toggleStyle(.switch)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}
