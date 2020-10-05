//
//  ApiDetails.swift
//  Actio
//
//  Created by senthil on 08/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation
import UIKit

let baseUrl = "http://203.223.191.66:8085/"

let masterUrl = baseUrl + "v1/subscriber/init"
let loginUrl = baseUrl + "v1/login"
let forgotUserNameUrl = baseUrl + "v1/forgotUsername"
let forgotPasswordUrl = baseUrl + "v1/forgotpassword"
let registerUrl = baseUrl + "v1/subscriber/register"
let validateOTPUrl = baseUrl + "v1/validateotp"
let userStatusUrl = baseUrl + "v1/subscriber/userstatusInfo"
let parentIdUrl = baseUrl + "v1/subscriber/parentID"
let logoutUrl = baseUrl + "v1/logout"
let parentApprovalUrl = baseUrl + "v1/subscriber/parentApproval"
let parentApprovalInitUrl =  baseUrl + "v1/subscriber/parentApprovalInit"
let dashboardUrl = baseUrl + "v1/dashboard/count"
let tournamentListUrl = baseUrl + "v1/tournament/list"
let tournamentDetailsUrl = baseUrl + "v1/tournament/search"
let feedListUrl = baseUrl + "v1/feed/list"
let feedUrl = baseUrl + "v1/feed"

// Events
let eventListUrl = baseUrl + "v1/tournament/search/eventcategory"
let eventDetailUrl = baseUrl + "v1/tournament/search/event"
let eventMasterUrl = baseUrl + "v1/registration/master"

// Notification
let notificationListUrl = baseUrl + "v1/notify/list"
let notificationSeenUpdateUrl = baseUrl + "v1/notify/seen"
