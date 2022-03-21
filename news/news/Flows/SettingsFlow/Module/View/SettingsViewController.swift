//
//  SettingsViewController.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import Foundation
import UIKit

final class SettingsViewController: UIViewController {

    // MARK: - Internal properties

    /// Output вью контроллера.
    let output: SettingsViewOutput

    // MARK: - Private properties

    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.setTitle("close", for: .normal)
        closeButton.setTitleColor(.blue, for: .normal)
        closeButton.addTarget(self, action: #selector(tapCloseButton), for: .touchUpInside)
        return closeButton
    }()

    private lazy var tabelView: UITableView = {
        let tabelView = UITableView()
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsViewControllerCell")
        return tabelView
    }()

    private let infoChooseLabel: UILabel = {
        let infoChooseLabel = UILabel()
        infoChooseLabel.text = "Choose update time"
        infoChooseLabel.textAlignment = .center
        return infoChooseLabel
    }()

    private let infoSourceLabel: UILabel = {
        let infoSourceLabel = UILabel()
        infoSourceLabel.text = "Sources"
        infoSourceLabel.textAlignment = .center
        return infoSourceLabel
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            self.infoChooseLabel,
            self.pickerView,
            self.infoSourceLabel,
            self.tabelView
        ])
        stackView.spacing = 12.0
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()

    private var updateTimesTitles: [String] = []

    private var sourcesTitles: [String] = [] {
        didSet {
            self.tabelView.reloadData()
        }
    }

    private var isTabelViewTapEnabled = true

    // MARK: - Init

    init(output: SettingsViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupUI()
        self.output.viewDidLoad()
    }

    // MARK: - Configure UI

    private func setupUI() {
        self.addCloseButton()
        self.addStackView()
        self.setupСonstraints()
    }

    private func addCloseButton() {
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.closeButton)
    }

    private func addStackView() {
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.stackView)
    }

    private func setupСonstraints() {
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.closeButton.bottomAnchor, constant: 32.0),
            self.stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),

            self.closeButton.widthAnchor.constraint(equalToConstant: 80.0),
            self.closeButton.heightAnchor.constraint(equalToConstant: 80.0),
            self.closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32.0),
            self.closeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24.0),
            self.pickerView.heightAnchor.constraint(equalToConstant: 184.0)
        ])
    }

    // MARK: - Private methods

    @objc private func tapCloseButton() {
        self.output.didTapCloseButton()
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.isTabelViewTapEnabled else { return }
        self.output.didSelectCellIndex(index: indexPath.row)
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.sourcesTitles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsViewControllerCell", for: indexPath)
        cell.selectionStyle = .none
        let cellText = self.sourcesTitles[safe: indexPath.row]
        if #available(iOS 14.0, *) {
            var configuration = cell.defaultContentConfiguration()
            configuration.text = cellText
            cell.contentConfiguration = configuration
        } else {
            cell.textLabel?.text = cellText
        }
        return cell
    }
}

// MARK: - UIPickerViewDelegate

extension SettingsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.output.didSelectPickerCellIndex(index: row)
    }
}

// MARK: - UIPickerViewDataSource

extension SettingsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.updateTimesTitles.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.updateTimesTitles[safe: row]
    }
}

// MARK: - SettingsViewInput

extension SettingsViewController: SettingsViewInput {
    func tabelViewTapIsEnabled(isEnabled: Bool) {
        self.isTabelViewTapEnabled = isEnabled
    }

    func setupUpdateTimesTitles(titles: [String], chosenIndex: Int) {
        self.updateTimesTitles = titles
        self.pickerView.reloadAllComponents()
        self.pickerView.selectRow(chosenIndex, inComponent: 0, animated: false)
    }

    func setupSourcesTitles(titles: [String]) {
        self.sourcesTitles = titles
    }
}
