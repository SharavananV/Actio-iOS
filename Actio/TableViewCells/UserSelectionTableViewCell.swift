//
//  UserSelectionTableViewCell.swift
//  Actio
//
//  Created by senthil on 05/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

protocol UserSelectionProtocol: class {
	func reloadHeight()
	func playerList(forSearchText text: String, completion: @escaping ([SearchUserModel])->Void)
	func selectedPlayer(_ player: SearchUserModel)
	func resetData()
}

class UserSelectionTableViewCell: UITableViewCell {
	static let reuseId = "UserSelectionTableViewCell"
	weak var delegate: UserSelectionProtocol?
	
	private let service = DependencyProvider.shared.networkService
	private var searchedUsers: [SearchUserModel]?
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		commonInit()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - UIRelated
	private lazy var contentLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = AppFont.PoppinsMedium(size: 13)
		label.textColor = .darkGray
		label.text = "Search By"
		label.numberOfLines = 0
		label.setContentHuggingPriority(.defaultLow, for: .horizontal)
		label.setContentHuggingPriority(.required, for: .vertical)
		
		self.contentView.addSubview(label)
		
		return label
	}()
	
	private lazy var segmentControl: UISegmentedControl = {
		let segmentControl = UISegmentedControl(items: ["Subscription ID", "Username"])
		segmentControl.translatesAutoresizingMaskIntoConstraints = false
		segmentControl.selectedSegmentIndex = -1
		segmentControl.layer.cornerRadius = 5.0
		segmentControl.clipsToBounds = true
		segmentControl.tintColor = #colorLiteral(red: 1, green: 0.3411764706, blue: 0.2, alpha: 1)
		segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : #colorLiteral(red: 1, green: 0.3411764706, blue: 0.2, alpha: 1)], for: .normal)
		segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
		segmentControl.apportionsSegmentWidthsByContent = true
		
		if #available(iOS 13.0, *) {
			segmentControl.selectedSegmentTintColor = #colorLiteral(red: 1, green: 0.3411764706, blue: 0.2, alpha: 1)
		}
		
		segmentControl.addTarget(self, action: #selector(segmentTapped(sender:)), for: .valueChanged)
		self.contentView.addSubview(segmentControl)
		
		return segmentControl
	}()
	
	private lazy var resetButton: UIButton = {
		let button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitleColor(#colorLiteral(red: 1, green: 0.3411764706, blue: 0.2, alpha: 1), for: .normal)
		button.titleLabel?.font = AppFont.PoppinsBold(size: 15)
		button.setTitle("Reset", for: .normal)
		button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
		
		self.contentView.addSubview(button)
		
		return button
	}()
	
	private lazy var searchBar: UISearchBar = {
		let searchBar = UISearchBar()
		searchBar.translatesAutoresizingMaskIntoConstraints = false
		searchBar.placeholder = "Type Your Search"
		searchBar.delegate = self
		
		return searchBar
	}()
	
	private lazy var tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .plain)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.dataSource = self
		tableView.delegate = self
		tableView.separatorStyle = .singleLine
		tableView.separatorColor = .darkGray
		tableView.separatorInset = UIEdgeInsets(top: 0, left: .kInternalPadding, bottom: 0, right: 0)
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "userCell")
		
		return tableView
	}()
	
	@objc func segmentTapped(sender: UISegmentedControl) {
		contentView.addSubview(searchBar)
		
		NSLayoutConstraint.activate( [
			searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .kTableCellPadding),
			searchBar.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 10),
			searchBar.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
			searchBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.kTableCellPadding)
		])
		
		delegate?.reloadHeight()
	}
	
	@objc func buttonTapped(_ sender: UIButton) {
		delegate?.resetData()
	}
}

extension UserSelectionTableViewCell: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		guard let searchText = searchBar.text else { return }
		
		delegate?.playerList(forSearchText: searchText, completion: { (users) in
			if self.searchedUsers == nil || self.searchedUsers?.isEmpty == true {
				self.contentView.addSubview(self.tableView)
				
				NSLayoutConstraint.activate([
					self.tableView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .kTableCellPadding),
					self.tableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 10),
					self.tableView.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -10),
					self.tableView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -.kTableCellPadding),
					self.tableView.heightAnchor.constraint(equalToConstant: 132)
				])
				
				self.delegate?.reloadHeight()
			}
			
			self.searchedUsers = users
			self.tableView.reloadData()
		})
	}
}

extension UserSelectionTableViewCell: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return searchedUsers?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
		cell.textLabel?.text = searchedUsers?[indexPath.row].fullName
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let user = searchedUsers?[indexPath.row] else { return }
		
		delegate?.selectedPlayer(user)
	}
}

extension UserSelectionTableViewCell {
	private func commonInit() {
		setConstraints()
	}
	
	private func setConstraints() {
		let constraints = [
			contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .kTableCellPadding),
			contentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .kTableCellPadding),
			contentLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
			
			segmentControl.leadingAnchor.constraint(equalTo: contentLabel.trailingAnchor, constant: 10),
			segmentControl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .kTableCellPadding),
			segmentControl.heightAnchor.constraint(equalToConstant: 30),
			segmentControl.bottomAnchor.constraint(equalTo: contentLabel.bottomAnchor),
			
			resetButton.leadingAnchor.constraint(equalTo: segmentControl.trailingAnchor, constant: 10),
			resetButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .kTableCellPadding),
			resetButton.bottomAnchor.constraint(equalTo: contentLabel.bottomAnchor),
			resetButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.kTableCellPadding)
		]
		
		NSLayoutConstraint.activate(constraints)
	}
}
