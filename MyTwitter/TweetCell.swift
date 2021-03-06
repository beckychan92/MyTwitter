//
//  TweetCell.swift
//  MyTwitter
//
//  Created by Barbara Ristau on 1/23/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit
import AFNetworking

protocol MyCustomCellDelegator {
  func callSegueFromCell(myData dataobject: User)
}


class TweetCell: UITableViewCell {
  
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var favoriteCountLabel: UILabel!
  @IBOutlet weak var retweetCountLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  @IBOutlet weak var profileImage: UIImageView!
  
  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var retweetButton: UIButton!
  
  var delegate:MyCustomCellDelegator!
  
  var favStatus: Bool?
  var favCount: Int?
  var retweetStatus: Bool?
  var rtCount: Int?
  var originalTweetID: String?
  var retweetID: String?
  
  var navigationController = UINavigationController()
  
  var tweet: Tweet! {
    
    didSet {
      
      tweetTextLabel.text = tweet.text
  
      nameLabel.text = tweet.user?.name!
      screenNameLabel.text = ("@" + (tweet.user?.screenname!)!)
      
      if let profileUrl = tweet.user?.profileUrl {
        profileImage.setImageWith(profileUrl)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToProfileView))
        profileImage.addGestureRecognizer(tapGesture)
      }

      // Codeblock for determining if tweet is a retweet or not
      
      if let retweetedStatus = tweet.retweetedStatus {
        let retweet = Tweet.tweetAsDictionary(tweet.retweetedStatus!)
        originalTweetID = retweet.idStr
        favCount = retweet.favoritesCount
        rtCount = retweet.retweetCount
        
      } else {
        originalTweetID = tweet.idStr
        favCount = tweet.favoritesCount
        rtCount = tweet.retweetCount
      }
      
      favoriteCountLabel.text = String(describing: favCount!)
      retweetCountLabel.text = String(describing: rtCount!)
      
      favStatus = tweet.favorited!
      retweetStatus = tweet.retweeted!
  
      
      
      
    }
  }


    override func awakeFromNib() {
        super.awakeFromNib()
      
      
      profileImage.clipsToBounds = true
      profileImage.layer.cornerRadius = 3
      
     
      
    }

     override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
    }

  // MARK: - SAVE & UNSAVE AS FAVORITE 
  
  
  @IBAction func onSave(_ sender: UIButton) {
    
    print("Clicked on Save/Unsave")
    
    if favStatus == false {
      
      TwitterClient.sharedInstance.createFav(params: ["id": tweet.idStr!], success: { (tweet) -> () in
        
        if let retweetedStatus = tweet?.retweetedStatus {
          let retweet = Tweet.tweetAsDictionary((tweet?.retweetedStatus!)!)
          self.favCount = retweet.favoritesCount
        } else {
          self.favCount = tweet?.favoritesCount
        }
        
        
        print("Saving TweetID: \(self.originalTweetID!) to favorites. New Status is: \(tweet!.favorited!).  FavCount is: \(self.favCount!)")
        self.favStatus = true
        self.favoriteCountLabel.text = String(describing: self.favCount!)
        self.favoriteCountLabel.textColor = UIColor.red
        self.saveButton.setImage(#imageLiteral(resourceName: "unsave_red24"), for: .normal)
        
      }, failure: { (error: Error) -> () in
        print("Could not successfully save tweet.  Error: \(error.localizedDescription)")
      })
    }
    
    else if favStatus == true {
      
      TwitterClient.sharedInstance.unSaveAsFavorite(params: ["id": originalTweetID!], success: { (tweet) -> () in
     
        if let retweetedStatus = tweet?.retweetedStatus {
          let retweet = Tweet.tweetAsDictionary((tweet?.retweetedStatus!)!)
          self.favCount = retweet.favoritesCount
        } else {
          self.favCount = tweet?.favoritesCount
        }
        
        print("Removing from favorites.  Status after unsaving: \(self.favCount!)")
        self.favStatus = false
        self.favoriteCountLabel.text = String(self.favCount!)
        self.favoriteCountLabel.textColor = UIColor.darkGray
        self.saveButton.setImage(#imageLiteral(resourceName: "addSave24"), for: .normal)
        
      }, failure: { (error: Error) -> () in
        print("Error: \(error.localizedDescription)")
      })
    }
    
  }
  
  
  
     // MARK: - RETWEETING & UNRETWEETING
  
  
  @IBAction func onRetweet(_ sender: Any) {
    
    print("Clicked on Retweet Button")
    
    if retweetStatus == false {
      
      TwitterClient.sharedInstance.retweet(params: ["id": originalTweetID!], success: { (tweet) -> () in
        
        if let retweetedStatus = tweet?.retweetedStatus {
          let retweet = Tweet.tweetAsDictionary((tweet?.retweetedStatus!)!)
          self.rtCount = retweet.retweetCount
        } else {
          self.rtCount = tweet?.retweetCount
        }
        
        print("Retweeting the Tweet. Retweet count is now \(self.rtCount!)")
        
        self.retweetStatus = true
        self.retweetCountLabel.text = String(describing: self.rtCount!)
        self.retweetCountLabel.textColor = UIColor.green
        self.retweetButton.setImage(#imageLiteral(resourceName: "retweeted24"), for: .normal)
        
      } , failure: { (error: Error) -> () in
        print("Error: \(error.localizedDescription)")
      })

    } else if retweetStatus == true {
      
    //    let full_tweet = get("https://api.twitter.com/1/1/statuses/show/" + originalTweetID + "json?include_my_retweet=1")
      //   let retweet_id = full_tweet.current_user_retweet.id_str
      
      print("getting ready for unretweeting")
      getRetweetIdStr()
      
    }

    }
  
  func performUnRetweet() {
    
    
    
    TwitterClient.sharedInstance.unRetweet(params: ["id": retweetID], success: { (tweet) -> () in
      
      if let retweetedStatus = tweet?.retweetedStatus {
        let retweet = Tweet.tweetAsDictionary((tweet?.retweetedStatus!)!)
        self.rtCount = retweet.retweetCount
      } else {
        self.rtCount = tweet?.retweetCount
      }
      
      print("Un-retweeting the Tweet. Retweet count is now \(self.rtCount!)")
      
      self.retweetStatus = false
      self.retweetCountLabel.text = String(describing: self.rtCount!)
      self.retweetCountLabel.textColor = UIColor.darkGray
      self.retweetButton.setImage(#imageLiteral(resourceName: "retweet_standard24"), for: .normal)
      
    } , failure: { (error: Error) -> () in
      print("Error: \(error.localizedDescription)")
    })
  }
  
  func getRetweetIdStr() {
    
    TwitterClient.sharedInstance.getRetweetID(params: ["id": originalTweetID!], success: { (tweet) -> () in
      
      print("Got the tweet") 
      
    } , failure: { (error: Error) -> () in
      print("Error: \(error.localizedDescription)")
    })

  }
  
  
  //    let full_tweet = get("https://api.twitter.com/1/1/statuses/show/" + originalTweetID + "json?include_my_retweet=1")
  //   let retweet_id = full_tweet.current_user_retweet.id_str

  
  
  

  
  // MARK: - LAYOUT FOR FAVORITES AND RETWEETS
  

  func setLabels() {
  
    if tweet.favorited! {
      self.favoriteCountLabel.textColor = UIColor.red
      self.saveButton.setImage(#imageLiteral(resourceName: "unsave_red24"), for: .normal)
    } else if tweet.favorited == false {
      self.favoriteCountLabel.textColor = UIColor.darkGray
      self.saveButton.setImage(#imageLiteral(resourceName: "addSave24"), for: .normal)
    }
    
    if tweet.retweeted! {
      self.retweetCountLabel.textColor = UIColor.green
      self.retweetButton.setImage(#imageLiteral(resourceName: "retweeted24"), for: .normal)
      
    } else if tweet.retweeted == false {
      self.retweetCountLabel.textColor = UIColor.darkGray
      self.retweetButton.setImage(#imageLiteral(resourceName: "retweet_standard24"), for: .normal)
      
    }
    
  }
  
  func goToProfileView() {
    print ("Going to profile view")
    let user = tweet?.user
    print("User: \(user!.name!)")
    if(self.delegate != nil) {
      self.delegate.callSegueFromCell(myData: user! as User)
    }
   
  
  }
}




 // func switchToProfile() {
   // print("Going to profile view")
    
   /* let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    let profileVC: ProfileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileView") as! ProfileViewController
   
    let sendingTweet = tweet
    print("Sending Tweet: \(tweet.text!)")
    profileVC.tweet = sendingTweet
    print("Profile User Tweet: \(profileVC.tweet.text!)")
    profileVC.user = tweet.user
    print("User: \(profileVC.user.name!)")
  //  profileVC.nameLabel.text = profileVC.user.name!
    
   // NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "ProfileView"), object: sendingTweet) as Notification)
    
  }
  
 
  
  
  
  
    
 //   NotificationCenter.default.addObserver(self, selector: #selector(goToProfileView), name: NSNotification.Name(rawValue: "ProfileView"), object: nil)
    
  //  let segue = UIStoryboardSegue(identifier: "ProfileView", source: TweetsViewController, destination: ProfileViewController)
    
    
//    let detailVc = segue.destination as! TweetDetailsViewController
 //   detailVc.tweet = sendingTweet
   // detailVc.tweets = tweets
    
    
 //   let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//    let profileVC: ProfileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileView") as! ProfileViewController
//    self.navigationController.pushViewController(profileVC, animated: true)
    
    
   // self.navigationController.pushViewController(ProfileViewController, animated: true)
    
   // let currentPage = self.navigationController.visibleViewController?.restorationIdentifier!
    
    
  //  let controller = self.storyboard!.instantiateViewController(withIdentifier: "Page5")
   // let page5vc = controller as! StoryNodeViewController
 //   navigationController?.pushViewController(page5vc, animated: true)

   // let storyboard = UIStoryboard(name: "MyStoryboardName", bundle: nil)
   // let controller = storyboard.instantiateViewController(withIdentifier: "ProfileView")
   // navigationController.pushViewController(ProfileViewController, animated: true)
 
   // navigationController?.pushViewController(page5vc, animated: true)
//    self.present(controller, animated: true, completion: nil)

*/


