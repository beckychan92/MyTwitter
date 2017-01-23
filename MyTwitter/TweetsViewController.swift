//
//  TweetsViewController.swift
//  MyTwitter
//
//  Created by Barbara Ristau on 1/22/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
  
  var tweets: [Tweet]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "TWEETS"
      
      TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) -> () in
        self.tweets = tweets
        
        for tweet in tweets {
          print("tweet: \(tweet.text!)")
          // load tableview / reload data
        }
      }, failure: { (error: Error) -> () in
        print("Error: \(error.localizedDescription)")
      })
      
      
    }


  
  @IBAction func logout(_ sender: UIBarButtonItem) {
      TwitterClient.sharedInstance.logout()
  }
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
