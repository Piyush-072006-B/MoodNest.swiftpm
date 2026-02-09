import SwiftUI

struct ContentView: View {
    @State private var showMainApp = false
    
    var body: some View {
        if showMainApp {
            MainAppView()
        } else {
            OnboardingFlowView(showMainApp: $showMainApp)
        }
    }
}

struct OnboardingFlowView: View {
    @Binding var showMainApp: Bool
    @State private var currentIndex = 0
    
    let onboardingContent = [
        "Resilience: bouncing back from challenges",
        "Mindfulness: being present in the moment",
        "It's okay to feel all emotions",
        "Self-compassion: treating yourself with kindness",
        "Growth happens outside your comfort zone",
        "You are not your thoughts"
    ]
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color(red: 0.85, green: 0.92, blue: 0.98)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Progress indicator
                HStack(spacing: 8) {
                    ForEach(0..<onboardingContent.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex ? Color.blue : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: currentIndex)
                    }
                }
                .padding(.top, 20)
                
                // Card view with content
                VStack(spacing: 20) {
                    // Emoji based on content type
                    Text(emojiForIndex(currentIndex))
                        .font(.system(size: 70))
                        .padding(.top, 30)
                    
                    // Content text
                    Text(onboardingContent[currentIndex])
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 30)
                        .lineSpacing(6)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 30)
                }
                .frame(maxWidth: .infinity)
                .frame(minHeight: 300)
                .background(Color.white)
                .cornerRadius(24)
                .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 30)
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                
                Spacer()
                
                // Next/Get Started button
                Button(action: {
                    if currentIndex < onboardingContent.count - 1 {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            currentIndex += 1
                        }
                    } else {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            showMainApp = true
                        }
                    }
                }) {
                    Text(currentIndex < onboardingContent.count - 1 ? "Next" : "Get Started")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.4, green: 0.6, blue: 1.0),
                                    Color(red: 0.3, green: 0.5, blue: 0.9)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: Color(red: 0.4, green: 0.6, blue: 1.0).opacity(0.4), radius: 12, x: 0, y: 6)
                }
                .padding(.horizontal, 40)
                
                // Skip button
                if currentIndex < onboardingContent.count - 1 {
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            showMainApp = true
                        }
                    }) {
                        Text("Skip")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 10)
                }
                
                Spacer()
                    .frame(height: 30)
            }
        }
    }
    
    // Helper function to return emoji based on index
    func emojiForIndex(_ index: Int) -> String {
        let emojis = ["💪", "🧘‍♀️", "💙", "🤗", "🌱", "🧠"]
        return emojis[index % emojis.count]
    }
}

struct MainAppView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.97, blue: 1.0),
                    Color(red: 0.90, green: 0.95, blue: 0.98)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("🎉")
                    .font(.system(size: 80))
                
                Text("Welcome to MindTrack!")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Text("You're ready to start your mental health journey")
                    .font(.system(size: 18, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                VStack(spacing: 15) {
                    FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Track your mood daily")
                    FeatureRow(icon: "heart.text.square", title: "Reflect on your feelings")
                    FeatureRow(icon: "book", title: "Learn mental health concepts")
                }
                .padding(.top, 20)
            }
            .padding()
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.blue)
                .frame(width: 40)
            
            Text(title)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 30)
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

