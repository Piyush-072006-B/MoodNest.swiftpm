import SwiftUI

struct DailySummaryView: View {
    @Environment(\.dismiss) var dismiss
    @State private var todayEntries: [MoodEntry] = []
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if todayEntries.isEmpty {
                    // Empty state
                    VStack(spacing: 15) {
                        Text("📊")
                            .font(.system(size: 80))
                        
                        Text("No moods logged today")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Check in with your emotions to see your daily summary")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding()
                } else {
                    // Mood entries list
                    ScrollView {
                        VStack(spacing: 15) {
                            // Header
                            VStack(spacing: 5) {
                                Text("Today's Mood Journey")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text("\(todayEntries.count) check-in\(todayEntries.count == 1 ? "" : "s")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.top)
                            
                            // Mood distribution summary
                            MoodDistributionView(entries: todayEntries)
                                .padding(.vertical)
                            
                            Divider()
                                .padding(.horizontal)
                            
                            // Timeline of moods
                            VStack(spacing: 12) {
                                ForEach(Array(todayEntries.enumerated()), id: \.offset) { index, entry in
                                    HStack(spacing: 15) {
                                        // Emoji
                                        Text(entry.emoji)
                                            .font(.system(size: 40))
                                        
                                        // Time
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(formatTime(entry.timestamp))
                                                .font(.headline)
                                            
                                            Text(timeAgo(from: entry.timestamp))
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Today's Summary")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            loadTodayEntries()
        }
    }
    
    func loadTodayEntries() {
        let allEntries = MoodDataStore.shared.loadAll()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        todayEntries = allEntries.filter { entry in
            calendar.isDate(entry.timestamp, inSameDayAs: today)
        }.sorted { $0.timestamp < $1.timestamp }
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func timeAgo(from date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        let hours = Int(interval / 3600)
        let minutes = Int((interval.truncatingRemainder(dividingBy: 3600)) / 60)
        
        if hours > 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        } else if minutes > 0 {
            return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
        } else {
            return "Just now"
        }
    }
}

struct MoodDistributionView: View {
    let entries: [MoodEntry]
    
    var moodCounts: [(emoji: String, count: Int)] {
        let grouped = Dictionary(grouping: entries) { $0.emoji }
        return grouped.map { (emoji: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Mood Distribution")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 8) {
                ForEach(moodCounts, id: \.emoji) { item in
                    HStack(spacing: 12) {
                        Text(item.emoji)
                            .font(.title2)
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                // Background
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 24)
                                
                                // Filled portion
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.blue)
                                    .frame(width: barWidth(for: item.count, in: geometry.size.width), height: 24)
                            }
                        }
                        .frame(height: 24)
                        
                        Text("\(item.count)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(width: 30, alignment: .trailing)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    func barWidth(for count: Int, in totalWidth: CGFloat) -> CGFloat {
        guard let maxCount = moodCounts.first?.count, maxCount > 0 else { return 0 }
        return totalWidth * CGFloat(count) / CGFloat(maxCount)
    }
}
