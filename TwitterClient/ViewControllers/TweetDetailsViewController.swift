//
//  TweetDetailsViewController.swift
//  TwitterClient
//
//  Created by Vijayanand on 9/30/17.
//  Copyright © 2017 Vijayanand. All rights reserved.
//

import UIKit

@objc protocol TweetDetailsViewControllerDelegate {
	@objc optional func tweetDetailsViewController(tweetDetailsViewController: TweetDetailsViewController,
	                                           didUpdateStatus value: Bool)
}

class TweetDetailsViewController: UIViewController {

	@IBOutlet weak var favoritesCountLabel: UILabel!
	@IBOutlet weak var retweetCountLabel: UILabel!
	@IBOutlet weak var timestampLabel: UILabel!
	@IBOutlet weak var tweetTextLabel: UILabel!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var buttonBackgroundView: UIView!
	
	weak var delegate: TweetDetailsViewControllerDelegate?
	
	var tweet: Tweet?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0.7569, blue: 0.8588, alpha: 1.0)

        // Do any additional setup after loading the view.
		setTweetDetail()
		
		// setup buttons
		let replyButton = createButtonWithImage(imageName: "replybutton.png", x: 60, y: 5, width: 40, height: 40, borderWidth: 1, cornerRadius: 6, backgroundColor: UIColor(red: 0, green: 0.7569, blue: 0.8588, alpha: 1.0))
		replyButton.addTarget(self, action: #selector(replyButtonTouched), for: UIControlEvents.touchUpInside)
		self.buttonBackgroundView.addSubview(replyButton)

		let retweetButton = createButtonWithImage(imageName: "retweetbutton.png", x: 160, y: 5, width: 40, height: 40, borderWidth: 1, cornerRadius: 6, backgroundColor: UIColor(red: 0, green: 0.7569, blue: 0.8588, alpha: 1.0))
		retweetButton.addTarget(self, action: #selector(retweetButtonTouched), for: UIControlEvents.touchUpInside)
		self.buttonBackgroundView.addSubview(retweetButton)

		let likeButton = createButtonWithImage(imageName: "favoritebutton.png", x: 260, y: 5, width: 40, height: 40, borderWidth: 1, cornerRadius: 6, backgroundColor: UIColor(red: 0, green: 0.7569, blue: 0.8588, alpha: 1.0))
		likeButton.addTarget(self, action: #selector(likeButtonTouched), for: UIControlEvents.touchUpInside)
		self.buttonBackgroundView.addSubview(likeButton)
		
		buttonBackgroundView.layer.borderWidth = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	private func createButtonWithImage(imageName: String, x: Int, y: Int, width: Int, height: Int, borderWidth: Int?, cornerRadius: Int?, backgroundColor: UIColor?) -> UIButton {
		let button = UIButton(type: UIButtonType.custom)
		let image = UIImage(named: imageName)
		button.frame = CGRect(x: x, y: y, width: width, height: height)
		button.setImage(image, for: UIControlState.normal)
		if let borderWidth = borderWidth {
			button.layer.borderWidth = CGFloat(borderWidth)
		}
		if let cornerRadius = cornerRadius {
			button.layer.cornerRadius = CGFloat(cornerRadius)
		}
		if let backgroundColor = backgroundColor {
			button.layer.backgroundColor = backgroundColor.cgColor
		}
		return button
	}
	
	@objc func replyButtonTouched() {
		print("reply button touched")
		// reply tweet
		performSegue(withIdentifier: "ReplyTweetSegue", sender: nil)
	}
	
	@objc func likeButtonTouched() {
		print("like button touched")
		// favorite tweet
		TwitterClient.sharedInstance?.favoriteTweet(id: (tweet?.id)!, success: {
			self.delegate?.tweetDetailsViewController!(tweetDetailsViewController: self, didUpdateStatus: true)
		}, failure: { (error: NSError) in
			print("error: \(error.localizedDescription)")
		})
		dismiss(animated: true, completion: nil)
	}
	
	@objc func retweetButtonTouched() {
		print("retweet button touched")
		// retweet
		TwitterClient.sharedInstance?.retweet(id: (tweet?.id)!, success: { () in
			print("Retweet Successful")
			self.delegate?.tweetDetailsViewController!(tweetDetailsViewController: self, didUpdateStatus: true)
		}, failure: { (error: NSError) in
			print("error: \(error.localizedDescription)")
		})
		dismiss(animated: true, completion: nil)
	}
	
	func setTweetDetail() {
		if let profileUrl = tweet?.user?.profileImageUrl {
			Utilities.setImage(forImage: profileImage, using: profileUrl)
		}
		nameLabel.text = tweet?.user?.name as String?
		usernameLabel.text = tweet?.user?.screenName! as String?
		tweetTextLabel.text = tweet?.text! as String?
		timestampLabel.text = tweet?.timestampString! as String?
		retweetCountLabel.text = String("\(tweet?.retweetCount ?? 0)")
		favoritesCountLabel.text = String("\(tweet?.favoriteCount ?? 0)")
	}

	@IBAction func homeButtonSelected(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		let navigationController = segue.destination as! UINavigationController
		let destinationViewController = navigationController.topViewController as! NewTweetViewController
		destinationViewController.customInit(delegate: self)
		destinationViewController.replyMode = true
		destinationViewController.replyTo = tweet?.id
    }

}

extension TweetDetailsViewController: NewTweetViewControllerDelegate {
	func newTweetViewController(newTweetViewController: NewTweetViewController, didUpdateStatus: Bool, tweet: Tweet) {
		print("In New Tweet Delegate")
		if didUpdateStatus == true {
			print("Updating Tweets")
			self.delegate?.tweetDetailsViewController!(tweetDetailsViewController: self, didUpdateStatus: true)
			dismiss(animated: true, completion: nil)
		} else {
			print("Unable to Update Tweet")
		}
	}
}

