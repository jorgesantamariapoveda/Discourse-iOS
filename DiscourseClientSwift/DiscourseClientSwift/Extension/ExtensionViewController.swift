//
//  ExtensionViewController.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 22/03/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import UIKit

extension UIViewController {

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

}
