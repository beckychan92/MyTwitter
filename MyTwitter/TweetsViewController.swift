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
  let HeaderViewIdentifier = "TableViewHeaderView"

  @IBOutlet weak var tableView: UITableView!

  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "TWEETS"
      
        // Setting up tableview
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 220
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
    
        makeNetworkCall()
 
      
        }

  // MARK: - TableView Methods
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return tweets?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell

    
    if let tweet = tweets?[indexPath.section] {
      cell.tweet = tweet
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: CGRect(x:0, y:0, width: 320, height: 50))
    headerView.backgroundColor = UIColor.blue
    
    let label = UILabel(frame: CGRect(x:0, y:0, width: 150, height: 15))
    label.center = CGPoint(x: 100, y: 5)
    label.textAlignment = .center
    label.adjustsFontSizeToFitWidth = true
    label.adjustsFontForContentSizeCategory = true
    label.textColor = UIColor.lightGray
    
    let tweet = tweets?[section]
    
    if let date = tweet?.timestamp {
      label.text = String(describing: date)
      print("Date: \(date)")
    }
    
    headerView.addSubview(label)
    
    
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
 
    var height = tableView.sectionHeaderHeight
    height = 18
    
    return height
  }
  
  
  @IBAction func logout(_ sender: UIBarButtonItem) {
      TwitterClient.sharedInstance.logout()
  }
  
  // MARK: - Network Call
  
  func makeNetworkCall() {
    
    // Getting the tweets via the API
    TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) -> () in
      self.tweets = tweets
      
      for tweet in tweets {
        print("tweet: \(tweet.text!)")
        print("1. retweeted: \(tweet.retweeted!)")
        print("2. favorited: \(tweet.favorited!)")
        print("3. idStr: \(tweet.idStr!)")
        print("4. id: \(tweet.id!)")
        
        if tweet.retweetedStatus != nil {
          print("5. retweetedStatus:\(tweet.retweetedStatus!)")
        }
        
        if tweet.currentUserRetweet != nil {
          print("6. currentUserRetweet:\(tweet.currentUserRetweet!)")
        }
        
        self.tableView.reloadData()
      }
      
    }, failure: { (error: Error) -> () in
      print("Error: \(error.localizedDescription)")
    })
    
    
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
