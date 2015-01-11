//
//  UserViewController.swift
//  TwitterClone2
//
//  Created by Annemarie Ketola on 1/9/15.
//  Copyright (c) 2015 Up Early, LLC. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDataSource {
  
  // global variables, calls the networkController class and Tweet class
  var networkController : NetworkController!
  var userID : String!
  var tweets : [Tweet]?

  // hooks up outlets to the header Cell, had to unhook
//  @IBOutlet weak var userHeaderImage: UIImageView!
//  @IBOutlet weak var userBannerImage: UIImageView!
//  @IBOutlet weak var screenName: UILabel!
//  @IBOutlet weak var usernameLabel: UILabel!
//  @IBOutlet weak var locationLabel: UILabel!
  
  // hooks the UITableView up to this controller
  @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
      
      // sets up the parameters of the cell and registers the Nib file and reloads the data
      self.tableView.dataSource = self
      self.tableView.estimatedRowHeight = 144
      self.tableView.rowHeight = UITableViewAutomaticDimension
      self.tableView.registerNib(UINib(nibName: "TweetNib", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "USER_CELL")
      self.networkController.fetchTimelineForUser(self.userID, completionHandler: {(tweets, errorDescription) -> () in
      self.tweets = tweets
      self.tableView.reloadData()
      })
      
      
      // Put labels on header cell, doesn't quite work right
//      self.networkController.fetchBannerForBackground(tweet, completionHandler: {(image) -> () in
//        if self.userBannerImage!.image == nil && self.userHeaderImage!.image == nil {
//            let tweet = self.tweets![indexPath.row]
//          self.screenName.text = self.tweet.screenName
//          self.usernameLabel.text = self.tweet.username
//          self.locationLabel.text = self.tweet.location
//          self.userHeaderImage.image = self.tweet.userImage
//          self.userBannerImage.image = self.tweets.bannerImage
//        } else {
//          self.userBannerImage.image = self.tweet.bannerImage
//          self.userHeaderImage.image = self.tweet.userImage
//          self.screenName.text = self.tweet.screenName
//          self.usernameLabel.text = self.tweet.username
//          self.locationLabel.text = self.tweet.location
//        }
//      })
      
      // Do any additional setup after loading the view.
    }

  
  // determines how many tweets there are
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let tweets = self.tweets {
      return tweets.count
    } else {
      return 0
    }
  }
  
  
  // this function puts the image and labels in the cells using the protocal defined above with the Nib
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("USER_CELL", forIndexPath: indexPath) as TweetCell
    let tweet = self.tweets![indexPath.row]
    cell.tweetTextNibLabel.text = tweet.tweetText
    cell.usernameNibLabel.text = tweet.username
    if tweet.userImage == nil {
      self.networkController.fetchImageForTweet(tweet, completionHandler: { (image) -> () in
        cell.userNibImage.image = tweet.userImage
      })
    } else {
      cell.userNibImage.image = tweet.userImage
    }
    return cell
  }
  


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

}
