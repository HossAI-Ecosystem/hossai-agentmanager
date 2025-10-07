import AVFoundation
import Speech

final class VoiceService: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
    @Published var listening = false
    @Published var transcript = ""
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var task: SFSpeechRecognitionTask?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private let engine = AVAudioEngine()
    private let tts = AVSpeechSynthesizer()

    func speak(_ text: String) {
        let u = AVSpeechUtterance(string: text)
        u.rate = 0.46; u.pitchMultiplier = 1.04
        tts.speak(u)
    }

    func toggle() { listening ? stop() : start() }

    func start() {
        SFSpeechRecognizer.requestAuthorization { status in
            guard status == .authorized else { return }
            DispatchQueue.main.async { self.begin() }
        }
    }

    private func begin() {
        listening = true; transcript = ""
        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request else { return }
        request.shouldReportPartialResults = true

        let input = engine.inputNode
        let fmt = input.outputFormat(forBus: 0)
        input.removeTap(onBus: 0)
        input.installTap(onBus: 0, bufferSize: 1024, format: fmt) { [weak self] buf, _ in
            self?.request?.append(buf)
        }

        engine.prepare(); try? engine.start()
        task = recognizer?.recognitionTask(with: request) { [weak self] result, err in
            guard let self else { return }
            if let t = result?.bestTranscription.formattedString { self.transcript = t }
            if result?.isFinal == true || err != nil { self.stop() }
        }
    }

    func stop() {
        listening = false
        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
        request?.endAudio(); task?.cancel()
    }
}
