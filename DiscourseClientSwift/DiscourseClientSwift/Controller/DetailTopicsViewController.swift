//
//  DetailTopicsViewController.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 21/03/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import UIKit

protocol DetailTopicDelegate {
    func reloadLatestTopics()
}

final class DetailTopicsViewController: UIViewController {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var postsCountLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!

    private var topic: Topic?
    internal var delegate: DetailTopicDelegate?

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
        if let id = topic?.id {
            deleteTopic(id: id)
        }
    }
}

extension DetailTopicsViewController {

    func deleteTopic(id: Int) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)

        let urlString = "https://mdiscourse.keepcoding.io/t/\(id).json"
        guard let updateStatusURL = URL(string: urlString) else { return }

        var request = URLRequest(url: updateStatusURL)
        request.httpMethod = "DELETE"
        request.addValue(kApiKey, forHTTPHeaderField: "Api-Key")
        request.addValue(kApiUserName, forHTTPHeaderField: "Api-Username")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let dataTask = session.dataTask(with: request) { (_, response, error) in
            if let error = error {
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
            if let resp = response as? HTTPURLResponse, resp.statusCode == 200 {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.reloadLatestTopics()
                    self?.navigationController?.popViewController(animated: true)
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert(title: "Error", message: CustomTypeError.responseError.descripcion)
                }
            }
        }
        dataTask.resume()
    }

}









