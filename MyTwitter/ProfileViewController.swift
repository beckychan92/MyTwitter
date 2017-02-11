//
//  ProfileViewController.swift
//  MyTwitter
//
//  Created by Barbara Ristau on 2/9/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

  @IBOutlet weak var nameLabel: UILabel!
  
  var user: User! 
//  var tweet: Tweet!
//  var tweets: [Tweet]!
  
    override func viewDidLoad() {
        super.viewDidLoad()

      print("Here in Profile View")
      
      
      
     
     // func refreshList(notification: NSNotification) {
       // let receivedTweet = notification.object as! Tweet
    //   // tweet = receivedTweet
      
     print("User is :\(user.name!)")

      
  //
    //  print("Tweet: \(tweet.text!)")
      
    }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    print("View will appear called")
    print("View will appear User is :\(user.name!)")
    
    
  }
  
  
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
