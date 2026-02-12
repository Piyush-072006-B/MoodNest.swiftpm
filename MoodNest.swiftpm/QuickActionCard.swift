import SwiftUI

struct QuickActionCard: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isTapped = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        Button(action: {
            // Haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            if !reduceMotion {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isTapped = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isTapped = false
                    }
                }
            }
            
            action()
        }) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.4))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 28))
                        .foregroundColor(.deepTeal)
                }
                
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.deepTeal)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(width: 120, height: 120)
            .thickBorderCard(
                backgroundColor: color.opacity(0.3),
                cornerRadius: 20
            )
            .scaleEffect(isTapped ? 0.95 : 1.0)
            .rotation3DEffect(
                .degrees(isTapped ? 5 : 0),
                axis: (x: 1, y: 1, z: 0)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ZStack {
        Color.lightSky
        
        HStack(spacing: 12) {
            QuickActionCard(
                title: "Daily Check-in",
                icon: "heart.fill",
                color: .softAqua,
                action: {}
            )
            
            QuickActionCard(
                title: "Self-Care",
                icon: "sparkles",
                color: .cyanBlue,
                action: {}
            )
        }
        .padding()
    }
}
