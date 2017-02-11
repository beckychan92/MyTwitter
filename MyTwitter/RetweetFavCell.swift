//
//  RetweetFavCell.swift
//  MyTwitter
//
//  Created by Barbara Ristau on 2/10/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit

class RetweetFavCell: UITableViewCell {

  
  @IBOutlet weak var retweetCountLabel: UILabel!
  
  
  var rtCount: Int!
  
  
  var tweet: Tweet! {
    
    didSet {
      
      rtCount = tweet.retweetCount
      retweetCountLabel.text = String(describing: rtCount!)
        
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
