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
        if number.trimmingCharacters(in: .whitespacesAndNewlines).count == 10 {
            return .valid
        } else {
            return .invalid(message: "Select a valid mobile number")
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
	
	static func isValidRequiredField(_ name: String) -> ValidType {
		if name.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
			return .valid
		} else {
			return .invalid(message: "")
		}
	}
	
	static func isValidRequiredField(_ name: String?) -> ValidType {
		if let name = name, name.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
			return .valid
		} else {
			return .invalid(message: "")
		}
	}
	
	static func isValidRequiredField(_ name: Int?) -> ValidType {
		if let name = name, String(name).trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
			return .valid
		} else {
			return .invalid(message: "")
		}
	}
	
	static func isValidPostalCode(_ name: Int?) -> ValidType {
		if let name = name, String(name).trimmingCharacters(in: .whitespacesAndNewlines).count == 6 {
			return .valid
		} else {
			return .invalid(message: "Enter Valid Postal Code")
		}
	}
    
    static func isValidFullName(_ name: String) -> ValidType {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).count >= 5 {
            return .valid
        } else {
            return .invalid(message: "Enter a valid fullname")
        }
    }
	
    static func isValidGender(_ gender: String) -> ValidType {
        if !gender.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return .valid
        } else {
            return .invalid(message: "Select a valid Gender")
        }
    }
 
	static func isValidYear(_ year: Int?) -> ValidType {
		let name = String(year ?? 0)
		if name.trimmingCharacters(in: .whitespacesAndNewlines).count == 4 {
			return .valid
		} else {
			return .invalid(message: "Enter a valid year")
		}
	}
	
	static func isValidPastYear(_ year: Int?) -> ValidType {
		let currentYear = Calendar.current.component(.year, from: Date())
		if let name = year, name <= currentYear {
			return .valid
		} else {
			return .invalid(message: "Enter a valid year")
		}
	}
	
	static func checkIfFromGreaterThanToYear(_ fromYear: Int?, toYear: Int?) -> ValidType {
		if let fromYear = fromYear, let toYear = toYear, fromYear <= toYear {
			return .valid
		}
		
		return .invalid(message: "Enter a valid year")
	}
	
	static func isValidWeeklyHours(_ year: Int?) -> ValidType {
		if let name = year, name <= 168 {
			return .valid
		} else {
			return .invalid(message: "Enter valid hours")
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
        if !number.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
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
