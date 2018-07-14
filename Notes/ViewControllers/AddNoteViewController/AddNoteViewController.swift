//
//  AddNoteViewController.swift
//  Notes
//
//  Created by Irma Blanco on 09/07/2018.
//  Copyright © 2018 Irma Blanco. All rights reserved.
//

import UIKit
import CoreData

class AddNoteViewController: UIViewController {

    // MARK: - Properties

  @IBOutlet var titleTextField: UITextField!
  @IBOutlet var contentsTextView: UITextView!
  
  var managedObjectContext: NSManagedObjectContext?

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Note"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Show Keyboard
        titleTextField.becomeFirstResponder()
    }

    // MARK: - Actions

    @IBAction func save(sender: UIBarButtonItem) {
      guard let managedObjectContext = managedObjectContext else { return }
      guard let title = titleTextField.text, !title.isEmpty else {
       showAlert(with: "Title Missing", message: "Your note doesn´t have a title")
        return
      }
      
      let note = Note(context: managedObjectContext)
      note.createdAt = Date()
      note.updatedAt = Date()
      note.title = title
      note.contents = contentsTextView.text
      
      _ = navigationController?.popViewController(animated: true)
    }
}










