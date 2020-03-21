//
//  CategoriesViewController.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 20/03/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import UIKit

final class CategoriesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let idCell = "idCell"
    private var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupData()
    }

    // MARK: - Setups

    private func setupUI() {
        self.title = "Categories"
        self.view.backgroundColor = .black

        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: idCell)
    }

    private func setupData() {
        fetchData { [weak self] (result) in
            switch result {
            case .failure(let error as CustomTypeError):
                print(error.descripcion)
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let categories):
                // Al acceder a self dentro de un closure si no se especifica nada lo
                // hará de modo strong generando una referencia fuerte e impidiendo
                // que ARC realice su trabajo. Con [weak self] evitamos dicho comportamiento
                self?.categories = categories
                self?.tableView.reloadData()
            }
        }
    }

    private func fetchData(completion: @escaping (Result<[Category], Error>) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)

        guard let url = URL(string: "https://mdiscourse.keepcoding.io/categories.json") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "Api-Key")
        request.addValue(apiUserName, forHTTPHeaderField: "Api-Username")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                DispatchQueue.main.async {
                    completion(.failure(err))
                }
            }
            if let resp = response as? HTTPURLResponse {
                if resp.statusCode == 200 {
                    if let dataset = data {
                        do {
                            let categoriesResponse = try JSONDecoder().decode(Categories.self, from: dataset)
                            DispatchQueue.main.async {
                                completion(.success(categoriesResponse.categoryList.categories))
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
                } else if resp.statusCode >= 400 && resp.statusCode <= 499 {
                    DispatchQueue.main.async {
                        completion(.failure(CustomTypeError.error400HTTP))
                    }
                } else if resp.statusCode >= 500 && resp.statusCode <= 599 {
                    DispatchQueue.main.async {
                        completion(.failure(CustomTypeError.error500HTTP))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(CustomTypeError.unknowError))
                    }
                }
            }
        }
        dataTask.resume()
    }

}

// MARK: - UITableViewDataSource

extension CategoriesViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }

}
