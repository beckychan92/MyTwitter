//
//  DetailTweetCell.swift
//  MyTwitter
//
//  Created by Barbara Ristau on 2/10/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit

class DetailTweetCell: UITableViewCell {

  
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  
  @IBOutlet weak var retweetCountLabel: UILabel!

  var rtCount: Int?

  
 var tweet: Tweet! {
    
    didSet {
     
      tweetTextLabel.text = tweet.text
      //nameLabel.text = tweet.user?.name!
      nameLabel.text = tweet.user?.name!
      
    }
  }
  

  
  
    override func awakeFromNib() {
        super.awakeFromNib()
      
   // tweetTextLabel.text = "TEST"
   // tweetTextLabel.text = tweet.text

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
