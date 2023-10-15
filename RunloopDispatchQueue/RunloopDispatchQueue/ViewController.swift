//
//  ViewController.swift
//  RunloopDispatchQueue
//
//  Created by 안종표 on 2023/10/14.
//

import Combine
import UIKit

final class ViewController: UIViewController {
    private var subscription = Set<AnyCancellable>()
    
    private var imageUrls: [URL] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        self.configureUI()
    }
}

extension ViewController {
    private func bind() {
        loadImageUrls()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            } receiveValue: {[weak self] images in
                self?.imageUrls = images.map { URL(string: $0.url)! }
                self?.tableView.reloadData()
                print("현재 DispatchQueue.main")
            }
            .store(in: &subscription)
    }
}

extension ViewController {
    private func loadImageUrls() -> AnyPublisher<[NewImage], Error> {
        let url = URL(string: "https://picsum.photos/v2/list?page=2&limit=100​".trimmingCharacters(in: .whitespaces))!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [NewImage].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    private func image(index: Int) -> AnyPublisher<UIImage?, Never> {
        return Future<UIImage?, Never> { promise in
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: self.imageUrls[index])
                    let image = UIImage(data: data)
                    promise(.success(image))
                } catch(let error) {
                    debugPrint(error.localizedDescription)
                }
            }
        }.eraseToAnyPublisher()
    }
}

extension ViewController {
    private func configureUI() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 80
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return imageUrls.endIndex - 1
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        image(index: indexPath.row)
            .receive(on: DispatchQueue.main)
            .sink { image in
                guard let image else { return }
                cell.newImageView.image = image
                print("cell변경 - \(indexPath.row)")
            }
            .store(in: &subscription)
        return cell
    }
}
