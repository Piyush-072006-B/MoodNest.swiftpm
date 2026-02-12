import SwiftUI

struct MoodGradients {
    // Header gradient: Cyan Blue to Deep Teal
    static let header = LinearGradient(
        colors: [Color.cyanBlue, Color.deepTeal],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    // Button gradient: Cyan Blue to Deep Teal
    static let button = LinearGradient(
        colors: [Color.cyanBlue, Color.deepTeal],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    // Primary Button gradient (alias for button for compatibility)
    static let primaryButton = button
    
    // Background gradient: Light Sky to Soft Aqua (subtle)
    static let background = LinearGradient(
        colors: [Color.lightSky, Color.softAqua.opacity(0.2)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    // Soft Background (alias for background for compatibility)
    static let softBackground = background
    
    // Card gradient: Soft Aqua (subtle)
    static let card = LinearGradient(
        colors: [Color.softAqua.opacity(0.3), Color.softAqua.opacity(0.1)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
