import Foundation

struct MoodEntry: Codable {
    let emoji: String
    let timestamp: Date
}

final class MoodDataStore: @unchecked Sendable {
    static let shared = MoodDataStore()
    private let key = "mood_entries"
    
    private init() {
        print("[MoodDataStore] Initialized")
    }
    
    func save(_ entry: MoodEntry) {
        var entries = loadAll()
        entries.append(entry)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        if let encoded = try? encoder.encode(entries) {
            UserDefaults.standard.set(encoded, forKey: key)
            print("[MoodDataStore] Saved entry: \(entry.emoji) at \(entry.timestamp)")
            print("[MoodDataStore] Total entries: \(entries.count)")
        } else {
            print("[MoodDataStore] ERROR: Failed to encode entries")
        }
    }
    
    func loadAll() -> [MoodEntry] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            print("[MoodDataStore] No saved entries found")
            return []
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        if let decoded = try? decoder.decode([MoodEntry].self, from: data) {
            print("[MoodDataStore] Loaded \(decoded.count) entries")
            return decoded
        } else {
            print("[MoodDataStore] ERROR: Failed to decode entries")
            return []
        }
    }
}
