import SwiftUI

struct HistoryView: View {
    @Environment(\.dismiss) var dismiss
    @State private var groupedEntries: [(date: Date, entries: [MoodEntry])] = []
    @State private var expandedDates: Set<String> = []
    
    var body: some View {
        NavigationView {
            VStack {
                if groupedEntries.isEmpty {
                    // Empty state
                    VStack(spacing: 15) {
                        Text("📖")
                            .font(.system(size: 80))
                        
                        Text("No mood history yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Start logging your moods to build your emotional journal")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding()
                } else {
                    // History list
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(groupedEntries, id: \.date) { group in
                                DaySection(
                                    date: group.date,
                                    entries: group.entries,
                                    isExpanded: expandedDates.contains(dateKey(group.date)),
                                    onToggle: {
                                        toggleExpansion(for: group.date)
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Mood History")
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
            loadHistory()
        }
    }
    
    func loadHistory() {
        let allEntries = MoodDataStore.shared.loadAll()
        let calendar = Calendar.current
        
        // Group by date
        let grouped = Dictionary(grouping: allEntries) { entry in
            calendar.startOfDay(for: entry.timestamp)
        }
        
        // Sort by date (most recent first)
        groupedEntries = grouped.map { (date: $0.key, entries: $0.value.sorted { $0.timestamp < $1.timestamp }) }
            .sorted { $0.date > $1.date }
    }
    
    func dateKey(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    func toggleExpansion(for date: Date) {
        let key = dateKey(date)
        if expandedDates.contains(key) {
            expandedDates.remove(key)
        } else {
            expandedDates.insert(key)
        }
    }
}

struct DaySection: View {
    let date: Date
    let entries: [MoodEntry]
    let isExpanded: Bool
    let onToggle: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button(action: onToggle) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(formatDate(date))
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("\(entries.count) check-in\(entries.count == 1 ? "" : "s")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Emoji preview
                    HStack(spacing: 4) {
                        ForEach(entries.prefix(5), id: \.timestamp) { entry in
                            Text(entry.emoji)
                                .font(.title3)
                        }
                        if entries.count > 5 {
                            Text("...")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
            }
            
            // Expanded content
            if isExpanded {
                VStack(spacing: 8) {
                    ForEach(entries, id: \.timestamp) { entry in
                        HStack(spacing: 12) {
                            Text(entry.emoji)
                                .font(.title2)
                            
                            Text(formatTime(entry.timestamp))
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(8)
                    }
                }
                .padding(.top, 8)
                .padding(.horizontal, 4)
            }
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
