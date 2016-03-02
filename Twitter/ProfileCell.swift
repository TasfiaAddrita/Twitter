//
//  ProfileCell.swift
//  Twitter
//
//  Created by Tasfia Addrita on 2/28/16.
//  Copyright © 2016 Tasfia Addrita. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    
    var isFavorited = false
    var isRetweeted = false
    
    let retweetTapRec = UITapGestureRecognizer()
    let likeTapRec = UITapGestureRecognizer()
    let profileImageRec = UITapGestureRecognizer()
    
    var tweet: Tweet! {
        didSet {
            
            if (tweet.user?.profileUrl != nil) {
                profileImageView.setImageWithURL((tweet.user?.profileUrl)!)
            } else {
                profileImageView.image = UIImage(named: "blue_logo.png")
            }
            nameLabel.text = tweet.user?.name as? String
            userNameLabel.text = "@\(tweet.user!.screenname!)"
            tweetContentLabel.text = tweet.text as? String
            replyImageView.image = UIImage(named: "reply_button")
            retweetImageView.image = UIImage(named: "retweet_button")
            likeImageView.image = UIImage(named: "like_button")
            timeStampLabel.text = tweet.timeSince
            retweetCountLabel.text = String(tweet.retweetCount)
            likeCountLabel.text = String(tweet.favoriteCount)
            
            if likeCountLabel.text == "0" {
                likeCountLabel.hidden = true
            }
            if retweetCountLabel.text == "0" {
                retweetCountLabel.hidden = true
            }
            
            retweetTapRec.addTarget(self, action: "onRetweet")
            retweetImageView.addGestureRecognizer(retweetTapRec)
            
            likeTapRec.addTarget(self, action: "onLike")
            likeImageView.addGestureRecognizer(likeTapRec)
            
            //profileImageRec.addTarget(self, action: "onProfileImage")
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
            isRetweeted = true
            retweetImageView.image = UIImage(named: "retweet_button_active")
            if retweetCountLabel.text == "0" {
                retweetCountLabel.hidden = false
            }
            retweetCountLabel.text = String(tweet.retweetCount + 1)
        } else {
            isRetweeted = false
            retweetImageView.image = UIImage(named: "retweet_button")
            if retweetCountLabel.text == "1" {
                retweetCountLabel.hidden = true
            }
            retweetCountLabel.text = String(tweet.retweetCount)
        }
    }
    
    func onLike() {
        if !isFavorited {
            isFavorited = true
            likeImageView.image = UIImage(named: "like_button_active")
            if likeCountLabel.text == "0" {
                likeCountLabel.hidden = false
            }
            likeCountLabel.text = String(tweet.favoriteCount + 1)
        } else {
            isFavorited = false
            likeImageView.image = UIImage(named: "like_button")
            if likeCountLabel.text == "1" {
                likeCountLabel.hidden = true
            }
            likeCountLabel.text = String(tweet.favoriteCount)
        }
    }

}
