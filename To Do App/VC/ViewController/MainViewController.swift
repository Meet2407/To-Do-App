import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var notes: [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notes = NotesManager.shared.fetchNotes()
        tableView.delegate = self
        tableView.dataSource = self

    }
    @IBAction func addNoteTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let dataAddVC = storyboard.instantiateViewController(withIdentifier: "DataAddViewController") as? DataAddViewController {
            dataAddVC.delegate = self
            navigationController?.pushViewController(dataAddVC, animated: true)
        }
    }
    
    
    
    func reloadNotes() {
        notes = NotesManager.shared.fetchNotes()
        tableView.reloadData()
    }
}

// MARK: - TableView Extensions
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DisplayTableViewCell else {
            fatalError("Unable to dequeue ItemDisplayTableViewCell")
        }
        let note = notes[indexPath.row]
        cell.title.text = note.title
        cell.typeSomething.text = note.content
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let dataUpdateVC = storyboard.instantiateViewController(withIdentifier: "DataUpdateViewController") as? DataUpdateViewController {
            dataUpdateVC.noteToUpdate = note
            dataUpdateVC.delegate = self
            navigationController?.pushViewController(dataUpdateVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            NotesManager.shared.deleteNote(withId: notes[indexPath.row].id)
            reloadNotes()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 169
    }
}

// MARK: - Delegates
extension MainViewController: DataAddDelegate, DataUpdateDelegate {
    func didAddNote() {
        reloadNotes()
    }
    
    func didUpdateNote() {
        reloadNotes()
    }
}
