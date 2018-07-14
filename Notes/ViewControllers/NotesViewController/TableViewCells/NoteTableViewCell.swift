//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Irma Blanco on 09/07/2018.
//  Copyright © 2018 Irma Blanco. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
  
  //MARK:- Static properties
   
  static let reuseIdentifier = "NoteTableViewCell"
  
  //MARK:- Properties
  
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var contentsLabel: UILabel!
  @IBOutlet var updatedAtLabel: UILabel!
  
  //MARK:- Initialization
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
