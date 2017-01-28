//
//  Tweet.swift
//  MyTwitter
//
//  Created by Barbara Ristau on 1/22/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit

class Tweet: NSObject {
  
  var user: User?
  var text: String?
  var timestamp: Date?
  var retweetCount: Int? = 0
  var favoritesCount: Int? = 0
  var id: NSNumber?
  
  init(dictionary: NSDictionary){
  
    user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
    
    text = dictionary["text"] as? String
    retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
    favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0

    let timestampString = dictionary["created_at"] as? String

    if let timestampString = timestampString {
      let formatter = DateFormatter()
      formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
      timestamp = formatter.date(from: timestampString)
      
    // id for retweeting and creating favorite
      id = dictionary["id"] as? Int as NSNumber?
  
    }
  }
  
  
  //MARK: - Convenience Methods
  
  // This method gives us tweets as an array of dictionaries
  class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
  
      var tweets = [Tweet]()
    
      for dictionary in dictionaries {
        let tweet = Tweet(dictionary: dictionary)
        tweets.append(tweet)
      
      }
    
      return tweets
  }
  
  // This method converts a dictionary into a single tweet 
  class func tweetAsDictionary(_ dict: NSDictionary) -> Tweet {
   
    let tweet = Tweet(dictionary: dict)
    
    return tweet
  }

}
