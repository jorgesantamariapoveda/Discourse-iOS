//
//  DetailUserViewController.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 29/03/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import UIKit

final class DetailUserViewController: UIViewController {

    // MARK: - Propierties

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!

    private var userName: String!

    // MARK: - Basic functions

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupData()
    }
}

// MARK: - Setups

extension DetailUserViewController {

    private func setupUI() {
        nameLabel.isHidden = true
        nameTextField.isHidden = true

        updateButton.isHidden = true
        updateButton.layer.cornerRadius = 4.0
        updateButton.backgroundColor = UIColor(displayP3Red: 146/255.0, green: 178/255.0, blue: 121/255.0, alpha: 1.0)
        updateButton.tintColor = .white
    }

    private func setupData() {
        guard let userName = self.userName else { return }
        userNameLabel.text = "Username: \(userName)"
        getUser(userName: userName) { [weak self] (resul) in
            // Al acceder a self dentro de un closure si no se especifica nada lo
            // hará de modo strong generando una referencia fuerte e impidiendo
            // que ARC realice su trabajo. Con [weak self] evitamos dicho comportamiento
            switch resul {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let user):
                print(user)
                self?.idLabel.text = "Id: \(user.id)"
                if user.canEditName == true {
                    self?.nameLabel.isHidden = true
                    self?.nameTextField.isHidden = false
                    self?.nameTextField.text = user.name
                    self?.updateButton.isHidden = false
                } else {
                    self?.nameLabel.isHidden = false
                    self?.nameLabel.text = "Name: \(user.name)"
                    self?.nameTextField.isHidden = true
                    self?.updateButton.isHidden = true
                }
            }
        }
    }
}

// MARK: - Public functions

extension DetailUserViewController {

    func setUsername(_ userName: String) {
        self.userName = userName
    }
}

// MARK: - IBActions

extension DetailUserViewController {

    @IBAction func updateButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text else { return }
        putNameToUserName(newName: name, userName: userName) { [weak self] (resul) in
            if resul == true {
                self?.showAlert(title: "PUT", message: "Name actualizado con éxito")
            } else {
                self?.showAlert(title: "PUT", message: "Error")
            }
        }
    }

}

// MARK: - API operations

extension DetailUserViewController {

    private func getUser(userName: String, completion: @escaping (Result<User, Error>) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)

        let urlString = "https://mdiscourse.keepcoding.io/users/\(userName).json"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(kApiKey, forHTTPHeaderField: "Api-Key")
        request.addValue(kApiUserName, forHTTPHeaderField: "Api-Username")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                DispatchQueue.main.async {
                    completion(.failure(err))
                }
            }
            if let resp = response as? HTTPURLResponse, resp.statusCode == 200 {
                if let dataset = data {
                    do {
                        let userResponse = try JSONDecoder().decode(UserResponse.self, from: dataset)
                        DispatchQueue.main.async {
                            completion(.success(userResponse.user))
                        }
                    } catch let errorDecoding as DecodingError {
                        DispatchQueue.main.async {
                            completion(.failure(errorDecoding))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(CustomTypeError.unknowError))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(CustomTypeError.emptyData))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(CustomTypeError.responseError))
                }
            }
        }
        dataTask.resume()
    }

    private func putNameToUserName(newName: String, userName: String, completion: @escaping (Bool) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)

        let urlString = "https://mdiscourse.keepcoding.io/users/\(userName).json"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue(kApiKey, forHTTPHeaderField: "Api-Key")
        request.addValue(kApiUserName, forHTTPHeaderField: "Api-Username")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "name": newName
        ]

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












