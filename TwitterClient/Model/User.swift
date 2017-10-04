//
//  User.swift
//  TwitterClient
//
//  Created by Vijayanand on 9/29/17.
//  Copyright © 2017 Vijayanand. All rights reserved.
//

import UIKit

class User: NSObject {
	let name: NSString?
	let screenName: NSString?
	let profileImageUrl: URL?
	let tagLine: NSString?
	
	private var dictionary: NSDictionary?
	static let userDidLogoutNotification = "UserDidLogout"
	
	init(userDictionary:NSDictionary) {
		dictionary = userDictionary
		name = userDictionary["name"] as? NSString
		screenName = userDictionary["screen_name"] as? NSString
		tagLine = userDictionary["description"] as? NSString
		let profileImageUrlString = userDictionary["profile_image_url"] as? NSString
		if let profileImageUrlString = profileImageUrlString {
			profileImageUrl = URL(string: profileImageUrlString as String)
		} else {
			profileImageUrl = nil
		}
	}
	
	static var _currentUser: User?
	
	class var currentUser: User? {
		get {
			if _currentUser == nil {
				let defaults = UserDefaults.standard
				if let userData = defaults.object(forKey: "currentUserData") {
					let dictionary = try! JSONSerialization.jsonObject(with: userData as! Data, options: [])
					_currentUser = User(userDictionary: dictionary as! NSDictionary)
				}
			}
			return _currentUser
		}
		set(user) {
			_currentUser = user
			let defaults = UserDefaults.standard
			
			if let user = user {
				let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
				defaults.set(data, forKey: "currentUserData")
			} else {
				defaults.set(nil, forKey: "currentUserData")
			}
			defaults.synchronize()
		}
	}
	
	func printUser() {
		print("name: \(self.name!)")
		print("screenName: \(self.screenName!)")
		print("description \(self.tagLine!)")
		print("profileImageUrl: \(self.profileImageUrl!.absoluteString)")
	}
}
