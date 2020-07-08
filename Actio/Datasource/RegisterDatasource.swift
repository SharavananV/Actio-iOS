//
//  RegisterDatasource.swift
//  Actio
//
//  Created by Arun Eswaramurthi on 08/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation
import Alamofire

class RegisterDatasource {
    static let shared = RegisterDatasource()
    
    var currentUser: RegisterUserResponse?
    var masterData: MasterData?
    var registerUserUpload: UploadRequest?
    
    func prepareMasterData(with countryCode: Int?, presentAlertOn controller: UIViewController, completion: ((MasterData)->Void)? = nil) {
        let parameters = countryCode == nil ? nil : ["countryID": countryCode]
        
        AF.request(masterUrl, method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: MasterData.self) { (response) in
                switch response.result {
                case .success(let masterData):
                    self.masterData = masterData
                    completion?(masterData)
                case .failure(let error):
                    controller.presentAlert(withTitle: "Network Error", message: error.errorDescription)
                }
        }
    }
    
    func registerUser(registerUserModel: RegisterUser, presentAlertOn controller: UIViewController, progressHandler: @escaping (Progress)->Void, completion: @escaping (RegisterUserResponse)->Void) {
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
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
                    self.currentUser = user
                    completion(user)
                case .failure(let error):
                    controller.presentAlert(withTitle: "Network Error", message: error.errorDescription)
                }
        }
    }
    
    func cancelRegisterUpload() {
        self.registerUserUpload?.cancel()
    }
}

// MARK: - MasterData
struct MasterData: Codable {
    let country: [Country]
    let proof: [Proof]
    let status: String
}

// MARK: - Country
struct Country: Codable {
    let id: Int
    let code, name, alias, minAge: String
    let createdAt: String
    let createdBy: Int

    enum CodingKeys: String, CodingKey {
        case id, code, name, alias
        case minAge = "min_age"
        case createdAt = "created_at"
        case createdBy = "created_by"
    }
}

// MARK: - Proof
struct Proof: Codable {
    let id: Int
    let proof: String
}

// MARK: - RegisterUser
class RegisterUser {
    var fullName, isdCode, isdCodeDisplay, mobileNumber, emailID: String
    var dob, idType, idNumber, userName: String
    var password, confirmPassword, mode, deviceToken: String
    var frontImage, backImage: Data?

    enum CodingKeys: String, CodingKey {
        case fullName, isdCode, mobileNumber, emailID, dob, idType, idNumber, userName, password, confirmPassword
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
        self.confirmPassword = ""
        self.mode = "3" // Constant for iOS
        self.deviceToken = ""
        self.frontImage = nil
        self.backImage = nil
    }
    
    var dateOfBirth: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return dateFormatter.date(from: self.dob) ?? Date()
    }
    
    func parameters() -> [String: Any] {
        return [
            CodingKeys.fullName.rawValue: fullName,
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
}

// MARK: - RegisterUserResponse
struct RegisterUserResponse: Codable {
    let emailID, fullName, isdCode: String
    let mobileNumber, status, subscriberID, subscriberSeqID: Int
    let token, userName: String
    let userStatus: Int
}
