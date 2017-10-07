//
//  ProfilesViewController.swift
//  
//
//  Created by Vijayanand on 10/5/17.
//

import UIKit

class ProfilesViewController: UIViewController {
	
	@IBOutlet weak var profileBannerImage: UIImageView!
	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var screennameLabel: UILabel!
	@IBOutlet weak var tweetCountLabel: UILabel!
	@IBOutlet weak var followingCountLabel: UILabel!
	@IBOutlet weak var followersCountLabel: UILabel!
	
	var user: User! {
		didSet {
			view.layoutIfNeeded()
			
			user.printUser()
			nameLabel.text = user.name as String?
			screennameLabel.text = "@" + (user.screenName as String?)!
			if let profileImageUrl = user.profileImageUrl {
				Utilities.setImage(forImage: profileImage, using: profileImageUrl)
			}
			if let profileBannerUrl = user.profileBannerUrl {
				Utilities.setImage(forImage: profileBannerImage, using: profileBannerUrl)
			}
			if let followersCount = user.followersCount {
				followersCountLabel.text = "\(followersCount)"
			} else {
				followersCountLabel.text = "0"
			}
			if let followingCount = user.followingCount {
				followingCountLabel.text = "\(followingCount)"
			} else {
				followersCountLabel.text = "0"
			}
			if let tweetCount = user.tweetsCount {
				tweetCountLabel.text = "\(tweetCount)"
			} else {
				tweetCountLabel.text = "0"
			}
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
