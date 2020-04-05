//
//  UsersViewController.swift
//  DiscourseClientSwift
//
//  Created by Jorge on 20/03/2020.
//  Copyright © 2020 Jorge. All rights reserved.
//

import UIKit

final class UsersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let idCell = "idCell"
    private var directoryItems = [DirectoryItem]()
    private let sizeImage = 50

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupData()
    }

    // MARK: - Setups

    private func setupUI() {
        self.title = "Users"
        self.view.backgroundColor = .black

        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: idCell)
    }

    private func setupData() {
        fetchData { [weak self] (result) in
            switch result {
            case .failure(let error as CustomTypeError):
                print(error.descripcion)
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let directoryItems):
                // Al acceder a self dentro de un closure si no se especifica nada lo
                // hará de modo strong generando una referencia fuerte e impidiendo
                // que ARC realice su trabajo. Con [weak self] evitamos dicho comportamiento
                self?.directoryItems = directoryItems
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - API operations

extension UsersViewController {

    private func fetchData(completion: @escaping (Result<[DirectoryItem], Error>) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)

        guard let url = URL(string: "https://mdiscourse.keepcoding.io/directory_items.json?period=all&order=topic_count") else { return }

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
                        let dataDecode = try JSONDecoder().decode(DirectoryItems.self, from: dataset)
                        DispatchQueue.main.async {
                            completion(.success(dataDecode.directoryItems))
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

// MARK: - UITableViewDataSource

extension UsersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return directoryItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = directoryItems[indexPath.row].user

        let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath)
        cell.textLabel?.text = user.username

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let avatar = user.avatar.replacingOccurrences(of: "{size}", with: String(self!.sizeImage))
            let pathAvatar = "https://mdiscourse.keepcoding.io\(avatar)"
            guard let urlAvatar = URL(string: pathAvatar) else { return }

            // Aquí se produce realmente el proceso costoso
            let data = try? Data.init(contentsOf: urlAvatar)

            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                cell.imageView?.image = image
                cell.setNeedsLayout()
            }
        }

        return cell
    }

}

extension UsersViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(integerLiteral: sizeImage)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = directoryItems[indexPath.row].user

        
        let detailVC = DetailUserViewController()
        detailVC.setUsername(user.username)
        self.navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
