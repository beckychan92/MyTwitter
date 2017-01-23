//
//  LoginViewController.swift
//  MyTwitter
//
//  Created by Barbara Ristau on 1/17/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
  
  @IBAction func onLoginButton(_ sender: Any) {
    
    let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "BjhrMfOq3vpYwqTj5F6Lc726A", consumerSecret: "CDZDMUMckjJwq5Za3C68oMnNpIeCVgucBDjulB6fDgOh2Ex9vF")!
    
    twitterClient.deauthorize()

    twitterClient.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: nil, scope: nil, success: ( { (requestToken:BDBOAuth1Credential?) -> Void in
    
      print("getting request token")
      
      if let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)") {

        print("token is valid")
        UIApplication.shared.open(authURL, options: [:], completionHandler: nil)
      
      } else { print("invalid token") }
      
      
    }), failure: { (error: Error?) -> Void in
      print("error: \(error?.localizedDescription)")
    })
    
    
   // twitterClient.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: nil, scope: nil, success: ( { (requestToken:BDBOAuth1Credential) -> Void in
      
  
      
   /*   if let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token)") {

        UIApplication.shared.open(authURL, options: [:], completionHandler: nil)
        print("Token Received")
     
      } else {
        print ("Could not get token")
      }
    }), failure: { (error: Error?) -> Void in
        print ("error: \(error?.localizedDescription)")
    })
  }
    */
 
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
