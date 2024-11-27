import Foundation


class NotesManager {
    static let shared = NotesManager()
    
    private let userDefaultsKey = "notesKey"
    
    func fetchNotes() -> [Note] {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let notes = try? JSONDecoder().decode([Note].self, from: data) else {
            return []
        }
        return notes
    }
    
    func saveNotes(_ notes: [Note]) {
        if let data = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    func addNote(_ note: Note) {
        var notes = fetchNotes()
        notes.append(note)
        saveNotes(notes)
    }
    
    func updateNote(_ updatedNote: Note) {
        var notes = fetchNotes()
        if let index = notes.firstIndex(where: { $0.id == updatedNote.id }) {
            notes[index] = updatedNote
        }
        saveNotes(notes)
    }
    
    func deleteNote(withId id: String) {
        var notes = fetchNotes()
        notes.removeAll { $0.id == id }
        saveNotes(notes)
    }
}
