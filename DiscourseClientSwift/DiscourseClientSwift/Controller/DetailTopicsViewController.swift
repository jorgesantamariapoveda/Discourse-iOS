//
//  DetailTopicsViewController.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 21/03/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import UIKit

final class DetailTopicsViewController: UIViewController {

    private var topic: Topic?

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: - Setups

    private func setupUI() {
        view.backgroundColor = .black

        guard let topic = self.topic else { return }
        idLabel.text = "Id: \(topic.id)"
        titleTextView.text = "Title: \(topic.title)"
        postsCountLabel.text = "Posts count: \(topic.postsCount)"
        deleteButton.isHidden = topic.closed
    }

    func setTopic(_ topic:Topic) {
        self.topic = topic
    }

    // MARK: - IBAction

    @IBAction func deleteButtonTapped(_ sender: Any) {
    }
}
