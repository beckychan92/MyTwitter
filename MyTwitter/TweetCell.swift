//
//  TweetCell.swift
//  MyTwitter
//
//  Created by Barbara Ristau on 1/23/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {
  

  @IBOutlet weak var tweetTextLabel: UILabel!
  //@IBOutlet weak var timeStampLabel: UILabel!
  @IBOutlet weak var retweetCountLabel: UILabel!
  @IBOutlet weak var favCountLabel: UILabel!
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  
  @IBOutlet weak var profileImage: UIImageView!
  
  var tweetID: NSNumber?
  var originalTweetID: NSNumber?
  var favStatus: Bool?
  var myRetweetStatus: Bool?
  var full_tweet: Tweet?
  var retweet_ID: NSNumber?
  
  var tweet: Tweet! {
    
    didSet {
      
      tweetTextLabel.text = tweet.text
      //timeStampLabel.text = String(describing: tweet.timestamp!)
      retweetCountLabel.text = String(describing: tweet.retweetCount!)
      favCountLabel.text = String(describing: tweet.favoritesCount!)
      
      tweetID = tweet.id!
      if tweet.idStr != 0 {
        originalTweetID = tweet.idStr
        print("original tweet is : \(originalTweetID)")
      }
      
      nameLabel.text = tweet.user?.name!
      screenNameLabel.text = ("@" + (tweet.user?.screenname!)!)
      
      favStatus = tweet.favorited!
      myRetweetStatus = tweet.retweeted!
      self.loadStatusLayout()
      
      if let profileUrl = tweet.user?.profileUrl {
        profileImage.setImageWith(profileUrl)
      }
    }
  }


    override func awakeFromNib() {
        super.awakeFromNib()
      
      profileImage.layer.cornerRadius = 3
      profileImage.clipsToBounds = true 
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  
  // MARK: - SAVING & UNSAVING AS FAVORITE
  
  @IBAction func onSave(_ sender: UIButton) {
    
    if favStatus! {
      unSaveAsFavorite()
    }
    
    else {
     saveAsFavorite()
    }
    
  }

  
  func saveAsFavorite(){
    
    TwitterClient.sharedInstance.createFav(params: ["id": tweetID!], success: { (tweet) -> () in
      
      print("Saving to favorite")
      self.favCountLabel.text = String(describing: tweet!.favoritesCount!)
      self.favStatus = true
      self.loadFavoriteLayout()
      print("New Status: \(tweet!.favorited!)")
      
    }, failure: { (error: Error) -> () in
      print("Error: \(error.localizedDescription)")
    })
    
    
  }
  
  func unSaveAsFavorite() {
    
    TwitterClient.sharedInstance.unSaveAsFavorite(params: ["id": tweetID!], success: { (tweet) -> () in
      
      print("Removing from favorites")
      self.favCountLabel.text = String(describing: tweet!.favoritesCount!)
      self.favStatus = false
      self.loadFavoriteLayout()
      print("Status: \(tweet!.favorited!)")
      
    }, failure: { (error: Error) -> () in
      print("Error: \(error.localizedDescription)")
    })
  }
  
     // MARK: - RETWEETING & UNRETWEETING
  
  
  @IBAction func onRetweet(_ sender: Any) {
    
    print("Clicked on Retweet")
    
    if myRetweetStatus! {
      unRetweet()
    }
      
    else {
      doRetweet()
    }
    
  }
  
  func doRetweet() {
    
    print("Preparing for retweet")
    
    /*
    if tweet.retweetedStatus == nil {
      print("Retweeted Status is nil")
      originalTweetID = tweet.idStr
      print("Original tweet id: \(originalTweetID!)")
    }
      
    else {
      originalTweetID = tweet.retweetedStatus?.idStr
      print("Original tweet id is from retweeted status: \(originalTweetID!)")
      getRetweetID()
    }
 */
    
    TwitterClient.sharedInstance.retweet(params: ["id": tweetID!], success: { (tweet) -> () in
      
      print("Retweeting the Tweet")
      self.retweetCountLabel.text = String(describing: tweet!.retweetCount!)
      self.myRetweetStatus = true
      self.loadRetweetLayout()

    } , failure: { (error: Error) -> () in
      print("Error: \(error.localizedDescription)")
    })
    
  }
  
  func unRetweet() {
    
    if !tweet.retweeted! {
      print("tweet has not been retweeted")
      return
    }
    
    else {
    
      if tweet.retweetedStatus == nil {
        originalTweetID = tweet.idStr
      }
      
      else {
        originalTweetID = tweet.retweetedStatus?.idStr
        getRetweetID()
      }
      
      
      TwitterClient.sharedInstance.unRetweet(params: ["id": originalTweetID!], success: { (tweet) -> () in
      
        print("Un-retweeting the Tweet")
        self.retweetCountLabel.text = String(describing: tweet!.retweetCount!)
        self.myRetweetStatus = false
        self.loadRetweetLayout()

      } , failure: { (error: Error) -> () in
        print("Error: \(error.localizedDescription)")
    })
      
    }
  }
  
  func getRetweetID() {
    
    TwitterClient.sharedInstance.getOriginalTweet(params: originalTweetID, success: { (tweet) -> () in
      
      print("getting retweetID")
      self.retweet_ID = tweet.currentUserRetweet?["id_str"] as? NSNumber
      self.originalTweetID = self.retweet_ID
  
      
    } , failure: { (error: Error) -> () in
        print("Error: \(error.localizedDescription)")
   
    })
    
  }
  
    //    let full_tweet = get("https://api.twitter.com/1/1/statuses/show/" + originalTweetID + "json?include_my_retweet=1")
    //   let retweet_id = full_tweet.current_user_retweet.id_str
  
  
  
  
  
  // MARK: - LAYOUT FOR FAVORITES AND RETWEETS 
  
  func loadStatusLayout() {
    
    self.loadFavoriteLayout()
    self.loadRetweetLayout()
    
  }
  
  func loadFavoriteLayout() {
    
    if favStatus! {
      self.favCountLabel.textColor = UIColor.green
    } else {
      self.favCountLabel.textColor = UIColor.black
    }
  }
  
  func loadRetweetLayout() {
    
    if myRetweetStatus! {
      self.retweetCountLabel.textColor = UIColor.green
    } else {
      self.retweetCountLabel.textColor = UIColor.black
    }

  }
  
  
  
  


  
  

}
