import Foundation

/// Journal entry with optional title
struct JournalEntry: Identifiable, Codable, Sendable {
    let id: UUID
    let title: String?
    let content: String
    let timestamp: Date
    
    init(id: UUID = UUID(), title: String? = nil, content: String, timestamp: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        self.timestamp = timestamp
    }
}

/// Manages journal entries using UserDefaults
@MainActor
final class JournalDataStore: Sendable {
    static let shared = JournalDataStore()
    private let key = "journal_entries"
    
    private init() {}
    
    func save(_ entry: JournalEntry) {
        var entries = loadAll()
        entries.append(entry)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(entries) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func loadAll() -> [JournalEntry] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return (try? decoder.decode([JournalEntry].self, from: data)) ?? []
    }
    
    func delete(_ entry: JournalEntry) {
        var entries = loadAll()
        entries.removeAll { $0.id == entry.id }
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(entries) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func update(_ entry: JournalEntry) {
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
