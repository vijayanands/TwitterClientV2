//
//  User.swift
//  TwitterClient
//
//  Created by Vijayanand on 9/29/17.
//  Copyright © 2017 Vijayanand. All rights reserved.
//

import UIKit

class User: NSObject {
	let id: UInt64
	let name: NSString?
	let screenName: NSString?
	let profileImageUrl: URL?
	let tagLine: NSString?
	let profileBannerUrl: URL?
	let followingCount: Int?
	let followersCount: Int?
	let tweetsCount: Int?
	
	private var dictionary: NSDictionary?
	static let userDidLogoutNotification = "UserDidLogout"
	
	init(userDictionary:NSDictionary) {
		dictionary = userDictionary
		id = (userDictionary["id"] as? UInt64)!
		name = userDictionary["name"] as? NSString
		screenName = userDictionary["screen_name"] as? NSString
		tagLine = userDictionary["description"] as? NSString
		let profileImageUrlString = userDictionary["profile_image_url"] as? NSString
		if let profileImageUrlString = profileImageUrlString {
			profileImageUrl = URL(string: profileImageUrlString as String)
		} else {
			profileImageUrl = nil
		}
		let profileBannerUrlString = userDictionary["profile_banner_url"] as? NSString
		if let profileBannerUrlString = profileBannerUrlString {
			profileBannerUrl = URL(string: profileBannerUrlString as String)
		} else {
			profileBannerUrl = nil
		}
		followersCount = userDictionary["followers_count"] as? Int
		followingCount = userDictionary["friends_count"] as? Int
		tweetsCount = userDictionary["statuses_count"] as? Int
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
		print("id: \(id)")
		print("name: \(self.name!)")
		print("screenName: \(self.screenName!)")
		print("profileImageUrl: \(self.profileImageUrl!.absoluteString)")
		print("description \(self.tagLine!)")
		if let profileBannerUrl = profileBannerUrl {
			print("profileBannerUrl: \(profileBannerUrl.absoluteString)")
		} else {
			print("profileBannerUrl: ")
		}
		print("followingCount: \(followingCount ?? 0)")
		print("followersCount: \(followersCount ?? 0)")
		print("tweetsCount: \(tweetsCount ?? 0)")
	}
}
