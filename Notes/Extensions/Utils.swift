//
//  Utils.swift
//  Notes
//
//  Created by Irma Blanco on 09/07/2018.
//  Copyright © 2018 Irma Blanco. All rights reserved.
//

import UIKit

extension UIViewController{
  //MARK:- Alerts
  func showAlert(with title: String, message: String) {
    // Initialize alert controller
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    // Configure alert controller
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    // Present alert controller
    present(alertController, animated: true, completion: nil)
  }
}
