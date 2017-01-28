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
  
  var tweet: Tweet! {
    
    didSet {
      
      tweetTextLabel.text = tweet.text
      //timeStampLabel.text = String(describing: tweet.timestamp!)
      retweetCountLabel.text = String(describing: tweet.retweetCount!)
      favCountLabel.text = String(describing: tweet.favoritesCount!)
      
      tweetID = tweet.id! 
      nameLabel.text = tweet.user?.name!
      screenNameLabel.text = ("@" + (tweet.user?.screenname!)!)
      
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
  
  
  @IBAction func createFavorite(_ sender: Any) {
    
    print("Clicked on Create Favorite")
    
    TwitterClient.sharedInstance.createFav(params: ["id": tweetID!], success: { (tweet) -> () in
      
        print("Saving to favorite")
        self.favCountLabel.text = String(describing: tweet!.favoritesCount!)
        self.favCountLabel.textColor = UIColor.green

    }, failure: { (error: Error) -> () in
      print("Error: \(error.localizedDescription)")
    })
    
    }
  
  
  @IBAction func onRetweet(_ sender: Any) {
    
    print("Clicked on Retweet")
    
    TwitterClient.sharedInstance.retweet(params: ["id": tweetID!], success: { (tweet) -> () in
    
      print("Retweeting the Tweet")
      self.retweetCountLabel.text = String(describing: tweet!.retweetCount!)
      self.retweetCountLabel.textColor = UIColor.green
      
      
    } , failure: { (error: Error) -> () in
      print("Error: \(error.localizedDescription)")
    })
    
  }
  

  
  

}
