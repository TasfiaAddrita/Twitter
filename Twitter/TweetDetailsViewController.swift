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
    
    var isFavorited = false
    var isRetweeted = false
    
    let retweetTapRec = UITapGestureRecognizer()
    let likeTapRec = UITapGestureRecognizer()
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onRetweet() {
        if !isRetweeted {
            isRetweeted = true
            retweetImageView.image = UIImage(named: "retweet_button_active")
            retweetCountLabel.text = "\(tweet!.retweetCount + 1) RETWEETS"
        } else {
            isRetweeted = false
            retweetImageView.image = UIImage(named: "retweet_button")
            retweetCountLabel.text = "\(tweet!.retweetCount) RETWEETS"
        }
    }
    
    func onLike() {
        if !isFavorited {
            isFavorited = true
            likeImageView.image = UIImage(named: "like_button_active")
            likeCountLabel.text = "\(tweet!.favoriteCount + 1) LIKES"
        } else {
            isFavorited = false
            likeImageView.image = UIImage(named: "like_button")
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
