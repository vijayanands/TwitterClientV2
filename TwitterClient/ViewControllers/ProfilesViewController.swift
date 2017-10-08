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
	@IBOutlet weak var tweetsTable: UITableView!

	var tweets: [Tweet]!
	var isMoreDataLoading = false
	
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
			loadTweets()
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		tweetsTable.delegate = self
		tweetsTable.dataSource = self
		tweetsTable.estimatedRowHeight = 130
		tweetsTable.rowHeight = UITableViewAutomaticDimension
		let nibName = UINib(nibName: "TweetViewCell", bundle: nil)
		tweetsTable.register(nibName, forCellReuseIdentifier: "TweetViewCell")
		
		
		// Initialize a UIRefreshControl
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
		// add refresh control to table view
		tweetsTable.insertSubview(refreshControl, at: 0)
		
		// set title in navigation bar
		self.navigationController?.navigationBar.topItem?.title = user.name! as String + "'s Profile"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
		// ... Create the URLRequest `myRequest` ...
		loadTweets()
		// Tell the refreshControl to stop spinning
		refreshControl.endRefreshing()
	}
	
	func loadTweets() {
		if user != nil {
			TwitterClient.sharedInstance?.userTimeline(id: user.id, since: nil, success: { (tweets: [Tweet]) in
				self.tweets = tweets
				for tweet in self.tweets {
					tweet.printTweet()
				}
				self.tweetsTable.reloadData()
			}, failure: { (error:NSError) in
				print("error: \(error.localizedDescription)")
			})
		}
	}
	
	func incrementallyLoadTweets() {
		TwitterClient.sharedInstance?.userTimeline(id: user.id, since: tweets[0].id, success: { (tweets: [Tweet]) in
			let currentSize = self.tweets.count
			self.tweets = self.tweets + tweets
			for tweet in self.tweets {
				tweet.printTweet()
			}
			self.tweetsTable.reloadData()
			let indexPath = IndexPath(row: currentSize, section: 0)
			self.tweetsTable.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
		}, failure: { (error: NSError) in
			print("error: \(error.localizedDescription)")
		})
		// Update flag
		isMoreDataLoading = false
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

extension ProfilesViewController : UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tweets != nil {
			return tweets.count
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tweetsTable.dequeueReusableCell(withIdentifier: "TweetViewCell", for: indexPath) as! TweetViewCell
		cell.customInit(tweet: tweets[indexPath.row])
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tweetsTable.deselectRow(at: indexPath, animated: true)
	}
}

extension ProfilesViewController : UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		// Calculate the position of one screen length before the bottom of the results
		let scrollViewContentHeight = tweetsTable.contentSize.height
		let tableViewBounds = tweetsTable.bounds.size.height
		let scrollOffsetThreshold = scrollViewContentHeight - tableViewBounds
		
		// When the user has scrolled past the threshold, start requesting
		let currentOffset = scrollView.contentOffset.y
		if(currentOffset > scrollOffsetThreshold && tweetsTable.isDragging) {
			isMoreDataLoading = true
			
			// Code to load more results
			incrementallyLoadTweets()
		}
	}
}

