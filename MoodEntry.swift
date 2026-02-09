import Foundation

// MARK: - Mood Entry Model
struct MoodEntry: Codable, Identifiable, Equatable {
    let id: UUID
    let emoji: String
    let timestamp: Date
    
    init(id: UUID = UUID(), emoji: String, timestamp: Date = Date()) {
        self.id = id
        self.emoji = emoji
        self.timestamp = timestamp
    }
    
    // Helper computed property for formatted date display
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
}

// MARK: - Mood Data Store
@MainActor
class MoodDataStore: ObservableObject {
    // Singleton instance
    static let shared = MoodDataStore()
    
    // UserDefaults storage key
    private let storageKey = "mood_entries"
    
    // Private initializer for singleton
    private init() {
        print("🔧 MoodDataStore initialized")
    }
    
    // MARK: - Save Method
    
    /// Save a new mood entry to UserDefaults
    /// - Parameter entry: The MoodEntry to save
    func save(_ entry: MoodEntry) {
        print("💾 Attempting to save mood entry...")
        print("   Emoji: \(entry.emoji)")
        print("   Timestamp: \(entry.timestamp)")
        
        // Load existing entries
        var entries = loadAll()
        
        // Append new entry
        entries.append(entry)
        
        // Encode and save
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(entries)
            UserDefaults.standard.set(data, forKey: storageKey)
            
            print("✅ Successfully saved! Total entries: \(entries.count)")
        } catch {
            print("❌ Error encoding mood entries: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Load Method
    
    /// Load all stored mood entries from UserDefaults
    /// - Returns: Array of MoodEntry (empty if none exist)
    func loadAll() -> [MoodEntry] {
        print("📂 Loading all mood entries from UserDefaults...")
        
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            print("ℹ️ No data found in UserDefaults")
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let entries = try decoder.decode([MoodEntry].self, from: data)
            
            print("✅ Successfully loaded \(entries.count) entries")
            for (index, entry) in entries.enumerated() {
                print("   [\(index + 1)] \(entry.emoji) - \(entry.formattedDate)")
            }
            
            return entries
        } catch {
            print("❌ Error decoding mood entries: \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: - Utility Methods
    
    /// Get count of all entries
    func getTotalCount() -> Int {
        let count = loadAll().count
        print("📊 Total entries: \(count)")
        return count
    }
    
    /// Clear all entries (useful for testing)
    func clearAll() {
        print("🗑️ Clearing all mood entries...")
        UserDefaults.standard.removeObject(forKey: storageKey)
        print("✅ All entries cleared")
    }
    
    /// Print all entries to console (for debugging)
    func printAll() {
        print("\n" + String(repeating: "=", count: 50))
        print("📋 ALL MOOD ENTRIES")
        print(String(repeating: "=", count: 50))
        
        let entries = loadAll()
        
        if entries.isEmpty {
            print("ℹ️ No entries found")
        } else {
            for (index, entry) in entries.enumerated() {
                print("\n[\(index + 1)]")
                print("  Emoji: \(entry.emoji)")
                print("  Date: \(entry.formattedDate)")
                print("  ID: \(entry.id)")
            }
        }
        
        print(String(repeating: "=", count: 50) + "\n")
    }
}
