//
//  NewslineViewController.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import Foundation
import UIKit

/// Контроллер для отображения списка новостей.
final class NewslineViewController: UIViewController {

    // MARK: - Internal properties

    /// `Output` вью контроллера.
    let output: NewslineViewOutput

    // MARK: - Private properties

    private var models: [NewsShortDisplayViewModel] = []

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseID)
        tableView.estimatedRowHeight = 88.0
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    // MARK: - Init

    init(output: NewslineViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.output.viewDidLoad()
    }

    // MARK: - Configure UI

    private func setupUI() {
        self.view.backgroundColor = .white
        self.addTableView()
    }

    private func addTableView() {
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.view.leadingAnchor.constraint(equalTo: self.tableView.leadingAnchor),
            self.view.topAnchor.constraint(equalTo: self.tableView.topAnchor),
            self.view.bottomAnchor.constraint(equalTo: self.tableView.bottomAnchor),
            self.view.trailingAnchor.constraint(equalTo: self.tableView.trailingAnchor)
        ])
    }

    @objc private func playTapped() {
        self.output.didTapSettingsButton()
    }
}

// MARK: - NewslineViewInput

extension NewslineViewController: NewslineViewInput {
    func setupModels(models: [NewsShortDisplayViewModel]) {
        self.models = models
        self.tableView.reloadData()
    }

    func setupSettingsNavBarItem(buttonTitle: String) {
        let settingsItem = UIBarButtonItem(title: buttonTitle,
                                           style: .plain,
                                           target: self,
                                           action: #selector(playTapped))
        self.navigationItem.rightBarButtonItem = settingsItem
    }
}

// MARK: - UITableViewDelegate

extension NewslineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.output.didSelectCell(index: indexPath.row)
    }
}

// MARK: - UITableViewDataSource

extension NewslineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { self.models.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reuseID,
                                                       for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        guard let model = self.models[safe: indexPath.row] else { return cell }
        cell.newsTitle = model.title
        cell.imageURLString = model.imageURLString
        cell.dateString = model.dateString
        cell.isRead = model.isRead
        cell.selectionStyle = .none
        return cell
    }
}
