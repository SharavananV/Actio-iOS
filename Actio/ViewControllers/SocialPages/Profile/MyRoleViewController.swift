//
//  MyProfileViewController.swift
//  Actio
//
//  Created by apple on 21/10/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit

class MyRoleViewController: UIViewController {
	
	@IBOutlet weak var editProfileTableView: UITableView!
	fileprivate var formData: [FormCellType]?
    private let service = DependencyProvider.shared.networkService
	var masterData: ProfileMaster?
	var profileRoleModel = ProfileRoleModel() 
	
	override func viewDidLoad() {
		super.viewDidLoad()
		getProfileCall()
		
		editProfileTableView.delegate = self
		editProfileTableView.dataSource = self
		editProfileTableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.reuseId)
		editProfileTableView.register(TextPickerTableViewCell.self, forCellReuseIdentifier: TextPickerTableViewCell.reuseId)
		editProfileTableView.register(TextEditTableViewCell.self, forCellReuseIdentifier: TextEditTableViewCell.reuseId)
		editProfileTableView.register(FootnoteButtonTableViewCell.self, forCellReuseIdentifier: FootnoteButtonTableViewCell.reuseId)
		self.editProfileTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
		editProfileTableView.contentInset = .zero
		
		editProfileTableView.reloadData()
	}
	
	private func getProfileCall() {
		service.post(getProfileUrl, parameters: nil, onView: view) { (response: GetProfileDataResponse) in
			self.profileRoleModel = ProfileRoleModel(data: response.profile)
			self.fetchMasterData()
		}
	}
	
	private func fetchMasterData() {
        let parameters = [ "instituteID":self.profileRoleModel.institute?.instituteID ?? "" , "classID": self.profileRoleModel.institute?.classID ?? "" , "streamID": self.profileRoleModel.institute?.streamID ?? "" ,"countryID":self.profileRoleModel.institute?.countryID ?? "" ,"stateID": self.profileRoleModel.institute?.stateID ?? "", "stateCity":true] as [String : Any]
		
		service.post(masterProfileUrl, parameters: parameters, onView: view) { (response: ProfileMasterResponse) in
			self.masterData = response.master

			self.prepareFormData()
		}
	}
	
	private func updateProfileMyRole() {
		view.endEditing(true)
		
		let validationResult = profileRoleModel.validate()
		switch validationResult {
		case .invalid(let message):
			view.makeToast(message)
			return
			
		case .valid:
			break
		}
		
		service.post(profileUrl, parameters: profileRoleModel.parameters(), onView: view) { (response) in
			if let msg = response["msg"] as? String {
				self.view.makeToast(msg)
				self.navigationController?.popViewController(animated: true)
			}
		}
	}
	
	private func prepareFormData() {
		
		let studentString = NSMutableAttributedString(string: "Are you student at school/university?", attributes: [NSAttributedString.Key.font : AppFont.PoppinsRegular(size: 15)])
		
		var formData: [FormCellType] = [
			.toggle(ToggleViewModel(key: "student", contextText: studentString, defaultValue: (profileRoleModel.isStudent == true)))
		]
		
		if profileRoleModel.isStudent == true {
			let states = self.masterData?.stateCity?.map({ (state) -> String in
				return state.stateName ?? ""
			}) ?? []
			let selectedState = self.masterData?.stateCity?.first(where: {
				String($0.stateID ?? 0) == String(self.profileRoleModel.institute?.stateID ?? 0)
			})
			
			let city = self.masterData?.city?.map({ (city) -> String in
				return city.cityName ?? ""
			}) ?? []
			
			let selectedstateCity = self.masterData?.city?.first(where: {
				String($0.cityId ?? 0) == String(self.profileRoleModel.institute?.cityID ?? 0)
			})
			
			let institution = self.masterData?.institute?.map({ (institute) -> String in
				return institute.instituteName ?? ""
			}) ?? []
			let selectedinstitution = self.masterData?.institute?.first(where: {
				String($0.id ?? 0) == String(self.profileRoleModel.institute?.instituteID ?? 0)
			})
			
			let roleclass = self.masterData?.instituteClass?.map({ (instituteClass) -> String in
				return instituteClass.instituteClass ?? ""
			}) ?? []
			let selectedroleclass = self.masterData?.instituteClass?.first(where: {
				String($0.id ?? 0) == String(self.profileRoleModel.institute?.classID ?? 0)
			})
			
			let country = self.masterData?.country?.map({ (country) -> String in
				return country.country ?? ""
			}) ?? []
			
			let selectedCountry = self.masterData?.country?.first(where: {
				String($0.id ?? 0) == String(self.profileRoleModel.institute?.countryID ?? 0)
			})
			
			let stream = self.masterData?.instituteStream?.map({ (instituteStream) -> String in
				return instituteStream.stream ?? ""
			}) ?? []
			
			let selectedstream = self.masterData?.instituteStream?.first(where: {
				String($0.id ?? 0) == String(self.profileRoleModel.institute?.streamID ?? 0)
			})
			let divison = self.masterData?.institutedivision?.map({ (institutedivision) -> String in
				return institutedivision.division ?? ""
			}) ?? []
			
			let selecteddivison = self.masterData?.institutedivision?.first(where: {
				String($0.id ?? 0) == String(self.profileRoleModel.institute?.divisionID ?? 0)
			})
			
			let pinCodeText = profileRoleModel.institute?.pincode != nil ? String(profileRoleModel.institute?.pincode ?? 0) : ""
			
			formData.append(contentsOf: [
				.textPicker(TextPickerModel(key: "institute", textValue:selectedinstitution?.instituteName, allValues: institution, contextText: "I am studying at",placeHolder: "Select Institution")),
				.academic(profileRoleModel.institute),
				.textPicker(TextPickerModel(key: "class", textValue:selectedroleclass?.instituteClass, allValues: roleclass, contextText: "Class",placeHolder: "Select Class")),
				.textPicker(TextPickerModel(key: "stream", textValue:selectedstream?.stream, allValues: stream, contextText: "Stream",placeHolder: "Select Stream")),
				.textPicker(TextPickerModel(key: "divison", textValue:selecteddivison?.division, allValues: divison, contextText: "Divison",placeHolder: "Select Divison")),
				.textPicker(TextPickerModel(key: "country", textValue:selectedCountry?.country, allValues: country, contextText: "Country",placeHolder: "Select Country")),
				.textPicker(TextPickerModel(key: "state", textValue:selectedState?.stateName, allValues: states, contextText: "State",placeHolder: "Select State")),
				.textPicker(TextPickerModel(key: "city", textValue:selectedstateCity?.cityName, allValues: city, contextText: "City",placeHolder: "Select City")),
				.textEdit(TextEditModel(key: "postalcode", textValue: pinCodeText, contextText: "Postal Code", placeHolder: "Postal Code", isSecure: false))
			])
		}
		
		let showPlayDelete = self.profileRoleModel.sportsPlay.count > 1
		let sportsPlayAdd: [FormCellType] = self.profileRoleModel.sportsPlay.map({ (play) -> FormCellType in
			.sportsPlay(play, showPlayDelete)
		})
		
		if sportsPlayAdd.isEmpty {
			let playModel = Play()
			self.profileRoleModel.sportsPlay.append(playModel)
			formData.append(.sportsPlay(playModel, showPlayDelete))
		} else {
			formData.append(contentsOf: sportsPlayAdd)
		}
		
		formData.append(.addCell("+ Add Another sport you play"))
		
		let coachingString = NSMutableAttributedString(string: "Do you conduct coaching?", attributes: [NSAttributedString.Key.font : AppFont.PoppinsRegular(size: 15)])
		
		formData.append(
			.toggle(ToggleViewModel(key: "coach", contextText: coachingString, defaultValue: (profileRoleModel.isCoach == true)))
		)
		
		let showCoachDelete = self.profileRoleModel.coaching.count > 1
		var sportsCoachAdd: [FormCellType] = self.profileRoleModel.coaching.map({ (coach) -> FormCellType in
			.sportsCoach(coach, showCoachDelete)
		})
		
		if sportsCoachAdd.isEmpty && profileRoleModel.isCoach == true {
			let coachModel = Coaching()
			self.profileRoleModel.coaching.append(coachModel)
			sportsCoachAdd.append(.sportsCoach(coachModel, showCoachDelete))
		}
		
		if profileRoleModel.isCoach == true {
			formData.append(contentsOf: sportsCoachAdd)
			formData.append(.addCell("+ Add Another sport you Coach"))
		}
		
		let sponserString = NSMutableAttributedString(string: "Do you wish to sponser any tournament?", attributes: [NSAttributedString.Key.font : AppFont.PoppinsRegular(size: 15)])
		
		formData.append(
			.toggle(ToggleViewModel(key: "sponser", contextText: sponserString, defaultValue: (profileRoleModel.isSponser == true)))
		)
		
		if profileRoleModel.isSponser == true {
			let sponserData: [FormCellType] = [
				.textEdit(TextEditModel(key: "sponsership", textValue: profileRoleModel.sponsorRemarks, contextText: "About Sponsorship", placeHolder: "Enter about sponsorship", isSecure: false))
			]
			formData.append(contentsOf: sponserData)
		}
		
		let organizeString = NSMutableAttributedString(string: "Do you wish to organize Events?", attributes: [NSAttributedString.Key.font : AppFont.PoppinsRegular(size: 15)])
		
		formData.append(
			.toggle(ToggleViewModel(key: "organize", contextText: organizeString, defaultValue: (profileRoleModel.isOrganizer == true)))
		)
		
		if profileRoleModel.isOrganizer == true {
			let organizerData: [FormCellType] = [
				.textEdit(TextEditModel(key: "organizeEvents", textValue: profileRoleModel.organizerRemarks, contextText: "About Organizing Events", placeHolder: "Enter about organizing events", isSecure: false))
			]
			formData.append(contentsOf: organizerData)
		}
		
		formData.append(.button("Submit"))
		
		self.formData = formData
		
		UIView.setAnimationsEnabled(false)
		self.editProfileTableView.reloadData()
	}
}

extension MyRoleViewController :  UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.formData?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell? = nil
		guard let cellData = self.formData?[indexPath.row] else { return UITableViewCell() }
		
		switch cellData {
		
		case .toggle(let model):
			guard let toggleCell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.reuseId, for: indexPath) as? SwitchTableViewCell else {
				return UITableViewCell()
			}
			
			toggleCell.configure(model, delegate: self)
			cell = toggleCell
			
		case .button(let title):
			guard let buttonCell = tableView.dequeueReusableCell(withIdentifier: FootnoteButtonTableViewCell.reuseId, for: indexPath) as? FootnoteButtonTableViewCell else {
				return UITableViewCell()
			}
			
			buttonCell.configure(title: title, delegate: self)
			cell = buttonCell
			
			
		case .textEdit(let model):
			guard let textEditCell = tableView.dequeueReusableCell(withIdentifier: TextEditTableViewCell.reuseId, for: indexPath) as? TextEditTableViewCell else {
				return UITableViewCell()
			}
			
			textEditCell.configure(model)
			textEditCell.delegate = self
			cell = textEditCell
			
		case .textPicker(let model):
			guard let textPickerCell = tableView.dequeueReusableCell(withIdentifier: TextPickerTableViewCell.reuseId, for: indexPath) as? TextPickerTableViewCell else {
				return UITableViewCell()
			}
			
			textPickerCell.configure(model)
			textPickerCell.delegate = self
			cell = textPickerCell
			
		case .sportsPlay(let data, let showDelete):
			guard let playCell = tableView.dequeueReusableCell(withIdentifier: SportsPlayTableViewCell.reuseId, for: indexPath) as? SportsPlayTableViewCell else {
				return UITableViewCell()
			}
			playCell.delegate = self
			playCell.configure(data, allSports: masterData?.sports, showDelete: showDelete)
			cell = playCell
		
		case .sportsCoach(let coach, let showDelete):
			guard let coachCell = tableView.dequeueReusableCell(withIdentifier: SportsCoachTableViewCell.reuseId, for: indexPath) as? SportsCoachTableViewCell else {
				return UITableViewCell()
			}
			
			coachCell.delegate = self
			coachCell.configure(coach, allSports: self.masterData?.sports, allStateCities: self.masterData?.stateCity, showDelete: showDelete)
			cell = coachCell
			
		case .academic(let data):
			guard let academicCell = tableView.dequeueReusableCell(withIdentifier: AcademicYearTableViewCell.reuseId, for: indexPath) as? AcademicYearTableViewCell else {
				return UITableViewCell()
			}
			academicCell.toYearTextField.text = data?.academicToYear != nil ? String(data?.academicToYear ?? 0) : nil
			academicCell.fromYearTextField.text = data?.academicFromYear != nil ? String(data?.academicFromYear ?? 0) : nil
			academicCell.configure(data)
			
			cell = academicCell
           
		case .addCell(let title):
			guard let addCell = tableView.dequeueReusableCell(withIdentifier: AddAnotherSportTableViewCell.reuseId, for: indexPath) as? AddAnotherSportTableViewCell else {
				return UITableViewCell()
			}
			addCell.titleLabel.text = title
			cell = addCell
		}
		
		cell?.selectionStyle = .none
		
		return cell ?? UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) as? AddAnotherSportTableViewCell {
			view.endEditing(true)
			
			if cell.titleLabel.text == "+ Add Another sport you play" {
				var message = ""
				for sport in self.profileRoleModel.sportsPlay {
					switch sport.validate() {
					case .valid:
						continue
					case .invalid(let error):
						message = error
					}
					
					if !message.isEmpty {
						view.makeToast(message)
					}
				}
				
				if message.isEmpty {
					self.profileRoleModel.sportsPlay.append(Play())
				}
			} else {
				var message = ""
				for coach in self.profileRoleModel.coaching {
					switch coach.validate() {
					case .valid:
						continue
					case .invalid(let error):
						message = error
					}
					
					if !message.isEmpty {
						view.makeToast(message)
					}
				}
				
				if message.isEmpty {
					self.profileRoleModel.coaching.append(Coaching())
				}
			}
			
			prepareFormData()
		}
	}
}
extension MyRoleViewController : FootnoteButtonDelegate, CellDataFetchProtocol, TextPickerDelegate, SwitchCellDelegate, CoachInfoDeleteProtocol, SportInfoDeleteProtocol {
	func footnoteButtonCallback(_ title: String) {
		updateProfileMyRole()
	}
	
	func valueChanged(keyValuePair: (key: String, value: String)) {
        switch keyValuePair.key {
        case "postalcode":
            self.profileRoleModel.institute?.pincode = Int(keyValuePair.value)
		case "organizeEvents":
			self.profileRoleModel.organizerRemarks = keyValuePair.value
		case "sponsership":
			self.profileRoleModel.sponsorRemarks = keyValuePair.value
        default:
            break;
        }
        prepareFormData()
	}
	
	func didPickText(_ key: String, index: Int) {
		if self.profileRoleModel.institute == nil {
			self.profileRoleModel.institute = Institute()
		}
		
		switch key {
		case "institute":
			if self.masterData?.institute?.isEmpty == false, let instituteId = self.masterData?.institute?[index].id {
				self.profileRoleModel.institute?.instituteID = Int(instituteId)
				self.profileRoleModel.institute?.classID = nil
				self.profileRoleModel.institute?.streamID = nil
				self.profileRoleModel.institute?.divisionID = nil
			}
		case "class":
			if self.masterData?.instituteClass?.isEmpty == false, let instituteclassId = self.masterData?.instituteClass?[index].id {
				self.profileRoleModel.institute?.classID = Int(instituteclassId)
				self.profileRoleModel.institute?.streamID = nil
				self.profileRoleModel.institute?.divisionID = nil
			}
		case "stream":
			if self.masterData?.instituteStream?.isEmpty == false, let instituteStreamId = self.masterData?.instituteStream?[index].id {
				self.profileRoleModel.institute?.streamID = Int(instituteStreamId)
				self.profileRoleModel.institute?.divisionID = nil
			}
        case "divison":
            if self.masterData?.institutedivision?.isEmpty == false, let instituteDivisionId = self.masterData?.institutedivision?[index].id {
                self.profileRoleModel.institute?.divisionID = Int(instituteDivisionId)
				
				return
            }
		case "country":
			if self.masterData?.country?.isEmpty == false, let countryId = self.masterData?.country?[index].id {
				self.profileRoleModel.institute?.countryID = Int(countryId)
				self.profileRoleModel.institute?.stateID = nil
				self.profileRoleModel.institute?.cityID = nil
			}
		case "state":
			if self.masterData?.state?.isEmpty == false, let stateId = self.masterData?.state?[index].id {
				self.profileRoleModel.institute?.stateID = Int(stateId)
				self.profileRoleModel.institute?.cityID = nil
			}
        case "city":
            if self.masterData?.city?.isEmpty == false, let instituteCityId = self.masterData?.city?[index].cityId {
                self.profileRoleModel.institute?.cityID = Int(instituteCityId)
				
				return
            }
		default:
			break
		}
		
		fetchMasterData()
	}
	
	func toggleValueChanged(_ key: String, value: Bool) {
		if key == "coach" {
			profileRoleModel.isCoach = value
			prepareFormData()
		}
		else if key == "sponser" {
			profileRoleModel.isSponser = value
			prepareFormData()
			
		}
		else if key == "organize" {
			profileRoleModel.isOrganizer = value
			prepareFormData()
		}
        else if key == "student" {
            profileRoleModel.isStudent = value
            prepareFormData()
        }
	}
	
	func sportDeleted(_ data: Play?) {
		profileRoleModel.sportsPlay.removeAll { $0.id == data?.id }
		
		prepareFormData()
	}
	
	func coachDeleted(_ data: Coaching?) {
		profileRoleModel.coaching.removeAll { $0.id == data?.id }
		
		prepareFormData()
	}
}

private enum FormCellType {
	case academic(Institute?)
	case sportsPlay(Play?, Bool)
	case sportsCoach(Coaching?, Bool)
	case addCell(String)
	case textEdit(TextEditModel)
	case textPicker(TextPickerModel)
	case toggle(ToggleViewModel)
	case button(String)
	
}



