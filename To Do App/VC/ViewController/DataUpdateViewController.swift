//
//  DataUpdateViewController.swift
//  To Do App
//
//  Created by Meet Kapadiya on 15/11/24.
//
import UIKit

protocol DataUpdateDelegate: AnyObject {
    func didUpdateNote()
}

class DataUpdateViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextField!
    
    var noteToUpdate: Note?
    weak var delegate: DataUpdateDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let note = noteToUpdate {
            titleTextField.text = note.title
            contentTextField.text = note.content
        }
        textFeildEdit()
    }
    
    func textFeildEdit(){
        titleTextField.backgroundColor = UIColor.clear
        
        titleTextField.attributedPlaceholder = NSAttributedString(
            string: "Title",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        contentTextField.backgroundColor = UIColor.clear
        
        contentTextField.attributedPlaceholder = NSAttributedString(
            string: "Type Something",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let title = titleTextField.text, !title.isEmpty,
              let content = contentTextField.text, !content.isEmpty,
              let note = noteToUpdate else {
            return
        }
        
        let updatedNote = Note(id: note.id, title: title, content: content, createdAt: note.createdAt)
        NotesManager.shared.updateNote(updatedNote)
        delegate?.didUpdateNote()
        navigationController?.popViewController(animated: true)
    }
}
