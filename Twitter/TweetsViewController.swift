//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Tasfia Addrita on 2/28/16.
//  Copyright © 2016 Tasfia Addrita. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    var offset: Int? = 20
    var tweetIdLast: Int!
    
    var apiParameters : [String: Int] {
        get {
            return ["max_id": tweetIdLast, "count": offset!]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        let image: UIImage = UIImage(named: "logo_smaller.png")!
        self.navigationItem.titleView = UIImageView(image: image)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        TwitterClient.sharedInstance.homeTimeline(nil, success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tweetIdLast = self.tweets[self.tweets.count - 1].id!
            self.tableView.reloadData()
            
            for tweet in tweets {
                print(tweet.text)
            }
            }) { (error: NSError) -> () in
                print("error: \(error.localizedDescription)")
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        cell.selectionStyle = .None
        cell.tweet = tweets[indexPath.row]
        //tweetIdLast = tweets[indexPath.row].id!
        
        print(indexPath.row)
        return cell
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimeline(nil, success: { (tweet: [Tweet]) -> () in
            self.tweets = tweet
            self.tableView.reloadData()
            refreshControl.endRefreshing()
            }) { (error: NSError) -> () in
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // Code to load more results
                loadData()
            }
        }
    }

    func loadData() {
        TwitterClient.sharedInstance.getOlderTweets(self.tweetIdLast, success: { (success: [Tweet]) -> () in
            
            for tweet in success {
                self.tweets.append(tweet)
            }
            
            self.isMoreDataLoading = false
            self.tableView.reloadData()
            }) { (error: NSError) -> () in
                print(error.description)
        }
    }
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "viewTweetDetails" {
            
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            
            let tweetDetailsViewController = segue.destinationViewController as! TweetDetailsViewController
            tweetDetailsViewController.tweet = tweet
        }
        
        if segue.identifier == "viewUserProfile" {
            
            let profPic = sender as! UIButton
            let cell = profPic.superview!.superview as! UITableViewCell
            
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![(indexPath?.row)!]
            
            let profileViewController = segue.destinationViewController as? ProfileViewController
            profileViewController!.tweet = tweet
        }
    }
}
