import SwiftUI

struct ModernCheckInView: View {
    @State private var selectedMood: String?
    @State private var note: String = ""
    @State private var showConfirmation = false
    @State private var showConfetti = false
    @State private var todayEntries: [MoodEntry] = []
    @Environment(\.dismiss) var dismiss
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        ZStack {
            // Animated background
            Color.lightSky
                .overlay(
                    AnimatedBackground(
                        particleType: .sparkle,
                        particleCount: 25,
                        colors: [.softAqua, .cyanBlue, .deepTeal.opacity(0.3)]
                    )
                    .opacity(0.3)
                )
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.deepTeal.opacity(0.3))
                    }
                    
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "calendar")
                            .font(.system(size: 24))
                            .foregroundColor(.deepTeal.opacity(0.5))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Title Section
                        VStack(spacing: 8) {
                            Text("How are you")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.deepTeal)
                            
                            Text("feeling today?")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.deepTeal)
                            
                            Text("Tap to select your mood")
                                .font(.system(size: 16))
                                .foregroundColor(.cyanBlue)
                                .padding(.top, 4)
                        }
                        .padding(.top, 20)
                        
                        // Mood Selector with enhanced design
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach([
                                    ("😃", "Great", Color.cyanBlue),
                                    ("🙂", "Good", Color.softAqua),
                                    ("😐", "Okay", Color.softAqua.opacity(0.6)),
                                    ("🙁", "Sad", Color.deepTeal),
                                    ("😢", "Down", Color.deepTeal.opacity(0.8))
                                ], id: \.0) { emoji, label, color in
                                    MoodButton(
                                        emoji: emoji,
                                        label: label,
                                        color: color,
                                        isSelected: selectedMood == emoji,
                                        reduceMotion: reduceMotion
                                    ) {
                                        withAnimation(reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.6)) {
                                            selectedMood = emoji
                                        }
                                        // Haptic feedback
                                        let generator = UIImpactFeedbackGenerator(style: .medium)
                                        generator.impactOccurred()
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Note Input with glassmorphism
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Add a note (optional)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.cyanBlue)
                            
                            TextField("What's on your mind?", text: $note, axis: .vertical)
                                .font(.system(size: 16))
                                .padding(16)
                                .lineLimit(3...6)
                                .glassCard(cornerRadius: 16, borderWidth: 2)
                        }
                        .padding(.horizontal, 20)
                        
                        // Save Button
                        PrimaryButton(
                            title: "Save Mood",
                            action: saveMood,
                            isEnabled: selectedMood != nil
                        )
                        .padding(.horizontal, 20)
                        
                        // Confirmation Message
                        if showConfirmation {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.deepTeal)
                                Text("Mood saved!")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.deepTeal)
                            }
                            .transition(reduceMotion ? .opacity : .scale.combined(with: .opacity))
                        }
                        
                        // Today's Entries
                        if !todayEntries.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Today's Check-ins")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.deepTeal)
                                
                                ForEach(todayEntries) { entry in
                                    TodayEntryCard(entry: entry)
                                        .transition(reduceMotion ? .opacity : .opacity.combined(with: .move(edge: .top)))
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            
            // Confetti overlay
            if showConfetti {
                ConfettiView(particleCount: 60)
                    .allowsHitTesting(false)
            }
        }
        .onAppear {
            loadTodayEntries()
        }
    }
    
    func saveMood() {
        guard let mood = selectedMood else { return }
        
        let entry = MoodEntry(
            emoji: mood,
            timestamp: Date(),
            note: note.isEmpty ? nil : note
        )
        
        MoodDataStore.shared.save(entry)
        
        // Show confetti
        withAnimation(reduceMotion ? .none : .spring(response: 0.5, dampingFraction: 0.7)) {
            showConfetti = true
            showConfirmation = true
        }
        
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Reset form
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(reduceMotion ? .none : .easeInOut) {
                showConfetti = false
                showConfirmation = false
                selectedMood = nil
                note = ""
                loadTodayEntries()
            }
        }
    }
    
    func loadTodayEntries() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        todayEntries = MoodDataStore.shared.loadAll().filter { entry in
            calendar.isDate(entry.timestamp, inSameDayAs: today)
        }.sorted { $0.timestamp > $1.timestamp }
    }
}

// Enhanced mood button with thick borders
struct MoodButton: View {
    let emoji: String
    let label: String
    let color: Color
    let isSelected: Bool
    let reduceMotion: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(emoji)
                    .font(.system(size: 60))
                    .frame(width: 90, height: 90)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(isSelected ? color : color.opacity(0.2))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .strokeBorder(Color.deepTeal, lineWidth: isSelected ? 4 : 3)
                    )
                    .shadow(
                        color: isSelected ? color.opacity(0.5) : .clear,
                        radius: isSelected ? 16 : 0
                    )
                    .scaleEffect(isSelected ? 1.05 : 1.0)
                
                Text(label)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.cyanBlue)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .animation(reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct TodayEntryCard: View {
    let entry: MoodEntry
    
    var body: some View {
        HStack(spacing: 12) {
            Text(entry.emoji)
                .font(.system(size: 32))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(formatTime(entry.timestamp))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.deepTeal)
                
                if let note = entry.note, !note.isEmpty {
                    Text(note)
                        .font(.system(size: 12))
                        .foregroundColor(.cyanBlue)
                        .lineLimit(1)
                }
            }
            
            Spacer()
        }
        .padding(12)
        .glassCard(cornerRadius: 12)
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    ModernCheckInView()
}
