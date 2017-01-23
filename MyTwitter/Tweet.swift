//
//  Tweet.swift
//  MyTwitter
//
//  Created by Barbara Ristau on 1/22/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit

class Tweet: NSObject {
  
  var text: String?
  var timestamp: Date?
  var retweetCount: Int? = 0
  var favoritesCount: Int? = 0
  
  
  init(dictionary: NSDictionary){
  
    text = dictionary["text"] as? String
    retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
    favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0

    let timestampString = dictionary["created_at"] as? String

    if let timestampString = timestampString {
      let formatter = DateFormatter()
      formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
      timestamp = formatter.date(from: timestampString)
    }
  }
  
  class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
  
      var tweets = [Tweet]()
    
      for dictionary in dictionaries {
        let tweet = Tweet(dictionary: dictionary)
        tweets.append(tweet)
      
      }
    
      return tweets
    
  }

}
