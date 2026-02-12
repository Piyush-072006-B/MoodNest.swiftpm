import SwiftUI

// Empty state component with friendly illustrations (Teal/Aqua theme)
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    @State private var isAnimating = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 64))
                .foregroundColor(.softAqua.opacity(0.7))
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(
                    reduceMotion ? .none : .easeInOut(duration: 2).repeatForever(autoreverses: true),
                    value: isAnimating
                )
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.deepTeal)
                
                Text(message)
                    .font(.system(size: 15))
                    .foregroundColor(.cyanBlue)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [.cyanBlue, .deepTeal],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
        .padding(40)
        .onAppear {
            if !reduceMotion {
                isAnimating = true
            }
        }
    }
}

#Preview {
    ZStack {
        Color.lightSky
        
        VStack(spacing: 40) {
            EmptyStateView(
                icon: "book.closed.fill",
                title: "Start journaling today",
                message: "Capture your thoughts and reflect on your day"
            )
            
            EmptyStateView(
                icon: "sparkles",
                title: "No gratitude entries yet",
                message: "Begin your gratitude practice and watch positivity grow",
                actionTitle: "Add First Entry",
                action: {}
            )
        }
    }
}
