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
        guard let text = titleTopicTextField.text else { return }
        postTopic(titulo: text) { [weak self] (result) in
            if result == true {
                self?.dismiss(animated: true, completion: nil)
            } else {
                self?.showAlert(title: "Error", message: CustomTypeError.unknowError.descripcion)
            }
        }
    }
}

// MARK: - API operations

extension CreateTopicViewController {

    private func postTopic(titulo: String, completion: @escaping (Bool) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)

        guard let postURL = URL(string: "https://mdiscourse.keepcoding.io/posts.json") else { return }

        var request = URLRequest(url: postURL)
        request.httpMethod = "POST"
        request.addValue(kApiKey, forHTTPHeaderField: "Api-Key")
        request.addValue(kApiUserName, forHTTPHeaderField: "Api-Username")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "title": titulo,
            "raw": "Raw: \(titulo)"
        ]
        print(body)

        guard let dataBody = try? JSONSerialization.data(withJSONObject: body) else { return }
        request.httpBody = dataBody

        let dataTask = session.dataTask(with: request) { (_, response, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            if let resp = response as? HTTPURLResponse, resp.statusCode == 200 {
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }
        dataTask.resume()

    }

}
