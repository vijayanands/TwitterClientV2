//
//  TweetViewCell.swift
//  TwitterClient
//
//  Created by Vijayanand on 10/8/17.
//  Copyright © 2017 Vijayanand. All rights reserved.
//

import UIKit

class TweetViewCell: UITableViewCell {
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var retweetedLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var screenNameLabel: UILabel!
	@IBOutlet weak var inReplyToLabel: UILabel!
	@IBOutlet weak var tweetTextLabel: UILabel!
	@IBOutlet weak var retweetCountLabel: UILabel!
	@IBOutlet weak var favoriteCountLabel: UILabel!
	@IBOutlet weak var retweetedLabelImage: UIImageView!
	@IBOutlet weak var timestampLabel: UILabel!
	
	var userId: UInt64!
	var screenName: String!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func customInit(tweet: Tweet) {
		userId = tweet.id
		screenName = tweet.user?.screenName as String?
		nameLabel.text = tweet.user?.name as String?
		screenNameLabel.text = tweet.user?.screenName as String?
		Utilities.setImage(forImage: profileImageView, using: (tweet.user?.profileImageUrl!)!)
		tweetTextLabel.text = tweet.text as String?
		favoriteCountLabel.text = String("\(tweet.favoriteCount ?? 0)")
		retweetCountLabel.text = String("\(tweet.retweetCount ?? 0)")
		
		if let retweet_count = tweet.retweetCount {
			if retweet_count > 0 {
				retweetedLabelImage.isHidden = false
				retweetedLabel.isHidden = false
			} else {
				retweetedLabelImage.isHidden = true
				retweetedLabel.isHidden = true
			}
		} else {
			retweetedLabelImage.isHidden = true
			retweetedLabel.isHidden = true
		}
		// set timestamp of tweet
		timestampLabel.text = tweet.createdAt?.timeAgo()
		if tweet.inReplyTo != nil {
			inReplyToLabel.isHidden = false
			inReplyToLabel.text = "in reply to: " + (tweet.inReplyTo! as String)
		} else {
			inReplyToLabel.isHidden = true
		}
		
		if tweet.retweetedBy != nil {
			retweetedLabelImage.isHidden = false
			retweetedLabel.isHidden = false
			retweetedLabel.text = (tweet.retweetedBy! as String) + " retweeted"
		} else {
			retweetedLabel.isHidden = true
			retweetedLabelImage.isHidden = true
		}
	}
	
	
}
