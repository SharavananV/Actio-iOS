//
//  AddPlayersViewController.swift
//  Actio
//
//  Created by senthil on 05/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class AddPlayersViewController: UIViewController {

	@IBOutlet var tableView: UITableView!
	
	let service = DependencyProvider.shared.networkService
	fileprivate var formData: [FormCellType]?
	
	override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UserSelectionTableViewCell.self, forCellReuseIdentifier: UserSelectionTableViewCell.reuseId)
    }
	
	private func prepareFormData() {
		self.formData = [
			
		]
	}
}

extension AddPlayersViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: UserSelectionTableViewCell.reuseId, for: indexPath) as? UserSelectionTableViewCell else {
			return UITableViewCell()
		}
		
		cell.delegate = self
		
		return cell
	}
}

extension AddPlayersViewController: UserSelectionProtocol {
	func selectedPlayer(_ player: SearchUserModel) {
		print("Selected Player \(player.username)")
	}
	
	func resetData() {
		print("Reset data")
	}
	
	func playerList(forSearchText text: String, completion: @escaping ([SearchUserModel]) -> Void) {
		service.post(searchPlayerUrl, parameters: ["search": text, "eventID": 209], onView: view) { (response: SearchPlayerResponse) in
			completion(response.search ?? [])
		}
	}
	
	func reloadHeight() {
		tableView.beginUpdates()
		tableView.endUpdates()
	}
}

private enum FormCellType {
	case textEdit(TextEditModel)
	case textPicker(TextPickerModel)
	case button(String)
	case toggle(ToggleViewModel)
}
