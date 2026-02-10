import SwiftUI

struct MoodCheckInView: View {
    @State private var savedMessage = ""
    @State private var showMessage = false
    @State private var showDailySummary = false
    @State private var showHistory = false
    @State private var showAwareness = false
    
    let moods = ["😃", "🙂", "😐", "🙁", "😢"]
    let moodLabels = ["Great", "Good", "Okay", "Sad", "Very Sad"]
    
    var body: some View {
        
            
       
        VStack(spacing: 40) {
            Spacer()
            
            // Title
            Text("MoodNest")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            // Question
            Text("How are you feeling right now?")
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Mood Buttons
            VStack(spacing: 20) {
                ForEach(0..<moods.count, id: \.self) { index in
                    Button(action: {
                        saveMood(emoji: moods[index])
                    }) {
                        HStack(spacing: 15) {
                            Text(moods[index])
                                .font(.system(size: 40))
                            
                            Text(moodLabels[index])
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal, 40)
            
            // Confirmation Message
            if showMessage {
                Text(savedMessage)
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .fontWeight(.semibold)
                    .transition(.opacity)
            }
            
            Spacer()
            
            // Navigation Buttons
            VStack(spacing: 12) {
                Button(action: {
                    showDailySummary = true
                }) {
                    HStack {
                        Image(systemName: "chart.bar.fill")
                        Text("See Today's Summary")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                
                Button(action: {
                    showHistory = true
                }) {
                    HStack {
                        Image(systemName: "book.fill")
                        Text("View History")
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                }
                
                Button(action: {
                    showAwareness = true
                }) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                        Text("Mental Health Awareness")
                    }
                    .font(.headline)
                    .foregroundColor(.purple)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal, 40)
            
            // Debug Button
            Button(action: {
                showAllEntries()
            }) {
                Text("Show All Entries")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding(.bottom, 20)
        }
        .sheet(isPresented: $showDailySummary) {
            DailySummaryView()
        }
        .sheet(isPresented: $showHistory) {
            HistoryView()
        }
        .sheet(isPresented: $showAwareness) {
            AwarenessView()
        }
    }
    
    func saveMood(emoji: String) {
        let entry = MoodEntry(emoji: emoji, timestamp: Date())
        MoodDataStore.shared.save(entry)
        
        withAnimation {
            savedMessage = "Mood saved! \(emoji)"
            showMessage = true
        }
        
        // Hide message after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showMessage = false
            }
        }
    }
    
    func showAllEntries() {
        let entries = MoodDataStore.shared.loadAll()
        print("=== All Mood Entries ===")
        if entries.isEmpty {
            print("No entries found.")
        } else {
            for (index, entry) in entries.enumerated() {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                print("\(index + 1). \(entry.emoji) - \(formatter.string(from: entry.timestamp))")
            }
        }
        print("========================")
    }
}
//#Preview{
//    MoodCheckInView()
//}
