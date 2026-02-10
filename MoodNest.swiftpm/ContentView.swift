import SwiftUI

struct ContentView: View {
    @State private var showMoodCheck = false
    
    var body: some View {
        if showMoodCheck {
            MoodCheckInView()
        } else {
            OnboardingView(showMoodCheck: $showMoodCheck)
        }
    }
}

