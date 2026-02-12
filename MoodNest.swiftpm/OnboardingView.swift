import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var selectedCards: [OnboardingCard] = []
    var onComplete: () -> Void
    
    // 10 motivational thoughts and mental health concepts
    let allOnboardingContent = [
        OnboardingCard(
            title: "Mindfulness",
            description: "Take a moment to check in with yourself. Your mental health matters.",
            emoji: "🧘‍♀️",
            color: .moodSkyBlue
        ),
        OnboardingCard(
            title: "Resilience",
            description: "Track your emotions and build emotional awareness over time.",
            emoji: "💪",
            color: .moodMintGreen
        ),
        OnboardingCard(
            title: "Self-Care",
            description: "Understanding your moods is the first step to better well-being.",
            emoji: "💚",
            color: .moodSageGreen
        ),
        OnboardingCard(
            title: "Gratitude",
            description: "Practicing gratitude can shift your perspective and improve your mood.",
            emoji: "🙏",
            color: .moodButterYellow
        ),
        OnboardingCard(
            title: "Emotional Intelligence",
            description: "Recognizing and naming your emotions helps you manage them better.",
            emoji: "🧠",
            color: .moodLavender
        ),
        OnboardingCard(
            title: "Self-Compassion",
            description: "Be kind to yourself. You deserve the same compassion you give others.",
            emoji: "🤗",
            color: .moodPeachyPink
        ),
        OnboardingCard(
            title: "Present Moment",
            description: "The present moment is all we truly have. Stay grounded in the now.",
            emoji: "🌸",
            color: .moodSoftCoral
        ),
        OnboardingCard(
            title: "Inner Peace",
            description: "Finding calm within yourself is a powerful tool for mental wellness.",
            emoji: "☮️",
            color: .moodSkyBlue
        ),
        OnboardingCard(
            title: "Growth Mindset",
            description: "Every challenge is an opportunity to learn and grow stronger.",
            emoji: "🌱",
            color: .moodSageGreen
        ),
        OnboardingCard(
            title: "Emotional Balance",
            description: "All emotions are valid. Balance comes from acknowledging them all.",
            emoji: "⚖️",
            color: .moodLavender
        )
    ]
    
    var body: some View {
        ZStack {
            // Decorative background
            DecorativeBackground()
            
            VStack(spacing: 0) {
                Spacer(minLength: 60)
                
                if !selectedCards.isEmpty {
                    // Card content
                    VStack(spacing: 32) {
                        // Emoji
                        Text(selectedCards[currentPage].emoji)
                            .font(.system(size: 100))
                            .transition(.scale.combined(with: .opacity))
                            .id("emoji-\(currentPage)")
                        
                        // Title
                        Text(selectedCards[currentPage].title)
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.black)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                            .id("title-\(currentPage)")
                        
                        // Description Card
                        Text(selectedCards[currentPage].description)
                            .font(.system(size: 18))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black.opacity(0.8))
                            .padding(.horizontal, 40)
                            .padding(.vertical, 24)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(selectedCards[currentPage].color.opacity(0.2))
                            )
                            .padding(.horizontal, 32)
                            .transition(.opacity)
                            .id("description-\(currentPage)")
                    }
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentPage)
                }
                
                Spacer(minLength: 60)
                
                // Page Indicators
                HStack(spacing: 10) {
                    ForEach(0..<selectedCards.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.moodSkyBlue : Color.gray.opacity(0.3))
                            .frame(width: 10, height: 10)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                    }
                }
                .padding(.bottom, 32)
                
                // Button
                PrimaryButton(
                    title: currentPage < selectedCards.count - 1 ? "Next" : "Get Started",
                    action: handleButtonTap,
                    isEnabled: true
                )
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            // Randomly select 3 non-repeating cards
            selectedCards = allOnboardingContent.shuffled().prefix(3).map { $0 }
        }
    }
    
    func handleButtonTap() {
        if currentPage < selectedCards.count - 1 {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                currentPage += 1
            }
        } else {
            // Mark onboarding complete and dismiss
            OnboardingManager.markOnboardingComplete()
            withAnimation {
                onComplete()
            }
        }
    }
}

struct OnboardingCard: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let emoji: String
    let color: Color
}

#Preview {
    OnboardingView(onComplete: {})
}
