//
//  Extensions.swift
//  Actio
//
//  Created by senthil on 08/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation
import UIKit

class UDHelper: NSObject,XMLParserDelegate
{
    // MARK: Device Token
    class func getDeviceToken()-> String {
        let getDeviceToken =  UserDefaults.standard.object(forKey: "DEVICE_TOKEN")
        return getDeviceToken != nil ? getDeviceToken as! String : ""
    }
    class func setDeviceToken(_ DeviceToken:String)-> Void
    {
        UserDefaults.standard.set(DeviceToken, forKey: "DEVICE_TOKEN")
        UserDefaults.standard.synchronize()
    }
    
    // MARK: AUTH Token
    class func getAuthToken()-> String {
        let getAuthToken =  UserDefaults.standard.object(forKey: "DEVICE_AUTHTOKEN")
        return getAuthToken != nil ? getAuthToken as! String : ""
    }
    class func setAuthToken(_ AuthDeviceToken:String)-> Void
    {
        UserDefaults.standard.set(AuthDeviceToken, forKey: "DEVICE_AUTHTOKEN")
        UserDefaults.standard.synchronize()
    }

	// MARK: For all models
	class func setData<E: Encodable>(for type: DefaultsType, data: E?) {
		if let details = data, let encoded = try? JSONEncoder().encode(details) {
			UserDefaults.standard.set(encoded, forKey: type.rawValue)
		}
	}
	
	class func getData<E: Decodable>(for type: DefaultsType) -> E? {
		if let savedDetails = UserDefaults.standard.object(forKey: type.rawValue) as? Data {
			if let data = try? JSONDecoder().decode(E.self, from: savedDetails) {
				return data
			}
		}
		
		return nil
	}

    // MARK: User Status
    class func getUserStatus()-> String {
        let getUserStatus =  UserDefaults.standard.object(forKey: "USER_STATUS")
        return getUserStatus != nil ? getUserStatus as! String : ""
    }
	
    class func setUserStatus(_ status: String)-> Void {
        UserDefaults.standard.set(status, forKey: "USER_STATUS")
        UserDefaults.standard.synchronize()
    }
	
    class func resetUserStuff() {
        setAuthToken("")
        setUserStatus("")
		DefaultsType.allCases.forEach { (type) in
			UserDefaults.standard.setValue(nil, forKey: type.rawValue)
		}
    }
	
	enum DefaultsType: String, CaseIterable {
		case loggedInUser, currentEvent
	}
}
