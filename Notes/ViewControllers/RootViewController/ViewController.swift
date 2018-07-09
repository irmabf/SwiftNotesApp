//
//  ViewController.swift
//  Notes
//
//  Created by Irma Blanco on 09/07/2018.
//  Copyright © 2018 Irma Blanco. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
  
  private let coreDataManager = CoreDataManager(modelName: "Notes")

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let note = Note(context: coreDataManager.managedObjectContext)
    note.title = "My second note"
    note.createdAt = Date()
    note.updatedAt = Date()
    
    print(note.title ?? "My second note")

    
    do {
      try coreDataManager.managedObjectContext.save()
    }catch {
      print("Unable to Save Managed Object Context")
      print("\(error), \(error.localizedDescription)")
    }
  }
}



