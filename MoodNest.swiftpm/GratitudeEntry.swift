import Foundation

/// Gratitude journal entry
struct GratitudeEntry: Identifiable, Codable, Sendable {
    let id: UUID
    let text: String
    let timestamp: Date
    
    init(id: UUID = UUID(), text: String, timestamp: Date = Date()) {
        self.id = id
        self.text = text
        self.timestamp = timestamp
    }
}

/// Manages gratitude entries using UserDefaults
@MainActor
final class GratitudeDataStore: Sendable {
    static let shared = GratitudeDataStore()
    private let key = "gratitude_entries"
    
    private init() {}
    
    func save(_ entry: GratitudeEntry) {
        var entries = loadAll()
        entries.append(entry)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(entries) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func loadAll() -> [GratitudeEntry] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return (try? decoder.decode([GratitudeEntry].self, from: data)) ?? []
    }
    
    func delete(_ entry: GratitudeEntry) {
        var entries = loadAll()
        entries.removeAll { $0.id == entry.id }
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(entries) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func update(_ entry: GratitudeEntry) {
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
}
