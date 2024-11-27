    //
    //  DataAddViewController.swift
    //  To Do App
    //
    //  Created by Meet Kapadiya on 15/11/24.
    //

import UIKit

protocol DataAddDelegate: AnyObject {
    func didAddNote()
}

class DataAddViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextField!
    
    weak var delegate: DataAddDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
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
              let content = contentTextField.text, !content.isEmpty else {
            return
        }
        
        let newNote = Note(id: UUID(), title: title, content: content, createdAt: Date())
        NotesManager.shared.addNote(newNote)
        delegate?.didAddNote()
        navigationController?.popViewController(animated: true)
    }
}
