//
//  Helper.swift
//  To Do App
//
//  Created by Meet Kapadiya on 15/11/24.
//

import Foundation

class NotesManager {
    static let shared = NotesManager()
    private var notes: [Note] = []
    
    func fetchNotes() -> [Note] {
        return notes
    }
    
    func addNote(_ note: Note) {
        notes.append(note)
    }
    
    func updateNote(_ updatedNote: Note) {
        if let index = notes.firstIndex(where: { $0.id == updatedNote.id }) {
            notes[index] = updatedNote
        }
    }
    
    func deleteNote(withId id: UUID) {
        notes.removeAll { $0.id == id }
    }
}
