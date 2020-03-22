//
//  DetailTopicsViewController.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 21/03/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import UIKit

protocol TopicDelegate {
    func reloadLatestTopics()
}

final class DetailTopicsViewController: UIViewController {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!

    private var topic: Topic?
    internal var delegate: TopicDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: - Setups

    private func setupUI() {
        self.view.backgroundColor = .black

        deleteButton.layer.cornerRadius = 4.0
        deleteButton.backgroundColor = UIColor(displayP3Red: 146/255.0, green: 178/255.0, blue: 121/255.0, alpha: 1.0)
        deleteButton.tintColor = .white

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
        guard let id = topic?.id else { return }
        deleteTopic(id: id) { [weak self] (result) in
            if result == true {
                self?.delegate?.reloadLatestTopics()
                self?.navigationController?.popViewController(animated: true)
            } else {
                self?.showAlert(title: "Error", message: CustomTypeError.unknowError.descripcion)
            }
        }
    }
}

// MARK: - API operations

extension DetailTopicsViewController {

    private func deleteTopic(id: Int, completion: @escaping (Bool) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)

        guard let url = URL(string: "https://mdiscourse.keepcoding.io/t/\(id).json") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue(kApiKey, forHTTPHeaderField: "Api-Key")
        request.addValue(kApiUserName, forHTTPHeaderField: "Api-Username")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let dataTask = session.dataTask(with: request) { (_, response, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
            if let resp = response as? HTTPURLResponse, resp.statusCode == 200 {
                DispatchQueue.main.async {
                    completion(true)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
        dataTask.resume()
    }

}









