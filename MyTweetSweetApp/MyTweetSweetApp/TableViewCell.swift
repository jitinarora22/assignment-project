//
//  TableViewCell.swift
//  MyTweetSweetApp
//
//  Created by Jitin on 20/02/19.
//  Copyright © 2019 Mindtree. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var userText: UILabel!
  @IBOutlet weak var profileImage: UIImageView!
  
  @IBOutlet weak var favourite: UILabel!
  @IBOutlet weak var retweets: UILabel!
  @IBOutlet weak var handleName: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
