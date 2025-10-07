import SwiftUI

enum T {
    // Colors – restrained, readable
    static let bgTop     = Color(red: 0.11, green: 0.12, blue: 0.15)
    static let bgBottom  = Color(red: 0.06, green: 0.05, blue: 0.07)
    static let card      = Color.white.opacity(0.06)
    static let stroke    = Color.white.opacity(0.08)
    static let hi        = Color(red: 1.00, green: 0.56, blue: 0.12)
    static let good      = Color.green
    static let warn      = Color.orange
    static let bad       = Color.red

    // Layout
    static let pad: CGFloat = 12
    static let radius: CGFloat = 14

    static var background: some View {
        LinearGradient(colors: [bgTop, bgBottom], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }

    static func cardBG() -> some View {
        RoundedRectangle(cornerRadius: radius).fill(card)
            .overlay(RoundedRectangle(cornerRadius: radius).stroke(stroke))
    }
}
