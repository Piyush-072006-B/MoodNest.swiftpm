import SwiftUI

struct SelfCareView: View {
    @State private var todayActivities: [SelfCareEntry] = []
    @State private var streak = 0
    @State private var showConfirmation = false
    @State private var editingEntry: SelfCareEntry?
    @Environment(\.dismiss) var dismiss
    
    let predefinedActivities = [
        ("Meditation", "figure.mind.and.body", Color.cyanBlue),
        ("Walk", "figure.walk", Color.softAqua),
        ("Rest", "bed.double.fill", Color.deepTeal.opacity(0.6)),
        ("Stretch", "figure.flexibility", Color.softAqua),
        ("Read", "book.fill", Color.cyanBlue.opacity(0.8)),
        ("Bath", "drop.fill", Color.softAqua.opacity(0.8)),
        ("Music", "music.note", Color.cyanBlue),
        ("Nature", "leaf.fill", Color.deepTeal)
    ]
    
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
                    
                    VStack(spacing: 2) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 20))
                            .foregroundColor(.cyanBlue)
                        
                        Text("Self-Care")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.deepTeal)
                    }
                    
                    Spacer()
                    
                    Color.clear.frame(width: 44)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Streak Card
                        HStack(spacing: 16) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.cyanBlue)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(streak) Day Streak")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.deepTeal)
                                
                                Text("Keep it going!")
                                    .font(.system(size: 14))
                                    .foregroundColor(.softAqua)
                            }
                            
                            Spacer()
                        }
                        .padding(20)
                        .background(Color.softAqua.opacity(0.2))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(Color.softAqua.opacity(0.4), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Activity Grid
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Log an activity")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.deepTeal)
                                .padding(.horizontal, 20)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 12),
                                GridItem(.flexible(), spacing: 12)
                            ], spacing: 12) {
                                ForEach(predefinedActivities, id: \.0) { activity in
                                    ActivityButton(
                                        name: activity.0,
                                        icon: activity.1,
                                        color: activity.2,
                                        action: {
                                            logActivity(activity.0)
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Today's Activities
                        if !todayActivities.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Today's self-care")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.deepTeal)
                                    .padding(.horizontal, 20)
                                
                                ForEach(todayActivities) { entry in
                                    ActivityCard(entry: entry, onDelete: {
                                        deleteActivity(entry)
                                    })
                                }
                                .padding(.horizontal, 20)
                            }
                            .padding(.top, 8)
                        }
                        
                        // Confirmation
                        if showConfirmation {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.deepTeal)
                                Text("Activity logged!")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.deepTeal)
                            }
                            .transition(.scale.combined(with: .opacity))
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
    
    func logActivity(_ name: String) {
        let entry = SelfCareEntry(activity: name, completed: true)
        SelfCareDataStore.shared.save(entry)
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            showConfirmation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showConfirmation = false
                loadData()
            }
        }
    }
    
    func deleteActivity(_ entry: SelfCareEntry) {
        SelfCareDataStore.shared.delete(entry)
        loadData()
    }
    
    func loadData() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        todayActivities = SelfCareDataStore.shared.loadAll().filter { entry in
            calendar.isDate(entry.timestamp, inSameDayAs: today)
        }.sorted { $0.timestamp > $1.timestamp }
        
        streak = SelfCareDataStore.shared.getStreak()
    }
}

struct ActivityButton: View {
    let name: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                
                Text(name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(color)
            .cornerRadius(16)
            .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ActivityCard: View {
    let entry: SelfCareEntry
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(.cyanBlue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.activity)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.deepTeal)
                
                Text(formatTime(entry.timestamp))
                    .font(.system(size: 12))
                    .foregroundColor(.softAqua)
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .font(.system(size: 16))
                    .foregroundColor(.deepTeal.opacity(0.6))
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.deepTeal.opacity(0.05), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.softAqua.opacity(0.2), lineWidth: 1)
        )
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    SelfCareView()
}
