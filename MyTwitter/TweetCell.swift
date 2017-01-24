//
//  TweetCell.swift
//  MyTwitter
//
//  Created by Barbara Ristau on 1/23/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
  

  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var timeStampLabel: UILabel!
  @IBOutlet weak var retweetCountLabel: UILabel!
  @IBOutlet weak var favCountLabel: UILabel!
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var screenNameLabel: UILabel!
  
  @IBOutlet weak var profileImage: UIImageView!
  
  
  var tweet: Tweet! {
    
    didSet {
      
      tweetTextLabel.text = tweet.text
      timeStampLabel.text = String(describing: tweet.timestamp!)
      retweetCountLabel.text = String(describing: tweet.retweetCount!)
      favCountLabel.text = String(describing: tweet.favoritesCount!)
      
      nameLabel.text = tweet.user?.name!
      screenNameLabel.text = tweet.user?.screenname!
      
      
      
    
    }
    
    
  }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
