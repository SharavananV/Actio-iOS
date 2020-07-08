//
//  Validator.swift
//  Actio
//
//  Created by apple on 08/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

struct Validator {
    static func isValidEmail(_ email: String) -> ValidType {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailPred.evaluate(with: email) && !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .valid
        } else {
            return .invalid(message: "Enter a valid email ID")
        }
    }
    
    static func isValidCountryCode(_ code: String) -> ValidType {
        if !code.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .valid
        } else {
            return .invalid(message: "Select a valid country code")
        }
    }
    
    static func isValidMobileNumber(_ number: String) -> ValidType {
        if !number.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .valid
        } else {
            return .invalid(message: "Select a valid country code")
        }
    }
    
    static func isValidDob(_ dob: String) -> ValidType {
        if !dob.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .valid
        } else {
            return .invalid(message: "Select a valid date of birth")
        }
    }
    
    static func isValidUsername(_ name: String) -> ValidType {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).count >= 5 {
            return .valid
        } else {
            return .invalid(message: "Select a valid user name")
        }
    }
    
    static func isValidFullName(_ name: String) -> ValidType {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).count >= 5 {
            return .valid
        } else {
            return .invalid(message: "Enter a valid fullname")
        }
    }
    
    static func isValidPassword(_ password: String) -> ValidType {
        if !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .valid
        } else {
            return .invalid(message: "Enter a valid password")
        }
    }
    
    static func isValidConfirmPassword(_ password: String, confirmPassword: String) -> ValidType {
        if password == confirmPassword {
            return .valid
        } else {
            return .invalid(message: "Passwords do not match")
        }
    }
    
    static func isValidIdType(_ idType: String) -> ValidType {
        if !idType.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .valid
        } else {
            return .invalid(message: "Select a valid ID type")
        }
    }
    
    static func isValidIdNumber(_ number: String) -> ValidType {
        if number.trimmingCharacters(in: .whitespacesAndNewlines).count == 10 {
            return .valid
        } else {
            return .invalid(message: "Enter a valid ID number")
        }
    }
}

enum ValidType {
    case valid
    case invalid(message: String)
    
    static public func ==(lhs: ValidType, rhs: ValidType) -> Bool {
        switch (lhs, rhs) {
        case (.valid, .valid),
             (.invalid(_), .invalid(_)):
          return true
        default:
          return false
        }
    }
    
    static public func !=(lhs: ValidType, rhs: ValidType) -> Bool {
        switch (lhs, rhs) {
        case (.valid, .invalid(_)),
             (.invalid(_), .valid):
          return true
        default:
          return false
        }
    }
}
