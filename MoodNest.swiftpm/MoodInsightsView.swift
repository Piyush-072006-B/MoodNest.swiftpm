import SwiftUI

struct MoodInsightsView: View {
    @State private var moodEntries: [MoodEntry] = []
    @State private var currentStreak = 0
    @State private var longestStreak = 0
    @Environment(\.dismiss) var dismiss
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        ZStack {
            DecorativeBackground(
                gradient: LinearGradient(
                    colors: [Color.lightSky, Color.softAqua.opacity(0.1)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.deepTeal.opacity(0.3))
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.cyanBlue)
                        
                        Text("Mood Insights")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.deepTeal)
                    }
                    
                    Spacer()
                    
                    Button(action: exportCSV) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 24))
                            .foregroundColor(.cyanBlue)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .background(Color.lightSky)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Streak Cards
                        HStack(spacing: 12) {
                            StreakCard(
                                title: "Current Streak",
                                count: currentStreak,
                                icon: "flame.fill",
                                color: .cyanBlue
                            )
                            
                            StreakCard(
                                title: "Longest Streak",
                                count: longestStreak,
                                icon: "star.fill",
                                color: .softAqua
                            )
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        
                        // Weekly Distribution
                        VStack(alignment: .leading, spacing: 12) {
                            Text("This Week")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.deepTeal)
                                .padding(.horizontal, 20)
                            
                            WeeklyMoodChart(entries: getWeeklyEntries())
                                .padding(.horizontal, 16)
                        }
                        
                        // Monthly Summary
                        VStack(alignment: .leading, spacing: 12) {
                            Text("This Month")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.deepTeal)
                                .padding(.horizontal, 20)
                            
                            MonthlyMoodSummary(entries: getMonthlyEntries())
                                .padding(.horizontal, 16)
                        }
                        
                        // Most Frequent Mood
                        if let mostFrequent = getMostFrequentMood() {
                            VStack(spacing: 12) {
                                Text("Most Frequent Mood")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.deepTeal)
                                
                                HStack(spacing: 16) {
                                    Text(mostFrequent.emoji)
                                        .font(.system(size: 60))
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("\(mostFrequent.count) times")
                                            .font(.system(size: 24, weight: .bold))
                                            .foregroundColor(.deepTeal)
                                        
                                        Text("this month")
                                            .font(.system(size: 14))
                                            .foregroundColor(.softAqua)
                                    }
                                }
                                .padding(20)
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: Color.deepTeal.opacity(0.1), radius: 8, x: 0, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color.softAqua.opacity(0.3), lineWidth: 1)
                                )
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            loadData()
        }
    }
    
    func loadData() {
        moodEntries = MoodDataStore.shared.loadAll()
        calculateStreaks()
    }
    
    func calculateStreaks() {
        guard !moodEntries.isEmpty else {
            currentStreak = 0
            longestStreak = 0
            return
        }
        
        let calendar = Calendar.current
        let sortedEntries = moodEntries.sorted { $0.timestamp > $1.timestamp }
        
        var uniqueDays: Set<Date> = []
        for entry in sortedEntries {
            let day = calendar.startOfDay(for: entry.timestamp)
            uniqueDays.insert(day)
        }
        
        let sortedDays = uniqueDays.sorted(by: >)
        
        // Calculate current streak
        var streak = 0
        let today = calendar.startOfDay(for: Date())
        
        for day in sortedDays {
            let expectedDay = calendar.date(byAdding: .day, value: -streak, to: today)!
            if calendar.isDate(day, inSameDayAs: expectedDay) {
                streak += 1
            } else {
                break
            }
        }
        
        currentStreak = streak
        
        // Calculate longest streak
        var maxStreak = 0
        var tempStreak = 1
        
        for i in 0..<sortedDays.count - 1 {
            let diff = calendar.dateComponents([.day], from: sortedDays[i+1], to: sortedDays[i]).day ?? 0
            if diff == 1 {
                tempStreak += 1
                maxStreak = max(maxStreak, tempStreak)
            } else {
                tempStreak = 1
            }
        }
        
        longestStreak = max(maxStreak, streak)
    }
    
    func getWeeklyEntries() -> [MoodEntry] {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        return moodEntries.filter { $0.timestamp >= weekAgo }
    }
    
    func getMonthlyEntries() -> [MoodEntry] {
        let calendar = Calendar.current
        let monthAgo = calendar.date(byAdding: .month, value: -1, to: Date())!
        return moodEntries.filter { $0.timestamp >= monthAgo }
    }
    
    func getMostFrequentMood() -> (emoji: String, count: Int)? {
        let monthlyEntries = getMonthlyEntries()
        guard !monthlyEntries.isEmpty else { return nil }
        
        let counts = Dictionary(grouping: monthlyEntries, by: { $0.emoji })
            .mapValues { $0.count }
        
        return counts.max(by: { $0.value < $1.value }).map { ($0.key, $0.value) }
    }
    
    func exportCSV() {
        var csvString = "Date,Time,Mood,Note\n"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        
        for entry in moodEntries.sorted(by: { $0.timestamp < $1.timestamp }) {
            let date = formatter.string(from: entry.timestamp)
            let time = timeFormatter.string(from: entry.timestamp)
            let note = entry.note?.replacingOccurrences(of: ",", with: ";") ?? ""
            csvString += "\(date),\(time),\(entry.emoji),\"\(note)\"\n"
        }
        
        let activityVC = UIActivityViewController(
            activityItems: [csvString],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

struct StreakCard: View {
    let title: String
    let count: Int
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
            
            Text("\(count)")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.deepTeal)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.cyanBlue)
                .multilineTextAlignment(.center)
            
            Text(count == 1 ? "day" : "days")
                .font(.system(size: 10))
                .foregroundColor(.softAqua)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.deepTeal.opacity(0.05), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.softAqua.opacity(0.2), lineWidth: 1)
        )
    }
}

struct WeeklyMoodChart: View {
    let entries: [MoodEntry]
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var moodCounts: [String: Int] {
        Dictionary(grouping: entries, by: { $0.emoji })
            .mapValues { $0.count }
    }
    
    var maxCount: Int {
        moodCounts.values.max() ?? 1
    }
    
    var body: some View {
        VStack(spacing: 12) {
            if entries.isEmpty {
                Text("No mood entries this week")
                    .font(.system(size: 14))
                    .foregroundColor(.softAqua)
                    .padding(40)
            } else {
                ForEach(Array(moodCounts.sorted(by: { $0.value > $1.value })), id: \.key) { emoji, count in
                    HStack(spacing: 12) {
                        Text(emoji)
                            .font(.system(size: 24))
                            .frame(width: 40)
                        
                        GeometryReader { geometry in
                            HStack(spacing: 0) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(moodColor(for: emoji))
                                    .frame(width: geometry.size.width * CGFloat(count) / CGFloat(maxCount))
                                    .animation(reduceMotion ? .none : .easeOut(duration: 0.5), value: count)
                                
                                Spacer()
                            }
                        }
                        .frame(height: 32)
                        
                        Text("\(count)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.deepTeal)
                            .frame(width: 30, alignment: .trailing)
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.deepTeal.opacity(0.05), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.softAqua.opacity(0.2), lineWidth: 1)
        )
    }
    
    func moodColor(for emoji: String) -> Color {
        switch emoji {
        case "😃", "😊", "🥰": return .cyanBlue
        case "🙂", "😌": return .softAqua
        case "😐", "🤔": return .softAqua.opacity(0.6)
        case "🙁", "😔": return .deepTeal
        case "😢", "😰": return .deepTeal.opacity(0.8)
        default: return .cyanBlue
        }
    }
}

struct MonthlyMoodSummary: View {
    let entries: [MoodEntry]
    
    var totalEntries: Int {
        entries.count
    }
    
    var uniqueDays: Int {
        let calendar = Calendar.current
        let days = Set(entries.map { calendar.startOfDay(for: $0.timestamp) })
        return days.count
    }
    
    var moodDiversity: Int {
        Set(entries.map { $0.emoji }).count
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                SummaryCard(
                    value: "\(totalEntries)",
                    label: "Total Entries",
                    icon: "checkmark.circle.fill",
                    color: .cyanBlue
                )
                
                SummaryCard(
                    value: "\(uniqueDays)",
                    label: "Active Days",
                    icon: "calendar.badge.checkmark",
                    color: .deepTeal
                )
            }
            
            SummaryCard(
                value: "\(moodDiversity)",
                label: "Different Moods Logged",
                icon: "face.smiling",
                color: .softAqua
            )
        }
    }
}

struct SummaryCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.deepTeal)
                
                Text(label)
                    .font(.system(size: 11))
                    .foregroundColor(.cyanBlue)
            }
            
            Spacer()
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.deepTeal.opacity(0.05), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.softAqua.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    MoodInsightsView()
}
