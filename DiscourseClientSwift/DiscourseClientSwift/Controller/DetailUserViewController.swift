//
//  DetailUserViewController.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 29/03/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import UIKit

final class DetailUserViewController: UIViewController {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!

    private var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: - Setups

    private func setupUI() {
        self.view.backgroundColor = .black

        guard let user = user else { return }
        idLabel.text = "Id: \(user.id)"
        userNameLabel.text = "Username: \(user.username)"
        if let name = user.name {
            nameLabel.text = "Name: \(name)"
        } else {
            nameLabel.text = "Name:"
        }

        updateButton.layer.cornerRadius = 4.0
        updateButton.backgroundColor = UIColor(displayP3Red: 146/255.0, green: 178/255.0, blue: 121/255.0, alpha: 1.0)
        updateButton.tintColor = .white
    }

    // MARK: - Public functions

    func setTopic(_ user: User) {
        self.user = user
    }

    // MARK: - IBActions

    @IBAction func updateButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

