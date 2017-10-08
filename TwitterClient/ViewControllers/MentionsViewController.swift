//
//  MentionsViewController.swift
//  TwitterClient
//
//  Created by Vijayanand on 10/5/17.
//  Copyright © 2017 Vijayanand. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController {
	@IBOutlet weak var tweetsTable: UITableView!

	var tweets: [Tweet]!
	var isMoreDataLoading = false
	
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
		
        // Do any additional setup after loading the view.
		self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.28, green: 0.75, blue: 1.0, alpha: 1.0)
		// set title in navigation bar
		let user = User.currentUser!
		self.navigationController?.navigationBar.topItem?.title = user.name! as String + "'s Mentions"

		loadTweets()
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
		TwitterClient.sharedInstance?.mentionsTimeline(since: nil, success: { (tweets: [Tweet]) in
			self.tweets = tweets
			for tweet in self.tweets {
				tweet.printTweet()
			}
			self.tweetsTable.reloadData()
		}, failure: { (error: NSError) in
			print("error: \(error.localizedDescription)")
		})
	}
	
	func incrementallyLoadTweets() {
		TwitterClient.sharedInstance?.mentionsTimeline(since: tweets[0].id, success: { (tweets: [Tweet]) in
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

extension MentionsViewController : UITableViewDelegate, UITableViewDataSource {
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

extension MentionsViewController : UIScrollViewDelegate {
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


