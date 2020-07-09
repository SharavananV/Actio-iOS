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
    // MARK: - GET Action
    class func getDeviceToken()-> String {
        let getDeviceToken =  UserDefaults.standard.object(forKey: "DEVICE_TOKEN")
        return getDeviceToken != nil ? getDeviceToken as! String : ""
    }
    class func getAuthToken()-> String {
        let getAuthToken =  UserDefaults.standard.object(forKey: "DEVICE_AUTHTOKEN")
        return getAuthToken != nil ? getAuthToken as! String : ""
    }
    
    
    // MARK: -  SET Action
    class func setDeviceToken(_ DeviceToken:String)-> Void
    {
        UserDefaults.standard.set(DeviceToken, forKey: "DEVICE_TOKEN")
        UserDefaults.standard.synchronize()
    }
    class func setAuthToken(_ AuthDeviceToken:String)-> Void
    {
        UserDefaults.standard.set(AuthDeviceToken, forKey: "DEVICE_AUTHTOKEN")
        UserDefaults.standard.synchronize()
    }
}
    