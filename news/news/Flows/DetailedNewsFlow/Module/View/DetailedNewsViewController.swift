//
//  DetailedNewsViewController.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import Foundation
import UIKit
import SDWebImage

final class DetailedNewsViewController: UIViewController {

    // MARK: - Internal properties

    /// Output вью контроллера.
    let output: DetailedNewsViewOutput

    // MARK: - Private properties

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInset = .init(top: 24.0, left: 0.0, bottom: 24.0, right: 0.0)
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel,
                                                       self.imageView,
                                                       self.descriptionLabel,
                                                       self.sourceLabel])
        stackView.axis = .vertical
        stackView.spacing = 24.0
        return stackView
    }()

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 16.0, weight: .heavy)
        return titleLabel
    }()

    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 14.0)
        return descriptionLabel
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let sourceLabel: UILabel = {
        let sourceLabel = UILabel()
        sourceLabel.numberOfLines = 0
        sourceLabel.textColor = .gray
        sourceLabel.font = .systemFont(ofSize: 12.0)
        return sourceLabel
    }()

    // MARK: - Init

    init(output: DetailedNewsViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.output.viewDidLoad()
        self.setupUI()
    }

    // MARK: - Configure UI

    private func setupUI() {
        self.view.backgroundColor = .white
        self.addScrollView()
        self.addStackView()
        self.setupConstraints()
    }

    private func addScrollView() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.scrollView)
    }

    private func addStackView() {
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.stackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 12.0),
            self.scrollView.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor, constant: 12.0),
            self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.stackView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant: -24.0),
            self.imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor)
        ])
    }
}

// MARK: - DetailedNewsViewInput

extension DetailedNewsViewController: DetailedNewsViewInput {

    func setupViewModel(model: NewsDeployedViewModel) {
        self.titleLabel.text = model.title
        self.descriptionLabel.text = model.description
        self.sourceLabel.text = model.source
        if let urlString = model.imageURLString, let url = URL(string: urlString) {
            self.imageView.sd_setImage(with: url)
        }
    }
}

// MARK: - NavigationInteractionDependable
extension DetailedNewsViewController: NavigationInteractionDependable {
    func viewControllerIsRemovingBy(_ navigationInteractionMethod: NavigationInteractionMethod) {
        self.output.viewControllerIsRemoving()
    }
}
