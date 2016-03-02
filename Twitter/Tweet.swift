//
//  Tweet.swift
//  Twitter
//
//  Created by Tasfia Addrita on 2/28/16.
//  Copyright © 2016 Tasfia Addrita. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var user: User?
    var text: NSString?
    var timeStamp: NSDate
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var timePassed: Int?
    var timeSince: String!
    var id: Int?
    var isRetweeted: Bool?
    var isLiked: Bool?
    
    var retweetedBy: String?
    var wasRetweeted: Bool?
    
    //var idString: String?
    
    init(dictionary: NSDictionary) {
        
        /*user = User(dictionary: dictionary["user"] as! NSDictionary)
        
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        id = dictionary["id"] as? Int
        
        isRetweeted = dictionary["retweeted"] as? Bool
        isLiked = dictionary["favorited"] as? Bool
        
        let timeStampString = dictionary["created_at"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        timeStamp = formatter.dateFromString(timeStampString!)!
        
        let now = NSDate()
        let then = timeStamp
        timePassed = Int(now.timeIntervalSinceDate(then))
        
        // creds for this function go to @dylan-james-smith from ccsf
        if timePassed >= 86400 {
            timeSince = String(timePassed! / 86400)+"d"
        }
        if (3600..<86400).contains(timePassed!) {
            timeSince = String(timePassed!/3600)+"h"
        }
        if (60..<3600).contains(timePassed!) {
            timeSince = String(timePassed!/60)+"m"
        }
        if timePassed < 60 {
            timeSince = String(timePassed!)+"s"
        }
        
        idString = dictionary["id_str"] as? String*/
        
        /*if let retweetedTweet = dictionary["retweeted_status"] {
            user = User(dictionary: (retweetedTweet["user"] as? NSDictionary)!)
            id = (retweetedTweet["id"] as? Int) ?? 0
            text = retweetedTweet["text"] as? String
            retweetCount = (retweetedTweet["retweeted_count"] as? Int) ?? 0
            favoriteCount = (retweetedTweet["favorite_count"] as? Int) ?? 0
            wasRetweeted = true
            retweetedBy = dictionary["user"]!["name"] as? String
            let timeStampString = retweetedTweet["created_at"] as? String
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.dateFromString(timeStampString!)!
            
            let now = NSDate()
            let then = timeStamp
            timePassed = Int(now.timeIntervalSinceDate(then))
            
            // creds for this function go to @dylan-james-smith from ccsf
            if timePassed >= 86400 {
                timeSince = String(timePassed! / 86400)+"d"
            }
            if (3600..<86400).contains(timePassed!) {
                timeSince = String(timePassed!/3600)+"h"
            }
            if (60..<3600).contains(timePassed!) {
                timeSince = String(timePassed!/60)+"m"
            }
            if timePassed < 60 {
                timeSince = String(timePassed!)+"s"
            }
        }
        
        else {
            user = User(dictionary: dictionary["user"] as! NSDictionary)
            id = (dictionary["id"] as? Int) ?? 0
            text = dictionary["text"] as? String
            retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
            favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
            wasRetweeted = false
            let timeStampString = dictionary["created_at"] as? String
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.dateFromString(timeStampString!)!
            
            let now = NSDate()
            let then = timeStamp
            timePassed = Int(now.timeIntervalSinceDate(then))
            
            // creds for this function go to @dylan-james-smith from ccsf
            if timePassed >= 86400 {
                timeSince = String(timePassed! / 86400)+"d"
            }
            if (3600..<86400).contains(timePassed!) {
                timeSince = String(timePassed!/3600)+"h"
            }
            if (60..<3600).contains(timePassed!) {
                timeSince = String(timePassed!/60)+"m"
            }
            if timePassed < 60 {
                timeSince = String(timePassed!)+"s"
            }
        }*/
        
        if let retweetedTweet = dictionary["retweeted_status"] {
            favoriteCount = (retweetedTweet["favorite_count"] as? Int) ?? 0
        }
        else {
            favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
        }
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        id = (dictionary["id"] as? Int) ?? 0
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        //favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
        //wasRetweeted = false
        let timeStampString = dictionary["created_at"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        timeStamp = formatter.dateFromString(timeStampString!)!
        
        let now = NSDate()
        let then = timeStamp
        timePassed = Int(now.timeIntervalSinceDate(then))
        
        // creds for this function go to @dylan-james-smith from ccsf
        if timePassed >= 86400 {
            timeSince = String(timePassed! / 86400)+"d"
        }
        if (3600..<86400).contains(timePassed!) {
            timeSince = String(timePassed!/3600)+"h"
        }
        if (60..<3600).contains(timePassed!) {
            timeSince = String(timePassed!/60)+"m"
        }
        if timePassed < 60 {
            timeSince = String(timePassed!)+"s"
        }
        
        isRetweeted = dictionary["retweeted"] as? Bool
        isLiked = dictionary["favorited"] as? Bool
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    
    class func tweetAsDictionary(dict: NSDictionary) -> Tweet {
        var tweet = Tweet(dictionary: dict)
        return tweet
    }

}
