//
//  ApiDetails.swift
//  Actio
//
//  Created by senthil on 08/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation
import UIKit


// Webpage URL
let termsandConditionUrl = "http://playactio.com/terms.html"


let baseUrl = "http://203.223.191.66:8085/"

let masterUrl = baseUrl + "v1/subscriber/init"
let loginUrl = baseUrl + "v1/login"
let registerUrl = baseUrl + "v1/subscriber/register"
let logoutUrl = baseUrl + "v1/logout"

// Forgot
let forgotUserNameUrl = baseUrl + "v1/forgotUsername"
let forgotPasswordUrl = baseUrl + "v1/forgotpassword"
let validateForgotPasswordUrl = baseUrl + "v1/validateforgotpassword"
let updatePasswordUrl = baseUrl + "v1/updatepassword"

// OTP
let validateOTPUrl = baseUrl + "v1/validateotp"
let sendOTPUrl = baseUrl + "v1/sendotp"

//Dashboard
let userStatusUrl = baseUrl + "v1/subscriber/userstatusInfo"
let parentIdUrl = baseUrl + "v1/subscriber/parentID"
let parentApprovalUrl = baseUrl + "v1/subscriber/parentApproval"
let parentApprovalInitUrl =  baseUrl + "v1/subscriber/parentApprovalInit"
let dashboardUrl = baseUrl + "v1/dashboard/count"

//Tournaments
let tournamentListUrl = baseUrl + "v1/tournament/list"
let tournamentDetailsUrl = baseUrl + "v1/tournament/search"

//Feed
let feedListUrl = baseUrl + "v1/feed/list"
let feedUrl = baseUrl + "v1/feed"

// Events
let eventListUrl = baseUrl + "v1/tournament/search/eventcategory"
let eventDetailUrl = baseUrl + "v1/tournament/search/event"
let eventMasterUrl = baseUrl + "v1/registration/master"
let eventRegistrationStatusUrl = baseUrl + "v1/registration/view"
let eventRegistrationPart1Url = baseUrl + "v1/registration/join"
let searchPlayerUrl = baseUrl + "v1/registration/player"
let addPlayersUrl = baseUrl + "v1/registration/addplayers"

// Notification
let notificationListUrl = baseUrl + "v1/notify/list"
let notificationSeenUpdateUrl = baseUrl + "v1/notify/seen"
