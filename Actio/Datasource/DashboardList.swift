//
//  DashboardList.swift
//  Actio
//
//  Created by senthil on 07/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation
struct DashboardList: Codable {
    let status : String?
    let logID : String?
    let chat : String?
    let notifi : String?
    let modules : [Modules]?

    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case logID = "logID"
        case chat = "chat"
        case notifi = "notifi"
        case modules = "modules"
    }
    
    internal init(status: String, logID: String, chat: String, notifi: String, modules: [Modules]) {
        self.status = status
        self.logID = logID
        self.chat = chat
        self.notifi = notifi
        self.modules = modules
        
    }
    
}


