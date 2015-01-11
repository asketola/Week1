//
//  TweetViewController.swift
//  TwitterClone2
//
//  Created by Annemarie Ketola on 1/9/15.
//  Copyright (c) 2015 Up Early, LLC. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
  
  var tweet : Tweet!
  var networkController : NetworkController!
  
  @IBOutlet weak var usernameDTLabel: UILabel!
  @IBOutlet weak var dateCreatedDTLabel: UILabel!
  @IBOutlet weak var favoritedDTLabel: UILabel!
  @IBOutlet weak var retweetDTLabel: UILabel!
  @IBOutlet weak var tweetTextDTLabel: UILabel!
  @IBOutlet weak var userImageDTLabel: UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      self.usernameDTLabel.text = tweet.username
      self.dateCreatedDTLabel.text = tweet.dateCreated
      // self.favoritedDTLabel.text = tweet.favoriteCount
      self.retweetDTLabel.text = tweet.retweetCount
      self.tweetTextDTLabel.text = tweet.tweetText
      self.userImageDTLabel.image = tweet.userImage
      
      self.networkController.fetchInfoForTweet(tweet.tweetID, completionHandler: { (infoDictionary, errorDescription) -> () in
        println(infoDictionary)
        if errorDescription == nil {
          self.tweet.updateWithInfo(infoDictionary!)
          self.favoritedDTLabel.text = self.tweet.favoriteCount
        }
      })
  }
  

        // Do any additional setup after loading the view.

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
 
  @IBAction func doneToHomeTimelineButtonPressed(sender: AnyObject) {
    let userVC = self.storyboard?.instantiateViewControllerWithIdentifier("USER_VC") as UserViewController
    userVC.networkController = self.networkController
    userVC.userID = self.tweet.userID
    self.navigationController?.pushViewController(userVC, animated: true)
  }
  
  @IBAction func toUserTimelineButtonPressed(sender: AnyObject) {
//    let homeVC = self.storyboard?.instantiateViewControllerWithIdentifier("HOME_VC") as ViewController
//    homeVC.networkController = self.networkController
//    homeVC.userID = self.tweet.userID
//    self.navigationController?.pushViewController(homeVC, animated: true)
  }


}
