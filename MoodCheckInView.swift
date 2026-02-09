import SwiftUI

// MARK: - Mood Check-In View
struct MoodCheckInView: View {
    @State private var selectedMood: String?
    @State private var showThankYou = false
    @State private var totalEntries = 0
    
    let moods = ["😃", "🙂", "😐", "🙁", "😢"]
    let moodLabels = ["Great", "Good", "Okay", "Bad", "Very Bad"]
    
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
            
            VStack(spacing: 30) {
                Spacer()
                
                // Header
                VStack(spacing: 15) {
                    Text("💭")
                        .font(.system(size: 70))
                    
                    Text("How are you feeling right now?")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 30)
                }
                
                // Mood buttons card
                VStack(spacing: 25) {
                    Text("Tap an emoji")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                        .padding(.top, 20)
                    
                    // Emoji buttons
                    HStack(spacing: 15) {
                        ForEach(Array(moods.enumerated()), id: \.offset) { index, emoji in
                            MoodButton(
                                emoji: emoji,
                                label: moodLabels[index],
                                isSelected: selectedMood == emoji
                            ) {
                                saveMood(emoji: emoji)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 25)
                }
                .background(Color.white)
                .cornerRadius(24)
                .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 20)
                
                // Thank you message
                if showThankYou {
                    VStack(spacing: 10) {
                        Text("✨")
                            .font(.system(size: 50))
                        
                        Text("Mood saved!")
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundColor(.green)
                        
                        Text("Total entries: \(totalEntries)")
                            .font(.system(size: 16, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
                    .transition(.scale.combined(with: .opacity))
                }
                
                Spacer()
                
                // Debug/Testing buttons
                VStack(spacing: 15) {
                    // Show All Entries button
                    Button(action: showAllEntries) {
                        HStack {
                            Image(systemName: "list.bullet.rectangle")
                                .font(.system(size: 18))
                            Text("Show All Entries (Console)")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                        }
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    }
                    
                    // Clear All button (for testing)
                    Button(action: clearAllEntries) {
                        HStack {
                            Image(systemName: "trash")
                                .font(.system(size: 18))
                            Text("Clear All Entries")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
                    .frame(height: 20)
            }
        }
        .onAppear {
            updateTotalEntries()
        }
    }
    
    // MARK: - Helper Methods
    
    private func saveMood(emoji: String) {
        print("\n🎯 User tapped: \(emoji)")
        
        // Create new mood entry
        let entry = MoodEntry(emoji: emoji)
        
        // Save using MoodDataStore
        MoodDataStore.shared.save(entry)
        
        // Update UI
        selectedMood = emoji
        updateTotalEntries()
        
        // Show thank you message
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            showThankYou = true
        }
        
        // Hide thank you message after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showThankYou = false
                selectedMood = nil
            }
        }
        
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    private func showAllEntries() {
        print("\n🔍 Show All Entries button tapped")
        
        // Print all entries to console
        MoodDataStore.shared.printAll()
        
        // Also load and display count
        let entries = MoodDataStore.shared.loadAll()
        print("📊 Total entries loaded: \(entries.count)")
    }
    
    private func clearAllEntries() {
        print("\n🗑️ Clear All button tapped")
        
        MoodDataStore.shared.clearAll()
        updateTotalEntries()
        
        // Show feedback
        withAnimation {
            showThankYou = false
            selectedMood = nil
        }
    }
    
    private func updateTotalEntries() {
        totalEntries = MoodDataStore.shared.getTotalCount()
    }
}

// MARK: - Mood Button Component
struct MoodButton: View {
    let emoji: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(emoji)
                    .font(.system(size: 44))
                
                Text(label)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(width: 65, height: 85)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
struct MoodCheckInView_Previews: PreviewProvider {
    static var previews: some View {
        MoodCheckInView()
    }
}
