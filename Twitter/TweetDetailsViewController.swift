//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Tasfia Addrita on 2/28/16.
//  Copyright © 2016 Tasfia Addrita. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    
    var isLiked : Bool = false
    var isRetweeted : Bool = false
    
    let retweetTapRec = UITapGestureRecognizer()
    let likeTapRec = UITapGestureRecognizer()
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isRetweeted = tweet!.isRetweeted!
        isLiked = tweet!.isLiked!
        
        profileImageView.setImageWithURL((tweet!.user?.profileUrl)!)
        nameLabel.text = (tweet?.user?.name as! String)
        userNameLabel.text = "@\(tweet?.user?.screenname as! String)"
        tweetContentLabel.text = (tweet?.text as! String)
        timeStampLabel.text = tweet?.timeSince
        retweetCountLabel.text = "\(tweet!.retweetCount) RETWEETS"
        likeCountLabel.text = "\(tweet!.favoriteCount) LIKES"
        replyImageView.image = UIImage(named: "reply_button")
        retweetImageView.image = UIImage(named: "retweet_button")
        likeImageView.image = UIImage(named: "like_button")
        
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        
        if isRetweeted {
            retweetImageView.image = UIImage(named: "retweet_button_active")
        }
        else {
            retweetImageView.image = UIImage(named: "retweet_button")
        }
        
        if isLiked {
            likeImageView.image = UIImage(named: "like_button_active")
        }
        else {
            likeImageView.image = UIImage(named: "like_button")
        }
        
        retweetTapRec.addTarget(self, action: "onRetweet")
        retweetImageView.addGestureRecognizer(retweetTapRec)
        
        likeTapRec.addTarget(self, action: "onLike")
        likeImageView.addGestureRecognizer(likeTapRec)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onRetweet() {
        
        if !isRetweeted {
            TwitterClient.sharedInstance.retweetTweet(tweet!.id) { (tweets, error) -> () in }
            
            isRetweeted = true
            retweetImageView.image = UIImage(named: "retweet_button_active")
            //retweetCountLabel.text = String(tweet!.retweetCount + 1)
            retweetCountLabel.text = "\(tweet!.retweetCount + 1) RETWEETS"
        }
            
        else {
            TwitterClient.sharedInstance.unretweetTweet(tweet!.id) { (tweets, error) -> () in }
            
            isRetweeted = false
            retweetImageView.image = UIImage(named: "retweet_button")
            //retweetCountLabel.text = String(tweet!.retweetCount)
            retweetCountLabel.text = "\(tweet!.retweetCount) RETWEETS"
        }
    }
    
    func onLike() {
        
        if !isLiked {
            TwitterClient.sharedInstance.favoriteTweet(tweet!.id) { (tweets, error) -> () in }
            
            isLiked = true
            likeImageView.image = UIImage(named: "like_button_active")
            //likeCountLabel.text = String(tweet!.favoriteCount + 1)
            likeCountLabel.text = "\(tweet!.favoriteCount + 1) LIKES"
        }
            
        else {
            TwitterClient.sharedInstance.unfavoriteTweet(tweet!.id) { (tweets, error) -> () in }
            
            isLiked = false
            likeImageView.image = UIImage(named: "like_button")
            //likeCountLabel.text = String(tweet!.favoriteCount)
            likeCountLabel.text = "\(tweet!.favoriteCount) LIKES"
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let profileViewController = segue.destinationViewController as! ProfileViewController
        profileViewController.tweet = tweet
    }
}
