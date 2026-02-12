import SwiftUI

// Enhanced placeholder view for tabs with decorative backgrounds and styled content
struct PlaceholderView: View {
    let title: String
    let icon: String
    let color: Color
    let description: String
    
    @State private var iconScale: CGFloat = 1.0
    @State private var showCard = false
    
    init(title: String, icon: String, color: Color) {
        self.title = title
        self.icon = icon
        self.color = color
        
        // Feature-specific descriptions
        switch title {
        case "Move":
            self.description = "Track your physical activity and see how movement affects your mood"
        case "Sleep":
            self.description = "Log your sleep patterns and discover connections to your emotional well-being"
        case "Profile", "You":
            self.description = "Customize your experience and view your wellness insights"
        default:
            self.description = "This feature is under development"
        }
    }
    
    var body: some View {
        ZStack {
            // Decorative background with color-matched gradient
            DecorativeBackground(
                gradient: LinearGradient(
                    colors: [Color.white, color.opacity(0.15)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            ScrollView {
                VStack(spacing: 32) {
                    Spacer(minLength: 80)
                    
                    // Icon with pulse animation
                    Image(systemName: icon)
                        .font(.system(size: 100))
                        .foregroundColor(color)
                        .scaleEffect(iconScale)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                                iconScale = 1.1
                            }
                        }
                    
                    // Title
                    Text(title)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.black)
                    
                    // Description Card
                    VStack(spacing: 16) {
                        Text("Coming Soon!")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(color)
                        
                        Text(description)
                            .font(.system(size: 16))
                            .foregroundColor(.black.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.vertical, 24)
                    .padding(.horizontal, 32)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(color.opacity(0.15))
                    )
                    .padding(.horizontal, 32)
                    .opacity(showCard ? 1 : 0)
                    .offset(y: showCard ? 0 : 20)
                    
                    // Notify Button
                    Button(action: {
                        // Placeholder action - could trigger notification signup
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "bell.fill")
                            Text("Notify me when ready")
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .background(color)
                        .cornerRadius(12)
                        .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .opacity(showCard ? 1 : 0)
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                showCard = true
            }
        }
    }
}

// Enhanced placeholder detail view for modals with decorative backgrounds
struct PlaceholderDetailView: View {
    let title: String
    let icon: String
    let color: Color
    let description: String
    
    @Environment(\.dismiss) var dismiss
    @State private var showContent = false
    
    init(title: String, icon: String, color: Color) {
        self.title = title
        self.icon = icon
        self.color = color
        
        // Feature-specific descriptions
        switch title {
        case "Self-Care":
            self.description = "Personalized self-care activities and gentle reminders to nurture your well-being"
        case "Gratitude":
            self.description = "Daily gratitude practice to cultivate positivity and appreciate life's moments"
        case "Journal":
            self.description = "Express yourself freely with private journaling and reflection prompts"
        default:
            self.description = "This feature is under development"
        }
    }
    
    var body: some View {
        ZStack {
            // Decorative background
            DecorativeBackground(
                gradient: LinearGradient(
                    colors: [Color.white, color.opacity(0.1)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.gray.opacity(0.3))
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 32) {
                        Spacer(minLength: 40)
                        
                        // Icon
                        Image(systemName: icon)
                            .font(.system(size: 80))
                            .foregroundColor(color)
                            .opacity(showContent ? 1 : 0)
                            .scaleEffect(showContent ? 1 : 0.5)
                        
                        // Title
                        Text(title)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.black)
                            .opacity(showContent ? 1 : 0)
                        
                        // Description Card
                        VStack(spacing: 16) {
                            Text("Coming Soon!")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(color)
                            
                            Text(description)
                                .font(.system(size: 15))
                                .foregroundColor(.black.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(color.opacity(0.15))
                        )
                        .padding(.horizontal, 32)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                        
                        // Notify Button
                        PrimaryButton(
                            title: "Notify me when ready",
                            action: {
                                // Placeholder action
                            },
                            isEnabled: true
                        )
                        .padding(.horizontal, 32)
                        .opacity(showContent ? 1 : 0)
                        
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
        }
    }
}

#Preview("Tab Placeholder - Move") {
    PlaceholderView(title: "Move", icon: "figure.run", color: .moodSageGreen)
}

#Preview("Tab Placeholder - Sleep") {
    PlaceholderView(title: "Sleep", icon: "moon.fill", color: .moodLavender)
}

#Preview("Detail Placeholder - Self-Care") {
    PlaceholderDetailView(title: "Self-Care", icon: "sparkles", color: .moodSoftCoral)
}

#Preview("Detail Placeholder - Gratitude") {
    PlaceholderDetailView(title: "Gratitude", icon: "star.fill", color: .moodButterYellow)
}
