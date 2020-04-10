//
//  CategoriesViewController.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 20/03/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import UIKit

final class CategoriesViewController: UIViewController {

    // MARK: - Propierties

    @IBOutlet weak var tableView: UITableView!

    private let idCell = "idCell"
    private var categories = [Category]()

    // MARK: - Basic functions

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupData()
    }
}

// MARK: - Setups

extension CategoriesViewController {

    private func setupUI() {
        self.title = "Categories"

        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: idCell)
    }

    private func setupData() {
        getCategories { [weak self] (result) in
            // Al acceder a self dentro de un closure si no se especifica nada lo
            // hará de modo strong generando una referencia fuerte e impidiendo
            // que ARC realice su trabajo. Con [weak self] evitamos dicho comportamiento
            switch result {
            case .failure(let error as CustomTypeError):
                print(error.descripcion)
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let categories):
                self?.categories = categories
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - API operations

extension CategoriesViewController {

    private func getCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)

        guard let url = URL(string: "https://mdiscourse.keepcoding.io/categories.json") else { return }

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
                        let categoriesResponse = try JSONDecoder().decode(CategoriesResponse.self, from: dataset)
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
