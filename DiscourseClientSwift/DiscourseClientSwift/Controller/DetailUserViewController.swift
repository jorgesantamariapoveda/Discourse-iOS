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

    private var userName: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupData()
    }

    // MARK: - Setups

    private func setupUI() {
        self.view.backgroundColor = .black

        updateButton.isHidden = true
        updateButton.layer.cornerRadius = 4.0
        updateButton.backgroundColor = UIColor(displayP3Red: 146/255.0, green: 178/255.0, blue: 121/255.0, alpha: 1.0)
        updateButton.tintColor = .white
    }

    private func setupData() {
        guard let userName = self.userName else { return }
        userNameLabel.text = "Username: \(userName)"
        fetchData(userName: userName) { [weak self] (resul) in
            switch resul {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let user):
                print(user)
                self?.idLabel.text = "Id: \(user.id)"
                if user.canEditName == true {
                    self?.nameTextField.isHidden = false
                    self?.nameTextField.text = user.name
                    self?.updateButton.isHidden = false
                    self?.nameLabel.isHidden = true
                } else {
                    self?.nameTextField.isHidden = true
                    self?.updateButton.isHidden = true
                    self?.nameLabel.isHidden = false
                    self?.nameLabel.text = "Name: \(user.name)"
                }
            }
        }

    }

    // MARK: - Public functions

    func setUsername(_ userName: String) {
        self.userName = userName
    }

    // MARK: - IBActions

    @IBAction func updateButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

// MARK: - API operations

extension DetailUserViewController {

    private func fetchData(userName: String, completion: @escaping (Result<User, Error>) -> Void) {
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
                        let dataDecode = try JSONDecoder().decode(UserDetail.self, from: dataset)
                        DispatchQueue.main.async {
                            completion(.success(dataDecode.user))
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

}












