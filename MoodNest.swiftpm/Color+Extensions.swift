import SwiftUI
import UIKit

extension Color {
    // ========================================
    // MOODNEST ADAPTIVE TEAL/AQUA COLOR PALETTE
    // ========================================
    
    // Primary Palette with Dark Mode support
    static let deepTeal = adaptiveColor(light: "#09637E", dark: "#7AB2B2") // Swapped/Muted in dark
    static let cyanBlue = adaptiveColor(light: "#088395", dark: "#0BC6E0") // Brighter in dark
    static let softAqua = adaptiveColor(light: "#7AB2B2", dark: "#09637E") // Swapped in dark
    static let lightSky = adaptiveColor(light: "#EBF4F6", dark: "#0A1F24") // Very dark background
    
    // ========================================
    // UI ELEMENT COLORS
    // ========================================
    
    static let mainBackground = lightSky
    static let cardBackground = softAqua.opacity(0.15)
    static let primaryAction = cyanBlue
    static let primaryAccent = deepTeal
    static let border = deepTeal
    static let glassBorder = Color.white.opacity(0.3)
    static let shadowColor = Color.black.opacity(0.1)
    
    // ========================================
    // MOOD-SPECIFIC COLORS (Adaptive & Legacy)
    // ========================================
    
    // Core Moods (Adaptive)
    static let moodGreat = cyanBlue
    static let moodGood = softAqua
    static let moodOkay = softAqua.opacity(0.5)
    static let moodSad = deepTeal
    static let moodDown = deepTeal.opacity(0.7)
    
    // Specific Legacy Colors (Requested for Onboarding & Placeholders)
    static let moodSkyBlue = Color(hex: "#A7D7FF")
    static let moodSageGreen = Color(hex: "#A9CFA4")
    static let moodMintGreen = Color(hex: "#B2F2BB") // Complementary mint
    static let moodLavender = Color(hex: "#C5B3FF")
    static let moodSoftCoral = Color(hex: "#FFB6A5")
    static let moodButterYellow = Color(hex: "#FFF7AE")
    static let moodPeachyPink = Color(hex: "#FFD1DC") // Complementary peach
    
    // ========================================
    // TEXT COLORS
    // ========================================
    
    static let textPrimary = adaptiveColor(light: "#09637E", dark: "#EBF4F6")
    static let textSecondary = adaptiveColor(light: "#088395", dark: "#7AB2B2")
    static let textTertiary = adaptiveColor(light: "#7AB2B2", dark: "#088395")
    
    // ========================================
    // HELPERS
    // ========================================
    
    private static func adaptiveColor(light: String, dark: String) -> Color {
        return Color(UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(hex: dark) : UIColor(hex: light)
        })
    }
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, alpha: Double(a) / 255)
    }
}
