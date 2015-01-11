//
//  TweetCell.swift
//  TwitterClone2
//
//  Created by Annemarie Ketola on 1/9/15.
//  Copyright (c) 2015 Up Early, LLC. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
  
  // hooked up the outlets from the Nib file
  @IBOutlet weak var usernameNibLabel: UILabel!
  @IBOutlet weak var favoriteNibLabel: UILabel!
  @IBOutlet weak var dateNibLabel: UILabel!
  @IBOutlet weak var tweetTextNibLabel: UILabel!
  @IBOutlet weak var userNibImage: UIImageView!
  

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  // this fixes the automatic height issue -> not sure this is required with the nib file
  override func layoutSubviews() {
    super.layoutSubviews()
    self.contentView.layoutIfNeeded()
    self.tweetTextNibLabel.preferredMaxLayoutWidth = self.tweetTextNibLabel.frame.width
  }
  
  // connects the user's image to the userTimeline
//  @IBAction func toUserTimelineNibButtonPressed(sender: AnyObject) {
//    let userVC = self.storyboard?.instantiateViewControllerWithIdentifier("USER_VC") as UserViewController
//    userVC.networkController = self.networkController
//    userVC.userID = self.tweet.userID
//    self.navigationController?.pushViewController(userVC, animated: true)
//  }
  

}
