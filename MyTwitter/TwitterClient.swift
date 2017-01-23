//
//  TwitterClient.swift
//  MyTwitter
//
//  Created by Barbara Ristau on 1/22/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

  static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "BjhrMfOq3vpYwqTj5F6Lc726A", consumerSecret: "CDZDMUMckjJwq5Za3C68oMnNpIeCVgucBDjulB6fDgOh2Ex9vF")!
  
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
  
  
  func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
    
    loginSuccess = success
    loginFailure = failure
    
    TwitterClient.sharedInstance.deauthorize()
    
    TwitterClient.sharedInstance.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "mytwitter://oauth"), scope: nil, success: ( { (requestToken:BDBOAuth1Credential?) -> Void in
      
      if let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)") {
        
        print("token is valid")
        UIApplication.shared.open(authURL, options: [:], completionHandler: nil)
        
      } else { print("invalid token") }
      
      
    }), failure: { (error: Error?) -> Void in
      print("error: \(error?.localizedDescription)")
      self.loginFailure?(error!)
    })
  }
  
  func handleOpenUrl(url: URL) {
    
    let requestToken = BDBOAuth1Credential(queryString: url.query)
    
    fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
      
        self.loginSuccess?()
      
    }, failure: { (error: Error?) -> Void in
        print("error: \(error?.localizedDescription)")
        self.loginFailure?(error!)
    } )
  
    
  }
  
  
  
  func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
    
    // getting the tweets
    get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task:  URLSessionDataTask, response: Any) -> Void in
      
      let dictionaries = response as! [NSDictionary]
      let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
      success(tweets)
    
    }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
       failure("error: \(error.localizedDescription)" as! Error)
    })
    
  
  }

  func currentAccount() {
    
    // getting user
    get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any) -> Void in
      
      let userDictionary = response as? NSDictionary
      let user = User(dictionary: userDictionary!)
      
      print("name: \(user.name!)")
      print("screenname: \(user.screenname!)")
      print("profileurl: \(user.profileUrl!)")
      print("description: \(user.tagline!)")
      
    }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
      
    })
    
    
  }
  
  
  
}
