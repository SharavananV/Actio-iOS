//
//  ApiDetails.swift
//  Actio
//
//  Created by senthil on 08/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation

// Webpage URL
let termsandConditionUrl = "https://playactio.com/terms.html"

let baseUrl = "http://203.223.191.66:8085/v1/"

let masterUrl = baseUrl + "subscriber/init"
let loginUrl = baseUrl + "login"
let registerUrl = baseUrl + "subscriber/register"
let logoutUrl = baseUrl + "logout"

// Forgot
let forgotUserNameUrl = baseUrl + "forgotUsername"
let forgotPasswordUrl = baseUrl + "forgotpassword"
let validateForgotPasswordUrl = baseUrl + "validateforgotpassword"
let updatePasswordUrl = baseUrl + "updatepassword"

// OTP
let validateOTPUrl = baseUrl + "validateotp"
let sendOTPUrl = baseUrl + "sendotp"

//Dashboard
let userStatusUrl = baseUrl + "subscriber/userstatusInfo"
let parentIdUrl = baseUrl + "subscriber/parentID"
let parentApprovalUrl = baseUrl + "subscriber/parentApproval"
let parentApprovalInitUrl =  baseUrl + "subscriber/parentApprovalInit"
let dashboardUrl = baseUrl + "dashboard/count"

//Tournaments
let tournamentListUrl = baseUrl + "tournament/list"
let tournamentDetailsUrl = baseUrl + "tournament/search"
let tournamentMasterUrl = baseUrl + "admin/master/tournamentDetails"

//Feed
let feedListUrl = baseUrl + "feed/list"
let feedUrl = baseUrl + "feed"

// Events
let eventListUrl = baseUrl + "tournament/search/eventcategory"
let eventDetailUrl = baseUrl + "tournament/search/event"
let eventMasterUrl = baseUrl + "registration/master"
let eventRegistrationStatusUrl = baseUrl + "registration/view"
let eventRegistrationPart1Url = baseUrl + "registration/join"
let searchPlayerUrl = baseUrl + "registration/player"
let addPlayersUrl = baseUrl + "registration/addplayers"
let submitRegistrationUrl = baseUrl + "registration/submit"
let editDeletePlayerUrl = baseUrl + "registration/editplayer"

// Friends
let listFriendsUrl = baseUrl + "friend/find"
let friendActionUrl = baseUrl + "friend/action"

// Notification
let notificationListUrl = baseUrl + "notify/list"
let notificationSeenUpdateUrl = baseUrl + "notify/seen"
