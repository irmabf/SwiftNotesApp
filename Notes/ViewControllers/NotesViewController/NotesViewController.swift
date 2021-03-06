//
//  ViewController.swift
//  Notes
//
//  Created by Irma Blanco on 09/07/2018.
//  Copyright © 2018 Irma Blanco. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {
 
  //MARK:- Segues
  private enum Segue {
    static let Note = "Note"
    static let AddNote = "AddNote"
  }
  
  //MARK:- Properties
  
  @IBOutlet var notesView: UIView!
  @IBOutlet  var messageLabel: UILabel!
  @IBOutlet var tableView: UITableView!
  
  //MARK:-
  private var coreDataManager = CoreDataManager(modelName: "Notes")
  
  private var notes: [Note]? {
    didSet{
      updateView()
    }
  }
  
  private var hasNotes: Bool {
    guard let notes = notes else { return false }
    return notes.count > 0
  }
  
  //MARK:-
  private let estimatedRowHeight = CGFloat(44.0)
  
  //MARK:-
  private lazy var updatedAtDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, HH:mm"
    return dateFormatter
  }()
  
  //MARK:- View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Notes"
  
    setupView()
    fetchNotes()
    setupNotificationHandling()
  }
  
  //MARK:- Navigation
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?){
    guard let identifier = segue.identifier else { return }
    
    switch identifier {
    case Segue.AddNote:
      guard let destination = segue.destination as? AddNoteViewController else { return }
      destination.managedObjectContext = coreDataManager.managedObjectContext
      
    case Segue.Note:
      guard let destination = segue.destination as? NoteViewController else {
        return
      }
      guard let indexPath = tableView.indexPathForSelectedRow, let note = notes?[indexPath.row] else {
        return
      }
      //Configure destination
      destination.note = note
      
    default:
      break
    }
  }
  
  //MARK:- View Methods
  private func setupView() {
    setupMessageLabel()
    setupTableView()
  }
  
  private func updateView(){
    tableView.isHidden = !hasNotes
    messageLabel.isHidden = hasNotes
  }

  //MARK:-
  private func setupMessageLabel() {
    messageLabel.text = "You Don´t Have Any notes yet."
  }
  
  //MARK:-
  private func setupTableView() {
    tableView.isHidden = true
    tableView.estimatedRowHeight = estimatedRowHeight
    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  //MARK:- Notification Handling
  
  @objc private func managedObjectContextObjectsDidChange(_ notification: Notification) {
    guard let userInfo = notification.userInfo else { return }
    
    // Helpers
    var notesDidChange = false
    
    if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
      for insert in inserts {
        if let note = insert as? Note {
          notes?.append(note)
          notesDidChange = true
        }
      }
    }
    
    if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
      for update in updates {
        if let _ = update as? Note {
          notesDidChange = true
        }
      }
    }
    
    if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
      for delete in deletes {
        if let note = delete as? Note {
          if let index = notes?.index(of: note) {
            notes?.remove(at: index)
            notesDidChange = true
          }
        }
      }
    }
    
    if notesDidChange {
      // Sort Notes
      notes?.sort(by: { $0.updatedAtAsDate > $1.updatedAtAsDate })
      
      // Update Table View
      tableView.reloadData()
      
      // Update View
      updateView()
    }
  }
  
  //MARK:- Helper Methods
 
  private func fetchNotes() {
    let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Note.updatedAt), ascending: false)]
    coreDataManager.managedObjectContext.performAndWait {
      do {
          let notes = try fetchRequest.execute()
          self.notes = notes
          self.tableView.reloadData()
      }catch{
        print("Unable to Execute Fetch Request")
        print("\(error), \(error.localizedDescription)")
      }
    }
  }
  
  //MARK:-
  
  private func setupNotificationHandling() {
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self,
                                   selector: #selector(managedObjectContextObjectsDidChange(_:)),
                                   name: Notification.Name.NSManagedObjectContextObjectsDidChange,
                                   object: coreDataManager.managedObjectContext)
  }
  

  
}

extension NotesViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return hasNotes ? 1 : 0
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let notes = notes else { return 0 }
    return notes.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let note = notes?[indexPath.row] else {
      fatalError("Unexpected IndexPath")
    }
    guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as? NoteTableViewCell else {
      fatalError("Unexpected IndexPath")
    }
    
    cell.titleLabel.text = note.title
    cell.contentsLabel.text = note.contents
    cell.updatedAtLabel.text = updatedAtDateFormatter.string(from: note.updatedAtAsDate)
    
    return cell
  }
    
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }
    // Fetch note
    guard let note = notes?[indexPath.row] else { fatalError("Unexpected Index Path")}
    // Delete the note
    note.managedObjectContext?.delete(note)
    
  }
}





