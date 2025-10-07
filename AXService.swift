import Cocoa
import ApplicationServices
import Carbon.HIToolbox

struct CursorWindow { let axRef: AXUIElement; let title: String }

enum AXService {
    static func cursorPID() -> pid_t? {
        NSRunningApplication.runningApplications(withBundleIdentifier: "com.cursorapp.Cursor").first?.processIdentifier
        ?? NSRunningApplication.runningApplications(withBundleIdentifier: "com.todesktop.230313mzl4w4u92").first?.processIdentifier
    }

    static func listWindows() -> [CursorWindow] {
        guard let pid = cursorPID() else { return [] }
        let app = AXUIElementCreateApplication(pid)
        var val: CFTypeRef?
        guard AXUIElementCopyAttributeValue(app, kAXWindowsAttribute as CFString, &val) == .success,
              let arr = val as? [AXUIElement] else { return [] }
        return arr.enumerated().map { (i, w) in
            var t: CFTypeRef?; AXUIElementCopyAttributeValue(w, kAXTitleAttribute as CFString, &t)
            return CursorWindow(axRef: w, title: (t as? String) ?? "Cursor Window \(i+1)")
        }
    }

    private static func key(_ code: CGKeyCode, flags: CGEventFlags = [], down: Bool, pid: pid_t) {
        if let ev = CGEvent(keyboardEventSource: nil, virtualKey: code, keyDown: down) {
            ev.flags = flags
            ev.postToPid(pid)
        }
    }

    private static func cmdL(pid: pid_t) {
        // kVK_ANSI_L = 0x25 ; Command modifier
        key(0x25, flags: .maskCommand, down: true,  pid: pid)
        key(0x25, flags: .maskCommand, down: false, pid: pid)
        usleep(200_000)
    }

    private static func typeString(_ text: String, pid: pid_t) {
        for u in text.unicodeScalars {
            let d = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: true)
            let uev = CGEvent(keyboardEventSource: nil, virtualKey: 0, keyDown: false)
            d?.keyboardSetUnicodeString(stringLength: 1, unicodeString: [UniChar(u.value)])
            uev?.keyboardSetUnicodeString(stringLength: 1, unicodeString: [UniChar(u.value)])
            d?.postToPid(pid); uev?.postToPid(pid)
            usleep(12000)
        }
    }

    /// Send text to Cursor without activating its window.
    /// Opens the input (Cmd+L), types, presses Return.
    static func send(_ message: String) -> Bool {
        guard let pid = cursorPID() else { return false }
        cmdL(pid: pid)
        typeString(message, pid: pid)
        usleep(120_000)
        key(0x24, down: true,  pid: pid)   // Return
        key(0x24, down: false, pid: pid)
        return true
    }
}