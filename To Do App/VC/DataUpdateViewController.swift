import UIKit

protocol DataUpdateDelegate: AnyObject {
    func didUpdateNote()
}

class DataUpdateViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextField!
    
    weak var delegate: DataUpdateDelegate?
    var noteToUpdate: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFeildEdit()
        hideKeyboardWhenTappedAround()
        
        // Display the selected note's data
        if let note = noteToUpdate {
            titleTextField.text = note.title
            contentTextField.text = note.content
        }
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

    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let note = noteToUpdate,
              let title = titleTextField.text,
              let content = contentTextField.text,
              !title.isEmpty,
              !content.isEmpty else { return }
        
        let updatedNote = Note(id: note.id, title: title, content: content)
        NotesManager.shared.updateNote(updatedNote)
        delegate?.didUpdateNote()
        navigationController?.popViewController(animated: true)
    }
}
