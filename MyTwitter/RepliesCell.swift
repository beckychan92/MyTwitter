//
//  RepliesCell.swift
//  MyTwitter
//
//  Created by Barbara Ristau on 2/10/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit

class RepliesCell: UITableViewCell {
  
  
  @IBOutlet weak var replyTextLabel: UILabel!
  
  
  var tweet: Tweet!

    override func awakeFromNib() {
        super.awakeFromNib()

      
      
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
