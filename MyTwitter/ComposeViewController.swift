//
//  ComposeViewController.swift
//  MyTwitter
//
//  Created by Barbara Ristau on 2/9/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
  
  var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()

      
      print("Going to compose a tweet")
      
      user = User.currentUser
      var name = user.name
      print("User is: \(name!)")
      
        // Do any additional setup after loading the view.
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
