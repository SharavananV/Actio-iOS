//
//  NotificationHelper.swift
//  Actio
//
//  Created by apple on 15/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

enum NotificationHelper: String {
    
    case locationUpdated

    var notification : Notification.Name  {
        return Notification.Name(rawValue: self.rawValue )
    }
}

extension NotificationCenter {
    func post(_  type: NotificationHelper, object: Any?) {
        self.post(name: type.notification, object: object)
    }
}
