//
//  Note.swift
//  Notes
//
//  Created by Irma Blanco on 09/07/2018.
//  Copyright © 2018 Irma Blanco. All rights reserved.
//

import Foundation

extension Note {
  var updatedAtAsDate: Date {
    return updatedAt ?? Date()
  }
  var createdAtAsDate: Date {
    return createdAt ?? Date()
  }
}
