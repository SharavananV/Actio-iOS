//
//  RegisterDatasource.swift
//  Actio
//
//  Created by Arun Eswaramurthi on 08/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation
import Toast_Swift
import Alamofire

class RegisterDatasource {
    static let shared = RegisterDatasource()
    
    var currentUser: RegisterUserResponse?
    var masterData: MasterData?
    var registerUserUpload: UploadRequest?
	private lazy var service = DependencyProvider.shared.networkService
    
    func prepareMasterData(with countryCode: Int?, presentAlertOn controller: UIViewController, completion: ((MasterData)->Void)? = nil) {
        
        var parameters: [String: Any]? = nil
        if let code = countryCode {
            parameters = ["countryID": code]
        }
		
		service.post(masterUrl, parameters: parameters, onView: controller.view, shouldAddDefaultHeaders: false) { (response: MasterData) in
			self.masterData = response
		}
    }
    
    func registerUser(registerUserModel: RegisterUser, presentAlertOn controller: UIViewController, progressHandler: @escaping (Progress)->Void, completion: @escaping (RegisterUserResponse)->Void) {
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        ActioSpinner.shared.show(on: controller.view)
        
        self.registerUserUpload = AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in registerUserModel.parameters() {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let frontData = registerUserModel.frontImage {
                multipartFormData.append(frontData, withName: "frontImage", fileName: "frontimage.png", mimeType: "image/png")
            }
            if let backData = registerUserModel.backImage {
                multipartFormData.append(backData, withName: "backImage", fileName: "backimage.png", mimeType: "image/png")
            }
            
        }, to: registerUrl, usingThreshold: UInt64.init(), method: .post, headers: headers)
        .uploadProgress(queue: .main, closure: { progress in
            progressHandler(progress)
        })
        .responseDecodable(of: RegisterUserResponse.self) { (response) in
            switch response.result {
            case .success(let user):
                if user.status == "200" {
                    self.currentUser = user
                    completion(user)
                } else {
                    if let firstError = user.errors?.first {
                        controller.view.makeToast(firstError.msg)
                    }
                }
            case .failure(let error):
                controller.presentAlert(withTitle: "Network Error", message: error.errorDescription)
                print(error)
            }
                
            ActioSpinner.shared.hide()
        }
    }
    
    func getUserStatus(presentAlertOn controller: UIViewController, completion: @escaping ((UserStatus) -> Void)) {
		
		service.post(userStatusUrl, parameters: nil, onView: controller.view) { (response) in
			if let currentUserStatus = response["currentUserStatus"] as? String, let intStatus = Int(currentUserStatus) {
				UDHelper.setUserStatus(currentUserStatus)
				completion(.success(intStatus))
			}
		}
    }
    
    func logout(presentAlertOn controller: UIViewController, completion: @escaping ((String) -> Void)) {
		service.post(logoutUrl, parameters: ["Mode":"1", "deviceToken": UDHelper.getDeviceToken()], onView: controller.view) { (response) in
			if let message = response["msg"] as? String {
				UDHelper.resetUserStuff()
				completion(message)
			}
		}
    }
    
    func cancelRegisterUpload() {
        self.registerUserUpload?.cancel()
        self.registerUserUpload = nil
    }
}

enum UserStatus {
    case success(Int)
    case failure(String)
}

// MARK: - MasterData
struct MasterData: ResponseType {
	var status: String?
	var errors: [ActioError]?
	var msg: String?
	
    let country: [Country]?
    let proof: [Proof]?
    let gender: [RegistrationGender]?
}

// MARK: - Country
struct Country: Codable {
    let id: Int?
    let code, name, alias, minAge: String?
    let createdAt: String?
    let createdBy: Int?

    enum CodingKeys: String, CodingKey {
        case id, code, name, alias
        case minAge = "min_age"
        case createdAt = "created_at"
        case createdBy = "created_by"
    }
}

// MARK: - Proof
struct Proof: Codable {
    let id: Int?
    let proof: String?
}
// MARK: - Gender
struct RegistrationGender: Codable {
    let id: Int?
    let gender: String?
}


// MARK: - RegisterUser
class RegisterUser {
    var fullName, isdCode, isdCodeDisplay, mobileNumber, emailID: String
    var dob, idType, idNumber, userName: String
    var gender, userType: Int
    var password, confirmPassword, mode, deviceToken: String
    var frontImage, backImage: Data?
    
    var termsAccepted: Bool

    enum CodingKeys: String, CodingKey {
        case fullName, isdCode, mobileNumber, emailID, dob, idType, idNumber, userName, password, confirmPassword,gender,userType
        case mode = "Mode"
        case deviceToken
        case frontImage, backImage
    }
    
    internal init() {
        self.fullName = ""
        self.isdCode = ""
        self.isdCodeDisplay = ""
        self.mobileNumber = ""
        self.emailID = ""
        self.dob = ""
        self.idType = ""
        self.idNumber = ""
        self.userName = ""
        self.password = ""
        self.gender = 0
        self.userType = 0
        self.confirmPassword = ""
        self.mode = "3" // Constant for iOS
        self.deviceToken = ""
        self.frontImage = nil
        self.backImage = nil
        
        self.termsAccepted = false
    }
    
    var dateOfBirth: Date {
        return self.dob.toDate ?? Date()
    }
    
    func parameters() -> [String: Any] {
        return [
            CodingKeys.fullName.rawValue: fullName,
            CodingKeys.gender.rawValue: gender,
            CodingKeys.userType.rawValue: userType,
            CodingKeys.isdCode.rawValue: isdCode,
            CodingKeys.mobileNumber.rawValue: mobileNumber,
            CodingKeys.emailID.rawValue: emailID,
            CodingKeys.dob.rawValue: dob,
            CodingKeys.idType.rawValue: idType,
            CodingKeys.idNumber.rawValue: idNumber,
            CodingKeys.userName.rawValue: userName,
            CodingKeys.password.rawValue: password,
            CodingKeys.confirmPassword.rawValue: confirmPassword,
            CodingKeys.mode.rawValue: mode,
            CodingKeys.deviceToken.rawValue: UDHelper.getDeviceToken()
        ]
    }
    
    func validate(isIndividual: Bool) -> ValidType {
        if Validator.isValidFullName(self.fullName) != .valid {
            return Validator.isValidFullName(self.fullName)
        }
        if Validator.isValidCountryCode(self.isdCode) != .valid {
            return Validator.isValidCountryCode(self.isdCode)
        }
        if Validator.isValidMobileNumber(self.mobileNumber) != .valid {
            return Validator.isValidMobileNumber(self.mobileNumber)
        }
        if Validator.isValidEmail(self.emailID) != .valid {
            return Validator.isValidEmail(self.emailID)
        }
        if Validator.isValidGender(String(self.gender)) != .valid {
            return Validator.isValidGender(String(self.gender))
        }
        if isIndividual, Validator.isValidDob(self.dob) != .valid {
            return Validator.isValidDob(self.dob)
        }
        if Validator.isValidUsername(self.userName) != .valid {
            return Validator.isValidUsername(self.userName)
        }
        if Validator.isValidPassword(self.password) != .valid {
            return Validator.isValidPassword(self.password)
        }
        if Validator.isValidConfirmPassword(self.password, confirmPassword: self.confirmPassword) != .valid {
            return Validator.isValidConfirmPassword(self.password, confirmPassword: self.confirmPassword)
        }
        if termsAccepted == false {
            return .invalid(message: "Please accept the terms and conditions")
        }
        
        return .valid
    }
}

// MARK: - RegisterUserResponse
struct RegisterUserResponse: Codable {
    let emailID, fullName, isdCode, status, subscriberID, subscriberSeqID: String?
    let token, userName, userStatus: String?
    
    let errors: [Error]?
}

// MARK: - Error
struct Error: Codable {
    let value, msg, param, location: String
}
