//
//  NoteViewController.swift
//  Notes
//
//  Created by Irma Blanco on 14/07/2018.
//  Copyright © 2018 Irma Blanco. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
  
  //MARK:- Properties
  @IBOutlet var titleTextField: UITextField!
  @IBOutlet var contentsTextView: UITextView!
  
  var note: Note?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Edit Note"
    setupView()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    guard let note = note else { return }
    
//    Update title
    if let title = titleTextField.text, !title.isEmpty && note.title != title {
      note.title = title
    }
//    Update contents
    if note.contents != contentsTextView.text {
      note.contents = contentsTextView.text
    }
//    Update updated at
    if note.isUpdated {
      note.updatedAt = Date()
    }
  }
  
  private func setupView(){
    setupTitleTextField()
    setupContentsTextView()
  }
  
  private func setupTitleTextField(){
    titleTextField.text = note?.title
  }
  
  private func setupContentsTextView(){
    contentsTextView.text = note?.contents
  }
}













