//
//  TwitterClient.swift
//  Twitter
//
//  Created by Tasfia Addrita on 2/28/16.
//  Copyright © 2016 Tasfia Addrita. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "wn88G1DYJZDSxps0160OXG7si", consumerSecret: "MqeZwiEmFsGIHTbHU6EWA95hxuMwTzHWNAi2DODOEIyc06wm6M")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "mytwitterdemo://oauth"), scope: nil,
            
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                print("I got a token!")
                
                let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
                UIApplication.sharedApplication().openURL(url)
                
            }) {
                
                (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
        
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterClient.sharedInstance.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken,
            
            success: { (accessToken: BDBOAuth1Credential!) -> Void in
                
                self.currentAccount({ (user: User) -> () in
                    User.currentUser = user
                    self.loginSuccess?()
                    }, failure: { (error: NSError) -> () in
                        self.loginFailure?(error)
                })
                
                self.loginSuccess?()
                
            }) {
                
                (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
        
    }
    
    func homeTimeline(parameters: NSDictionary?, success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil,
            
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries)
                success(tweets)
            },
            
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func userTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()){
        
        GET("1.1/statuses/user_timeline.json", parameters: params,
            
            success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                
                var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
                
            },
            
            failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                completion(tweets: nil , error: error)
            }
        )
    }
    
    /*func userTimelineWith(screenName: String, params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        
        GET("1.1/statuses/user_timeline.json?screen_name=\(screenName)", parameters: params, progress: nil,
            
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                
                var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
            },
            
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                completion(tweets: nil, error: error)
            }
        )
    }*/
    
    func getOlderTweets(id: Int, success: ([Tweet])-> (), failure: (NSError) -> ()){
        
        GET("1.1/statuses/home_timeline.json?max_id=\(id)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("hello")
            let dictionaries  = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.description)
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil,
            
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let userDictionary = response as! NSDictionary
                let user = User(dictionary: userDictionary)
                
                success(user)
            },
            
            failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func postTweet(status: String) {
        POST("1.1/statuses/update.json\(status)", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("success post")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                
                print("https://api.twitter.com/1.1/statuses/update.json\(status)")
        })
    }
    
    func favoriteTweet(id: Int?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        POST("1.1/favorites/create.json?id=\(id!)", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("success liking")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error liking\(id!)")
        })
    }
    
    func retweetTweet(id: Int?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        POST("1.1/statuses/retweet/\(id!).json", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("success retweet")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error retweet\(id!)")
        })
    }
    
    func unretweetTweet(id: Int?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        POST("1.1/statuses/unretweet/\(id!).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Unretweeting a tweet!")
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
        }
    }
    
    func unfavoriteTweet(id: Int?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        POST("/1.1/favorites/destroy.json?id=\(id!)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Unfavoriting a tweet")
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
        }
    }
    
}
