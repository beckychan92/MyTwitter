//
//  TweetsViewController.swift
//  MyTwitter
//
//  Created by Barbara Ristau on 1/22/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  var tweets: [Tweet]?

  @IBOutlet weak var tableView: UITableView!

  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "TWEETS"
      
        tableView.dataSource = self
        tableView.delegate = self
    
        TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) -> () in
          self.tweets = tweets
        
          for tweet in tweets {
            print("tweet: \(tweet.text!)")
            self.tableView.reloadData()
            }
          }, failure: { (error: Error) -> () in
          print("Error: \(error.localizedDescription)")
          })
        }

  // MARK: - TableView Methods
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
    return tweets?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell

    
    if let tweet = tweets?[indexPath.row] {
      cell.tweet = tweet
    }
    
    return cell
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
