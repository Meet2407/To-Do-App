import UIKit
import UserNotifications

class MainViewController: UIViewController{
   

    @IBOutlet weak var tableView: UITableView!
    var notes: [Note] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch notes and configure table view
        notes = NotesManager.shared.fetchNotes()
        tableView.delegate = self
        tableView.dataSource = self

        // Add long press gesture recognizer to the table view
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        tableView.addGestureRecognizer(longPressGesture)
        print("hi")
    }

    // Long press gesture handler
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: location) else { return }

        if gesture.state == .began {
            let note = notes[indexPath.row]

            // Create the alert controller with the date picker
            let alertController = UIAlertController(title: "Select a Date", message: nil, preferredStyle: .alert)

            // Add a date picker to the alert view
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .dateAndTime
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            alertController.view.addSubview(datePicker)

            // Set up constraints for the date picker
            NSLayoutConstraint.activate([
                datePicker.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: 10),
                datePicker.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor, constant: -10),
                datePicker.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 50),
                datePicker.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -60)
            ])

            // Add actions for the alert
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)

            // Add the "Set Date" action
            let setDateAction = UIAlertAction(title: "Set Date", style: .default) { _ in
                let selectedDate = datePicker.date
                // Handle the selected date (e.g., schedule a notification)
                self.scheduleNotification(for: note, at: selectedDate)
            }
            alertController.addAction(setDateAction)

            // Present the alert controller
            present(alertController, animated: true, completion: nil)
        }
    }

    // Function to schedule a notification
    func scheduleNotification(for note: Note, at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = note.title
        content.body = note.content
        content.sound = .default

        // Create a trigger based on the selected date
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date), repeats: false)

        // Create a unique identifier for the notification
        let notificationID = UUID().uuidString

        // Create the notification request
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)

        // Add the notification request to the Notification Center
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully!")
            }
        }
    }

    // Reload the notes after changes
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
            fatalError("Unable to dequeue DisplayTableViewCell")
        }
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.bgView.layer.cornerRadius = 10
        cell.bgView.layer.masksToBounds = true
        let note = notes[indexPath.row]
        cell.title.text = note.title
        cell.typeSomething.text = note.content
        return cell
    }

    // Long press gesture already handled in `handleLongPressGesture(_:)`

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let dataUpdateVC = storyboard.instantiateViewController(withIdentifier: "DataUpdateViewController") as? DataUpdateViewController {
            dataUpdateVC.noteToUpdate = note
            
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
        return 129
    }
}
