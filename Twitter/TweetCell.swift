//
//  TweetCell.swift
//  Twitter
//
//  Created by Tasfia Addrita on 2/28/16.
//  Copyright © 2016 Tasfia Addrita. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var timePostedLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var isLiked : Bool = false
    var isRetweeted : Bool = false
    
    let retweetTapRec = UITapGestureRecognizer()
    let likeTapRec = UITapGestureRecognizer()
    let profileImageRec = UITapGestureRecognizer()
    
    var tweet: Tweet! {
        didSet {
            
            isRetweeted = tweet.isRetweeted!
            isLiked = tweet.isLiked!
            
            if (tweet.user?.profileUrl != nil) {
                profileImageView.setImageWithURL((tweet.user?.profileUrl)!)
            } else {
                profileImageView.image = UIImage(named: "blue_logo.png")
            }
            nameLabel.text = tweet.user?.name as? String
            userNameLabel.text = "@\(tweet.user!.screenname!)"
            tweetContentLabel.text = tweet.text as? String
            timePostedLabel.text = tweet.timeSince
            replyImageView.image = UIImage(named: "reply_button")
            
            retweetCountLabel.text = String(tweet.retweetCount)
            likeCountLabel.text = String(tweet.favoriteCount)
            
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
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func onRetweet() {
        
        if !isRetweeted {
            TwitterClient.sharedInstance.retweetTweet(tweet.id) { (tweets, error) -> () in }
            
            isRetweeted = true
            retweetImageView.image = UIImage(named: "retweet_button_active")
            retweetCountLabel.text = String(tweet.retweetCount + 1)
        }
        
        else {
            TwitterClient.sharedInstance.unretweetTweet(tweet.id) { (tweets, error) -> () in }
            
            isRetweeted = false
            retweetImageView.image = UIImage(named: "retweet_button")
            retweetCountLabel.text = String(tweet.retweetCount - 1)
        }
    }
    
    func onLike() {
        
        if !isLiked {
            TwitterClient.sharedInstance.favoriteTweet(tweet.id) { (tweets, error) -> () in }
            
            isLiked = true
            likeImageView.image = UIImage(named: "like_button_active")
            likeCountLabel.text = String(tweet.favoriteCount + 1)
        }
        
        else {
            TwitterClient.sharedInstance.unfavoriteTweet(tweet.id) { (tweets, error) -> () in }
            
            isLiked = false
            likeImageView.image = UIImage(named: "like_button")
            likeCountLabel.text = String(tweet.favoriteCount - 1)
        }
    }
}
