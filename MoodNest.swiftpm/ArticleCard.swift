import SwiftUI

struct ArticleCard: View {
    let title: String
    let illustration: String // SF Symbol name
    let color: Color
    let action: () -> Void
    
    @State private var isTapped = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        Button(action: {
            // Haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .light)
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
            HStack(spacing: 16) {
                // Illustration side
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: illustration)
                        .font(.system(size: 28))
                        .foregroundColor(.deepTeal)
                }
                
                // Text side
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.deepTeal)
                        .lineLimit(2)
                    
                    Text("2 min read")
                        .font(.system(size: 12))
                        .foregroundColor(.cyanBlue)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.deepTeal)
            }
            .padding(16)
            .frame(height: 100)
            .thickBorderCard(
                backgroundColor: color.opacity(0.3),
                cornerRadius: 16
            )
            .scaleEffect(isTapped ? 0.98 : 1.0)
            .rotation3DEffect(
                .degrees(isTapped ? 3 : 0),
                axis: (x: 0, y: 1, z: 0)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ZStack {
        Color.lightSky
        
        VStack(spacing: 12) {
            ArticleCard(
                title: "Why happiness?",
                illustration: "balloon.fill",
                color: .softAqua,
                action: {}
            )
            
            ArticleCard(
                title: "Mindful breathing",
                illustration: "lungs.fill",
                color: .cyanBlue,
                action: {}
            )
        }
        .padding()
    }
}
