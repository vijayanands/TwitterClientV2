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
	
	var tweetsViewController: UIViewController!
	var mentionsViewController: UIViewController!
	var profilesViewController: UIViewController!
	var accountsViewController: UIViewController!
	
	var viewControllers: [UIViewController] = []
	
	var hamburgerViewController: HamburgerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		menuTableView.delegate = self
		menuTableView.dataSource = self
		
        // Do any additional setup after loading the view.
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		tweetsViewController = storyboard.instantiateViewController(withIdentifier: "TweetsViewController")
		mentionsViewController = storyboard.instantiateViewController(withIdentifier: "MentionsViewController")
		profilesViewController = storyboard.instantiateViewController(withIdentifier: "ProfilesViewController")
		accountsViewController = storyboard.instantiateViewController(withIdentifier: "AccountsViewController")
		
		viewControllers.append(profilesViewController)
		viewControllers.append(tweetsViewController)
		viewControllers.append(mentionsViewController)
		viewControllers.append(accountsViewController)
		
		hamburgerViewController.contentViewController = tweetsViewController
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
		return 4
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
		let menuTitles = ["Profiles", "Timeline", "Mentions", "Accounts"]
		cell.menuTextLabel.text = menuTitles[indexPath.row]
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		hamburgerViewController.contentViewController = viewControllers[indexPath.row]
	}
	
	
}

