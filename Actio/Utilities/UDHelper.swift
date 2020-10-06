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
    
    // MARK: UserId
    class func getUserId()-> String {
        let getUserId =  UserDefaults.standard.object(forKey: "USER_ID")
        return getUserId != nil ? getUserId as! String : ""
    }
    class func setUserId(_ userId:String)-> Void
    {
        UserDefaults.standard.set(userId, forKey: "USER_ID")
        UserDefaults.standard.synchronize()
    }
    
    // MARK: UserLoggedIn
    class func getUserLoggedIn()-> Bool {
        let getUserIogged =  UserDefaults.standard.object(forKey: "USER_LOGGEDIN")
        return (getUserIogged != nil)
    }
    class func setUserLoggedIn(_ userLoggedIn:Bool)-> Void
    {
        UserDefaults.standard.set(userLoggedIn, forKey: "USER_LOGGEDIN")
        UserDefaults.standard.synchronize()
    }


    
    // MARK: User Status
    class func getUserStatus()-> String {
        let getUserStatus =  UserDefaults.standard.object(forKey: "USER_STATUS")
        return getUserStatus != nil ? getUserStatus as! String : ""
    }
    class func setUserStatus(_ status: String)-> Void
    {
        UserDefaults.standard.set(status, forKey: "USER_STATUS")
        UserDefaults.standard.synchronize()
    }
	
	class func setEventDetails(_ details: EventDetail?) {
		if let details = details, let encoded = try? JSONEncoder().encode(details) {
			UserDefaults.standard.set(encoded, forKey: "CurrentEventDetail")
		}
	}
	
	class func getEventDetails() -> EventDetail? {
		if let savedDetails = UserDefaults.standard.object(forKey: "CurrentEventDetail") as? Data {
			if let eventDetail = try? JSONDecoder().decode(EventDetail.self, from: savedDetails) {
				return eventDetail
			}
		}
		
		return nil
	}
    
    class func resetUserStuff() {
        setAuthToken("")
        setUserStatus("")
        setUserId("")
        setUserLoggedIn(false)
    }
}
    
