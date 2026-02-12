import SwiftUI

struct MoodEmojiSelector: View {
    @Binding var selectedMood: String?
    var reduceMotion: Bool = false
    
    // Using the new teal/aqua palette
    let moods = [
        ("😃", "Great", Color.cyanBlue),
        ("🙂", "Good", Color.softAqua),
        ("😐", "Okay", Color.softAqua.opacity(0.6)),
        ("🙁", "Sad", Color.deepTeal),
        ("😢", "Down", Color.deepTeal.opacity(0.8))
    ]
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(moods, id: \.0) { emoji, label, color in
                VStack(spacing: 8) {
                    Text(emoji)
                        .font(.system(size: 60))
                        .frame(width: 80, height: 80)
                        .background(
                            Circle()
                                .fill(color.opacity(0.2)) // Softer background
                                .overlay(
                                    Circle()
                                        .strokeBorder(color, lineWidth: selectedMood == emoji ? 4 : 2)
                                )
                                .shadow(
                                    color: selectedMood == emoji ? color.opacity(0.4) : .clear,
                                    radius: selectedMood == emoji ? 8 : 0
                                )
                        )
                        .scaleEffect(selectedMood == emoji ? 1.1 : 1.0)
                        .animation(reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.7), value: selectedMood)
                    
                    Text(label)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.deepTeal) // Unified text color
                }
                .onTapGesture {
                    withAnimation {
                        selectedMood = emoji
                    }
                    // Haptic feedback
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                }
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedMood: String? = "🙂"
        
        var body: some View {
            VStack {
                MoodEmojiSelector(selectedMood: $selectedMood)
                
                Text(selectedMood ?? "None")
                    .padding()
            }
        }
    }
    
    return PreviewWrapper()
}
