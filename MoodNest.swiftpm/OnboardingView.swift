import SwiftUI

struct OnboardingView: View {
    @Binding var showMoodCheck: Bool
    @State private var currentPage = 0
    @State private var selectedCards: [OnboardingCard] = []
    
    // Larger pool of motivational thoughts and mental health vocabulary
    let allOnboardingContent = [
        OnboardingCard(
            title: "Mindfulness",
            description: "Take a moment to check in with yourself. Your mental health matters.",
            emoji: "🧘‍♀️"
        ),
        OnboardingCard(
            title: "Resilience",
            description: "Track your emotions and build emotional awareness over time.",
            emoji: "💪"
        ),
        OnboardingCard(
            title: "Self-Care",
            description: "Understanding your moods is the first step to better well-being.",
            emoji: "💚"
        ),
        OnboardingCard(
            title: "Gratitude",
            description: "Practicing gratitude can shift your perspective and improve your mood.",
            emoji: "🙏"
        ),
        OnboardingCard(
            title: "Emotional Intelligence",
            description: "Recognizing and naming your emotions helps you manage them better.",
            emoji: "🧠"
        ),
        OnboardingCard(
            title: "Self-Compassion",
            description: "Be kind to yourself. You deserve the same compassion you give others.",
            emoji: "🤗"
        ),
        OnboardingCard(
            title: "Present Moment",
            description: "The present moment is all we truly have. Stay grounded in the now.",
            emoji: "🌸"
        ),
        OnboardingCard(
            title: "Inner Peace",
            description: "Finding calm within yourself is a powerful tool for mental wellness.",
            emoji: "☮️"
        ),
        OnboardingCard(
            title: "Growth Mindset",
            description: "Every challenge is an opportunity to learn and grow stronger.",
            emoji: "🌱"
        ),
        OnboardingCard(
            title: "Emotional Balance",
            description: "All emotions are valid. Balance comes from acknowledging them all.",
            emoji: "⚖️"
        )
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            if !selectedCards.isEmpty {
                // Emoji
                Text(selectedCards[currentPage].emoji)
                    .font(.system(size: 100))
                    .padding(.bottom, 20)
                    .transition(.scale.combined(with: .opacity))
                
                // Title
                Text(selectedCards[currentPage].title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                
                // Description
                Text(selectedCards[currentPage].description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 40)
                    .transition(.opacity)
            }
            
            Spacer()
            
            // Page Indicators
            HStack(spacing: 8) {
                ForEach(0..<selectedCards.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: currentPage)
                }
            }
            .padding(.bottom, 20)
            
            // Button
            Button(action: {
                if currentPage < selectedCards.count - 1 {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        currentPage += 1
                    }
                } else {
                    withAnimation {
                        showMoodCheck = true
                    }
                }
            }) {
                Text(currentPage < selectedCards.count - 1 ? "Next" : "Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
            }
            .padding(.bottom, 40)
        }
        .onAppear {
            // Randomly select 3 non-repeating cards
            selectedCards = allOnboardingContent.shuffled().prefix(3).map { $0 }
        }
    }
}

struct OnboardingCard {
    let title: String
    let description: String
    let emoji: String
}
