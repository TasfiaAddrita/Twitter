//
//  CurrentUserViewController.swift
//  Twitter
//
//  Created by Tasfia Addrita on 3/2/16.
//  Copyright © 2016 Tasfia Addrita. All rights reserved.
//

import UIKit

class CurrentUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        navigationController?.navigationBar.topItem?.title = "@\(User.currentUser!.screenname!)"
        
        bannerImageView.setImageWithURL((User.currentUser?.profileBannerURL)!)
        profileImageView.setImageWithURL((User.currentUser?.profileUrl)!)
        nameLabel.text = (User.currentUser?.name as! String)
        userNameLabel.text = "@\(User.currentUser?.screenname as! String)"
        descriptionLabel.text = (User.currentUser!.userDescription as! String)
        followingCountLabel.text = "\(User.currentUser!.followingCount!) FOLLOWING"
        followerCountLabel.text = "\(User.currentUser!.followerCount!) FOLLOWERS"
        
        profileImageView.layer.cornerRadius = 10.0
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profileImageView.layer.borderWidth = 3.0
        profileImageView.clipsToBounds = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        TwitterClient.sharedInstance.userTimelineWithParams(nil , completion: { (tweets,error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CurrentUserProfileCell", forIndexPath: indexPath) as! CurrentUserProfileCell
        
        cell.selectionStyle = .None
        cell.tweet = tweets![indexPath.row]
        
        print(indexPath.row)
        return cell
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.userTimelineWithParams(nil , completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
