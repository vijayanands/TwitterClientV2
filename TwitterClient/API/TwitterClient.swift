//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Vijayanand on 9/27/17.
//  Copyright © 2017 Vijayanand. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

private let twitterApiUrl = "https://api.twitter.com"
private let consumerApiKey = "elk9OGzs1ZoJWOPvf3khYPFot"
private let consumerSharedSecret = "KK4sBiglaZhkmWCn8VnhprOdCzWNbGtEh8xYj00SZhcHF4z2GC"

class TwitterClient: BDBOAuth1SessionManager {
	static let sharedInstance = TwitterClient(baseURL: URL(string: twitterApiUrl), consumerKey: consumerApiKey, consumerSecret: consumerSharedSecret)
	var loginSuccess: (()->())?
	var loginFailure: ((NSError)->())?

	func login(success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
		loginSuccess = success
		loginFailure = failure
		
		deauthorize()
		fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterClient://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
			print("I got OAuth Token")

			let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")!
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}) { (error: Error!) in
			print("error: \(error.localizedDescription)")
			self.loginFailure?(error! as NSError)
		}
	}
	
	func logout() {
		let defaults = UserDefaults.standard
		defaults.removeObject(forKey: "currentUserData")
		
		User._currentUser = nil
		deauthorize()

		NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
	}
	
	func handleOpenUrl(url: URL) {
		let requestToken = BDBOAuth1Credential(queryString: url.query)
		fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (token: BDBOAuth1Credential!) in
			print("I got access token")
			self.currentAccount(success: { (user: User) in
				User.currentUser = user
				self.loginSuccess?()
			}, failure: { (error: NSError) in
				print("error: \(error.localizedDescription)")
				self.loginFailure?(error)
			})
		}) { (error: Error!) in
			print("error: \(error!.localizedDescription)")
			self.loginFailure?(error! as NSError)
		}
	}
	
	func homeTimeline(since: UInt64?, success: @escaping (([Tweet]) -> Void), failure: @escaping ((NSError) -> Void)) {
		var params = [String:Any?]()
		params["count"] = 20
		params["exclude_replies"] = false
		if (since != nil) {
			params["since"] = since
		}
		
		get("1.1/statuses/home_timeline.json", parameters: params, success:{ (task: URLSessionDataTask, response: Any?) in
			let dictionaries = response as! [NSDictionary]
			let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
			success(tweets)
		}, failure: { (task: URLSessionDataTask?, error: Error) in
			failure(error as NSError)
		} as (URLSessionDataTask?, Error) -> Void)
	}
	
	func retweet(id: UInt64, success: @escaping (() -> Void), failure: @escaping ((NSError) -> Void)){
		post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
			print("successfully retweeted")
			success()
		}) { (task: URLSessionDataTask?, error: Error) in
			print("error: \(error.localizedDescription)")
			failure(error as NSError)
		}
	}
	
	func favoriteTweet(id: UInt64, success: @escaping (() -> Void), failure: @escaping ((NSError) -> Void)){
		var params = [String:Any?]()
		params["id"] = id
		post("1.1/favorites/create.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
			print("successfully favorited")
			success()
		}) { (task: URLSessionDataTask?, error: Error) in
			print("error: \(error.localizedDescription)")
			failure(error as NSError)
		}
	}
	
	func submitTweet(status: String, inReply: Bool, replyTo: UInt64?, success: @escaping ((NSDictionary) -> Void), failure: @escaping ((NSError) -> Void)) {
		var params = [String:Any?]()
		params["status"] = status
		if inReply != false {
			params["in_reply_to_status_id"] = replyTo!
			if let screenNameString = User.currentUser?.screenName {
				let replyFromString = "@" + (screenNameString as String) + ": "
				params["status"] = replyFromString + status
			}
		}
		
		post("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
			print("successfully posted")
			success(response as! NSDictionary)
		}) { (task: URLSessionDataTask?, error: Error) in
			print("error posting: \(error.localizedDescription)")
			failure(error as NSError)
		}
	}
	
	func currentAccount(success: @escaping ((User) -> ()), failure: @escaping ((NSError) -> ())) {
		get("1.1/account/verify_credentials.json", parameters: nil, success: { (task: URLSessionDataTask, response: Any?) in
			let accountInfo = response as! NSDictionary
			let user = User(userDictionary: accountInfo)
			success(user)
		}, failure: { (task: URLSessionDataTask?, error: Error) in
			failure(error as NSError)
		})
	}
	
}
