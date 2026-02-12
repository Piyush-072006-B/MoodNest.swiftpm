import SwiftUI

struct ContentView: View {
    @State private var showOnboarding = !OnboardingManager.hasCompletedOnboarding()
    @AppStorage("appTheme") private var appTheme: String = "System"
    
    var body: some View {
        Group {
            if showOnboarding {
                OnboardingView(onComplete: {
                    showOnboarding = false
                })
            } else {
                NewHomeView()
            }
        }
        .preferredColorScheme(colorScheme)
    }
    
    private var colorScheme: ColorScheme? {
        switch appTheme {
        case "Light": return .light
        case "Dark": return .dark
        default: return nil // System
        }
    }
}
