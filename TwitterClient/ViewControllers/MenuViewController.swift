//
//  MenuViewController.swift
//  TwitterClient
//
//  Created by Vijayanand on 10/5/17.
//  Copyright © 2017 Vijayanand. All rights reserved.
//

import UIKit

fileprivate enum ArrayIndexFor {
	static let profilesViewControler = 0
	static let tweetsViewController = 1
	static let mentionsViewController = 2
	static let accountsViewController = 3
}

class MenuViewController: UIViewController {
	
	@IBOutlet weak var menuTableView: UITableView!
	
	var tweetsNavigationController: UIViewController!
	var mentionsNavigationController: UIViewController!
	var profilesNavigationController: UIViewController!
	var accountsNavigationController: UIViewController!
	
	var viewControllers: [UIViewController] = []
	
	var hamburgerViewController: HamburgerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		menuTableView.delegate = self
		menuTableView.dataSource = self
		menuTableView.tableFooterView = UIView()
		
        // Do any additional setup after loading the view.
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		tweetsNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
		mentionsNavigationController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController")
		profilesNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfilesNavigationController")
		accountsNavigationController = storyboard.instantiateViewController(withIdentifier: "AccountsNavigationController")
		
		viewControllers.append(profilesNavigationController)
		viewControllers.append(tweetsNavigationController)
		viewControllers.append(mentionsNavigationController)
		viewControllers.append(accountsNavigationController)
		
		let tweetsViewController = (tweetsNavigationController as! UINavigationController).topViewController as! TweetsViewController
		tweetsViewController.hamburgerViewController = hamburgerViewController
		hamburgerViewController.contentViewController = tweetsNavigationController
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

extension MenuViewController : UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.viewControllers.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
		let menuTitles = ["Profiles", "Timeline", "Mentions", "Accounts"]
		cell.menuTextLabel.text = menuTitles[indexPath.row]
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		if indexPath.row == 0 {
			let profilesViewNavigationController = viewControllers[indexPath.row] as! UINavigationController
			let profilesViewController = profilesViewNavigationController.topViewController as! ProfilesViewController
			let user = User.currentUser
			user?.printUser()
			profilesViewController.user = User.currentUser
		} else if indexPath.row == 1 {
			let tweetsNavigationController = viewControllers[indexPath.row] as! UINavigationController
			let tweetsViewController = tweetsNavigationController.topViewController as! TweetsViewController
			tweetsViewController.hamburgerViewController = hamburgerViewController
		} else if indexPath.row == 2 {
		} else if indexPath.row == 3 {
		}
		hamburgerViewController.contentViewController = viewControllers[indexPath.row]
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		let MinHeight: CGFloat = 100.0
		let tHeight = tableView.bounds.height
		let temp = tHeight/CGFloat(self.viewControllers.count)
		
		return temp > MinHeight ? temp : MinHeight
	}
}

