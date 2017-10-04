//
//  Tweet.swift
//  TwitterClient
//
//  Created by Vijayanand on 9/29/17.
//  Copyright © 2017 Vijayanand. All rights reserved.
//

import UIKit

class Tweet: NSObject {
	let id: UInt64
	var text: NSString?
	let favoriteCount: Int?
	let retweetCount: Int?
	var createdAt: NSDate?
	var timestampString : NSString?
	var user: User?
	let inReplyTo: NSString?
	var retweetedBy: NSString?
	
	init(tweetDictionary: NSDictionary) {
		id = (tweetDictionary["id"] as? UInt64)!
		text = tweetDictionary["text"] as? NSString
		favoriteCount = (tweetDictionary["favorite_count"] as? Int) ?? 0
		retweetCount = (tweetDictionary["retweet_count"] as? Int) ?? 0
		timestampString = tweetDictionary["created_at"] as? NSString
		
		if let timestampString = timestampString {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
			createdAt = (dateFormatter.date(from: timestampString as String) as NSDate?) ?? nil
		}
		
		if let replyToUser = tweetDictionary["in_reply_to_screen_name"] {
			inReplyTo = replyToUser as? NSString
		} else {
			inReplyTo = nil
		}
		
		let retweeted_status = tweetDictionary["retweeted_status"]
		if retweeted_status != nil {
			// Create a CharacterSet of delimiters.
			var parts = text?.components(separatedBy: ": ")
			
			var newText: String = ""
			var count:Int = (parts?.count)!
			if count > 1 {
				for i in 1..<count {
					newText = newText + parts![i]
				}
			}
			text = newText as NSString
			let tempStr = parts?[0] as NSString?
			parts = tempStr?.components(separatedBy: " ")
			count = (parts?.count)!
			if count > 1 {
				retweetedBy = parts?[1] as NSString?
			}
		}
		
		// initialize user
		let userDictionary = tweetDictionary["user"]
		user = User(userDictionary: userDictionary as! NSDictionary)
	}
	
	class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
		var tweets = [Tweet]()
	
		for dictionary in dictionaries {
			let tweet = Tweet(tweetDictionary: dictionary)
			tweets.append(tweet)
		}
		return tweets
	}
	
	func printTweet() {
		print("Id: \(id)")
		print("Text: \(text!)")
		print("Created at: \(createdAt!)")
		print("Retweet Count: \(retweetCount!)")
		print("Favorite Count: \(favoriteCount!)")
		print("In Reply To: \(retweetedBy)")
	}
}
