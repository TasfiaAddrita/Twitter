//
//  User.swift
//  Twitter
//
//  Created by Tasfia Addrita on 2/28/16.
//  Copyright © 2016 Tasfia Addrita. All rights reserved.
//

import UIKit

let userDidTweetNotification = "userDidTweetNotification"

class User: NSObject {

    var name: NSString?
    var screenname: NSString?
    var profileUrl: NSURL?
    var profileBannerURL: NSURL?
    var userDescription: NSString?
    var followingCount: Int?
    var followerCount: Int?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        var profileUrlString = dictionary["profile_image_url"] as! String
        let range = profileUrlString.rangeOfString("_normal\\.", options: .RegularExpressionSearch)
        if let range = range {
            profileUrlString = profileUrlString.stringByReplacingCharactersInRange(range, withString: "_bigger.")
        }
        self.profileUrl = NSURL(string: profileUrlString)
        
        let profileBannerString = dictionary["profile_banner_url"] as? String
        if let profileBannerString = profileBannerString {
            profileBannerURL = NSURL(string: profileBannerString)
        }
        
        userDescription = dictionary["description"] as? String
        
        followingCount = dictionary["friends_count"] as? Int
        followerCount = dictionary["followers_count"] as? Int
    }
    
    func tweeted() {
        NSNotificationCenter.defaultCenter().postNotificationName(userDidTweetNotification, object: nil)
    }
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    static var _currentUser = User?()
    
    class var currentUser: User? {
        
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
        
                if let userData = userData {
                let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
        
    }
    
}
