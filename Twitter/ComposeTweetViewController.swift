//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by Tasfia Addrita on 2/28/16.
//  Copyright © 2016 Tasfia Addrita. All rights reserved.
//

import UIKit

@objc protocol ComposeViewControllerDelegate {
    optional func composeViewController(composeViewController: ComposeTweetViewController)
}

class ComposeTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var charCountItem: UIBarButtonItem!
    @IBOutlet weak var tweetTextView: UITextView!
    
    let onEditTextField = UITapGestureRecognizer()
    let onEndEditing = UITapGestureRecognizer()
    
    var replyID : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTextView.delegate = self

        profileImageView.setImageWithURL((User.currentUser?.profileUrl)!)
        nameLabel.text = (User.currentUser?.name as! String)
        userNameLabel.text = "@\(User.currentUser?.screenname as! String)"
        
        //profileImageView.layer.cornerRadius = 5
        //profileImageView.clipsToBounds = true
        
        tweetTextView.text = "What's Happening?"
        tweetTextView.textColor = UIColor.lightGrayColor()
        
        onEditTextField.addTarget(self, action: "textViewDidBeginEditing")
        tweetTextView.addGestureRecognizer(onEditTextField)
        
        onEndEditing.addTarget(self, action: "textViewDidEndEditing")
        self.view.addGestureRecognizer(onEndEditing)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let maxLength = 140
        let currentString: NSString = tweetTextView.text!
        let newString: NSString =
        currentString.stringByReplacingCharactersInRange(range, withString: text)
        
        charCountItem.title = "\(140 - newString.length)"
        
        return newString.length < maxLength
    }
    
    func textViewDidBeginEditing() {
        if tweetTextView.textColor == UIColor.lightGrayColor() {
            tweetTextView.becomeFirstResponder()
            tweetTextView.text = nil
            tweetTextView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing() {
        self.view.endEditing(true)
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        
        var tweetStatus =  "?status=" + tweetTextView.text!.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        /*if (replyID != nil) {
            tweetStatus += "&in_reply_to_status_id=\(replyID!)"
        }*/
        
        TwitterClient.sharedInstance.postTweet(tweetStatus)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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
