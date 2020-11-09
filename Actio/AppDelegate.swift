//
//  AppDelegate.swift
//  Actio
//
//  Created by senthil on 03/07/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseInstanceID
import UserNotifications
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	let gcmMessageIDKey = "gcm.message_id"
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateInitialViewController()
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = vc
		window?.makeKeyAndVisible()
		UINavigationBar.appearance().barTintColor = AppColor.OrangeColor()
		UINavigationBar.appearance().titleTextAttributes = [ NSAttributedString.Key.font: AppFont.PoppinsSemiBold(size: 20),NSAttributedString.Key.foregroundColor: UIColor.white]
		UIBarButtonItem.appearance().tintColor = .white
		
		IQKeyboardManager.shared().isEnabled = true
		IQKeyboardManager.shared().toolbarTintColor = #colorLiteral(red: 1, green: 0.3411764706, blue: 0.2, alpha: 1)
		
		FirebaseApp.configure()
		
		UNUserNotificationCenter.current().delegate = self
		
		UNUserNotificationCenter.current().requestAuthorization(
			options: [.alert, .badge, .sound],
			completionHandler: {_, _ in })
		application.registerForRemoteNotifications()
		
		Messaging.messaging().isAutoInitEnabled = true
		Messaging.messaging().delegate = self
		
		return true
	}
	
	func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
		if let url = userActivity.webpageURL {
			var parameters: [String: String] = [:]
			URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
				parameters[$0.name] = $0.value
			}
			
			RedirectionHandler.shared.redirect(with: parameters)
		}
		return true
	}
	
	private func displayAlert(message: String, buttonTitle: String, vc: UIViewController)
	{
		let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
		
		let okAction = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
		alertController.addAction(okAction)
		
		vc.present(alertController, animated: true, completion: nil)
	}
	
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
		// If you are receiving a notification message while your app is in the background,
		// this callback will not be fired till the user taps on the notification launching the application.
		// TODO: Handle data of notification
		
		// With swizzling disabled you must let Messaging know about the message, for Analytics
		Messaging.messaging().appDidReceiveMessage(userInfo)
		
		// Print message ID.
		if let messageID = userInfo[gcmMessageIDKey] {
			print("Message ID: \(messageID)")
		}
		
		// Print full message.
		print(userInfo)
	}
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
					 fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		Messaging.messaging().appDidReceiveMessage(userInfo)
		if let messageID = userInfo[gcmMessageIDKey] {
			print("Message ID: \(messageID)")
		}
		
		print(userInfo)
		completionHandler(UIBackgroundFetchResult.newData)
	}
	
	
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		Messaging.messaging().apnsToken = deviceToken
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		PersistentContainer.saveContext()
	}
}

extension AppDelegate : MessagingDelegate {
	func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
		print("Firebase registration token: \(fcmToken)")
		UDHelper.setDeviceToken(fcmToken)
	}
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
	
	// Receive displayed notifications for iOS 10 devices.
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								willPresent notification: UNNotification,
								withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		let userInfo = notification.request.content.userInfo

		if let messageID = userInfo[gcmMessageIDKey] {
			print("Message ID: \(messageID)")
			
			RedirectionHandler.shared.shouldShowNotification(with: userInfo, completion: completionHandler)
		}
		else {
			completionHandler([])
		}
		print(userInfo)
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								didReceive response: UNNotificationResponse,
								withCompletionHandler completionHandler: @escaping () -> Void) {
		let userInfo = response.notification.request.content.userInfo
		
		if let messageID = userInfo[gcmMessageIDKey] {
			print("Message ID: \(messageID)")
		}
		
		print(userInfo)
		
		RedirectionHandler.shared.handleNotification(with: userInfo)
		completionHandler()
	}
}

