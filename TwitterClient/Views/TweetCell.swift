//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Vijayanand on 9/29/17.
//  Copyright © 2017 Vijayanand. All rights reserved.
//

import UIKit
import AFNetworking
import NSDateMinimalTimeAgo

class TweetCell: UITableViewCell {
	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var starImage: UIImageView!
	@IBOutlet weak var retweetImage2: UIImageView!
	@IBOutlet weak var retweetImage1: UIImageView!
	@IBOutlet weak var retweetInfoLabel: UILabel!
	@IBOutlet weak var tweetTextLabel: UILabel!
	@IBOutlet weak var timestampLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var inReplyToUser: UILabel!
	@IBOutlet weak var inReplyToLabel: UILabel!
	@IBOutlet weak var retweetCount: UILabel!
	@IBOutlet weak var favoritesCount: UILabel!
	
	func customInit(tweet: Tweet) {
		nameLabel.text = tweet.user?.name as String?
		usernameLabel.text = tweet.user?.screenName as String?
		Utilities.setImage(forImage: profileImage, using: (tweet.user?.profileImageUrl!)!)
		tweetTextLabel.text = tweet.text as String?
		starImage.image = UIImage(named: "star.png")
		favoritesCount.text = String("\(tweet.favoriteCount ?? 0)")
		retweetImage1.image = UIImage(named: "retweet.png")
		retweetImage2.image = UIImage(named: "retweet.png")
		retweetCount.text = String("\(tweet.retweetCount ?? 0)")

		if let retweet_count = tweet.retweetCount {
			if retweet_count > 0 {
				retweetImage1.isHidden = false
				retweetInfoLabel.isHidden = false
			} else {
				retweetImage1.isHidden = true
				retweetInfoLabel.isHidden = true
			}
		} else {
			retweetImage1.isHidden = true
			retweetInfoLabel.isHidden = true
		}
		// set timestamp of tweet
		timestampLabel.text = tweet.createdAt?.timeAgo()
		if tweet.inReplyTo != nil {
			inReplyToUser.isHidden = false
			inReplyToLabel.isHidden = false
			inReplyToUser.text = tweet.inReplyTo! as String
		} else {
			inReplyToUser.isHidden = true
			inReplyToLabel.isHidden = true
		}
		
		if tweet.retweetedBy != nil {
			retweetInfoLabel.isHidden = false
			retweetImage1.isHidden = false
			retweetInfoLabel.text = (tweet.retweetedBy! as String) + " retweeted"
		} else {
			retweetInfoLabel.isHidden = true
			retweetImage1.isHidden = true
		}
	}
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
