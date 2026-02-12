import Foundation

/// Self-care activity entry
struct SelfCareEntry: Identifiable, Codable, Sendable {
    let id: UUID
    let activity: String
    let timestamp: Date
    let completed: Bool
    let note: String?
    
    init(id: UUID = UUID(), activity: String, timestamp: Date = Date(), completed: Bool = true, note: String? = nil) {
        self.id = id
        self.activity = activity
        self.timestamp = timestamp
        self.completed = completed
        self.note = note
    }
}

/// Manages self-care entries using UserDefaults
@MainActor
final class SelfCareDataStore: Sendable {
    static let shared = SelfCareDataStore()
    private let key = "self_care_entries"
    
    private init() {}
    
    func save(_ entry: SelfCareEntry) {
        var entries = loadAll()
        entries.append(entry)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(entries) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func loadAll() -> [SelfCareEntry] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return (try? decoder.decode([SelfCareEntry].self, from: data)) ?? []
    }
    
    func delete(_ entry: SelfCareEntry) {
        var entries = loadAll()
        entries.removeAll { $0.id == entry.id }
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(entries) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func update(_ entry: SelfCareEntry) {
        var entries = loadAll()
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            if let data = try? encoder.encode(entries) {
                UserDefaults.standard.set(data, forKey: key)
            }
        }
    }
    
    /// Get streak count (consecutive days with at least one activity)
    func getStreak() -> Int {
        let entries = loadAll()
        let calendar = Calendar.current
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())
        
        while true {
            let hasActivity = entries.contains { entry in
                calendar.isDate(entry.timestamp, inSameDayAs: currentDate)
            }
            
            if hasActivity {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                break
            }
        }
        
        return streak
    }
}
