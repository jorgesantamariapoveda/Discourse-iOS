//
//  CreateTopicViewController.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 22/03/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import UIKit

final class CreateTopicViewController: UIViewController {

    @IBOutlet weak var titleTopicTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: - Setup

    private func setupUI() {
        self.navigationItem.title = "Create"
        self.view.backgroundColor = .black

        titleTopicTextField.placeholder = "Type a title..."

        submitButton.layer.cornerRadius = 4.0
        submitButton.backgroundColor = UIColor(displayP3Red: 146/255.0, green: 178/255.0, blue: 121/255.0, alpha: 1.0)
        submitButton.tintColor = .white
    }

    // MARK: - IBAction

    @IBAction func submitButtonTapped(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)
    }
}
