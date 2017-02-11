//
//  TweetDetailsViewController.swift
//  MyTwitter
//
//  Created by Barbara Ristau on 2/9/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!
  

  var tweet: Tweet!
  var tweets: [Tweet]!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      tableView.dataSource = self
      tableView.delegate = self
      
      tableView.reloadData()
     
      print("Tweet Text in Detail VC: \(tweet.text!)")
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  // MARK: - TABLEVIEW METHODS
  
  
  public func numberOfSections(in tableView: UITableView) -> Int{
    return 4
  }
  
  
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
    
    switch section {
      
    case 0, 1, 2:
      return  1
      
    case 3:
      return 10
      
    default:
      return 0
    }

  }
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    switch indexPath.section {
      
    case 0:
      return 150
      
    case 3:
      return 50
      
    default:
      return 44
    }
    
  }
  
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = UITableViewCell()
    
    if indexPath.section == 0 {
     
      let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTweetCell", for: indexPath) as! DetailTweetCell
      cell.tweet = tweet
      
    }
    
    else if indexPath.section == 1 {
    
      let cell = tableView.dequeueReusableCell(withIdentifier: "RetweetFav", for: indexPath) as! RetweetFavCell
      cell.tweet = tweet
      
    }
    
    else if indexPath.section == 2 {

      let cell = tableView.dequeueReusableCell(withIdentifier: "ActionsCell", for: indexPath) as! ActionsCell
      cell.tweet = tweet
    }
    
    
    else if indexPath.section == 3 {
      
    let cell = tableView.dequeueReusableCell(withIdentifier: "RepliesCell", for: indexPath) as! RepliesCell

     // cell.textLabel?.text = "row \(indexPath.row)"
      cell.tweet = tweets[(indexPath.row)]
      cell.replyTextLabel.text = cell.tweet.text
    }
    
    return cell
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
