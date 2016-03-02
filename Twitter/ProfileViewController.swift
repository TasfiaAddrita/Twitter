//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Tasfia Addrita on 2/28/16.
//  Copyright © 2016 Tasfia Addrita. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerImageView.setImageWithURL((tweet?.user?.profileBannerURL)!)
        
//        if (tweet!.user?.profileUrl != nil) {
//            profileImageView.setImageWithURL((tweet!.user!.profileUrl)!)
//        } else {
//            profileImageView.image = UIImage(named: "blue_logo.png")
//        }
        
        profileImageView.setImageWithURL(tweet!.user!.profileUrl!)
        nameLabel.text = (tweet?.user?.name as! String)
        usernameLabel.text = "@\(tweet!.user?.screenname as! String)"
        
        if (tweet?.user?.userDescription != nil) {
            descriptionLabel.text = (tweet?.user?.userDescription as! String)
        }
        else {
            descriptionLabel.hidden = true
        }
        
        followingCountLabel.text = "\(tweet!.user!.followingCount!) FOLLOWING"
        followerCountLabel.text = "\(tweet!.user!.followerCount!) FOLLOWERS"
        
        profileImageView.layer.cornerRadius = 10.0
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profileImageView.layer.borderWidth = 3.0
        profileImageView.clipsToBounds = true
        
        /*TwitterClient.sharedInstance.userTimelineWithParams(nil , completion: { (tweets,error) -> () in
            
            if let tweets = tweets {
                self.tweets = tweets
                self.tableView.reloadData()
            }
        })*/
        
        /*TwitterClient.sharedInstance.homeTimeline(nil, success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            
            for tweet in tweets {
                print(tweet.text)
            }
            }) { (error: NSError) -> () in
                print("error: \(error.localizedDescription)")
        }*/
        
        /*TwitterClient.sharedInstance.userTimelineWith(tweet!.user!.screenname as String!, params: nil, completion: { (tweets: [Tweet]?, error: NSError?) in
                if let tweets = tweets {
                    self.tweets = tweets
                    //self.tableView.reloadData()
                }
            }
        )*/
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! ProfileCell
        
        cell.selectionStyle = .None
        cell.tweet = tweets![indexPath.row]
        
        print(indexPath.row)
        return cell
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
