//
//  NewsCell.swift
//  News
//
//  Created by Ivan Smirnov on 23.03.2022.
//

import Foundation
import UIKit
import SDWebImage

/// Ячейка для отображения новости.
final class NewsCell: UITableViewCell {

    // MARK: - Constants

    private struct Constants {
        static let padding: CGFloat = 24.0
        static let imageWidth: CGFloat = 84.0
        static let imageHeight: CGFloat = 84.0
        static let indentImageFromHeader: CGFloat = 44.0
        static let imageCornerRadius: CGFloat = 10.0
    }

    // MARK: - Internal properties

    static let reuseID = String(describing: type(of: self))

    var newsTitle: String? {
        didSet {
            self.titleLabel.text = self.newsTitle
        }
    }

    var imageURLString: String? {
        didSet {
            guard let imageURL = self.imageURLString, let url = URL(string: imageURL) else {
                        self.newsImageView.image = nil
                        return
                    }
            self.newsImageView.sd_setImage(with: url)
        }
    }

    var dateString: String? {
        didSet {
            self.dateLabel.text = self.dateString
        }
    }

    var isRead: Bool = false {
        didSet {
            self.titleLabel.textColor = self.isRead ? .gray : .black
        }
    }

    // MARK: - Private properties

    private let newsImageView: UIImageView = {
       let newsImageView = UIImageView()
        newsImageView.layer.cornerRadius = Constants.imageCornerRadius
        newsImageView.layer.masksToBounds = true
        newsImageView.contentMode = .scaleAspectFill
        return newsImageView
    }()

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        return titleLabel
    }()

    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 12.0)
        dateLabel.textColor = .gray
        dateLabel.numberOfLines = 0
        return dateLabel
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.titleLabel, self.dateLabel])
        stackView.spacing = 4.0
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var containerView = UIView()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func configureUI() {
        self.addContainerView()
        self.addStackView()
        self.addNewsImageView()
        self.setupConstraints()
    }

    func addStackView() {
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(self.stackView)
    }

    func addNewsImageView() {
        self.newsImageView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(self.newsImageView)
    }

    private func addContainerView() {
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.containerView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                                        constant: Constants.padding),
            self.contentView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor,
                                                       constant: Constants.padding),
            self.containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Constants.padding),
            self.contentView.bottomAnchor.constraint(greaterThanOrEqualTo: self.containerView.bottomAnchor,
                                                     constant: Constants.padding),
            self.newsImageView.widthAnchor.constraint(equalToConstant: Constants.imageWidth),
            self.newsImageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight),
            self.newsImageView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.newsImageView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.newsImageView.bottomAnchor.constraint(lessThanOrEqualTo: self.containerView.bottomAnchor),

            self.containerView.topAnchor.constraint(equalTo: self.stackView.topAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.newsImageView.trailingAnchor,
                                                     constant: Constants.indentImageFromHeader),
            self.stackView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            self.stackView.bottomAnchor.constraint(lessThanOrEqualTo: self.containerView.bottomAnchor)
        ])
    }
}
