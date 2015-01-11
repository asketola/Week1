//
//  ViewController.swift
//  TwitterClone2
//
//  Created by Annemarie Ketola on 1/9/15.
//  Copyright (c) 2015 Up Early, LLC. All rights reserved.
//

import UIKit
import Social
import Accounts

@IBDesignable class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  var tweets = [Tweet]()
  let networkController = NetworkController()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.dataSource = self //acts as it own data source of the receiving table view
    
    // registers a nib object (our file TweetNib.xib) containing a cell with a table view under a specified identifier, we are defining it here as "TWEET_CELL", we also have this name as the Identifier in our nib file Attributes Inspector
    self.tableView.registerNib(UINib(nibName: "TweetNib", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "TWEET_CELL")
    self.tableView.delegate = self // acts as its own delegate(?)
    self.tableView.estimatedRowHeight = 144 // estimates the height of the tweet text, makes things more efficient
    self.tableView.rowHeight = UITableViewAutomaticDimension  // Requests that UITableView use the default value for a given dimension
    
    
    // uses the fetchHomeTimeline in the Network Controller to get the data for this view
    self.networkController.fetchHomeTimeline { (tweets, errorString) -> () in
      
      // if there is no error, then put in the tweets
      if errorString == nil {
        self.tweets = tweets!
        self.tableView.reloadData()  // updates the cells
      } else {
      }
      }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  // this tells us how to many rows to make, usually 20, since that is how many we requested from Twitter
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    println("We have this many tweets in our Tweet class array tweets: \(tweets.count)")
    return self.tweets.count
  }
  
  // this function puts the image and labels in the cells using the protocal defined above with the Nib
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    // returns a reusable table-view cell object for the specified reuse identifier "TWEET_CELL"
    let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetCell
    
    
    let tweet = self.tweets[indexPath.row]  // defines the single tweet
    
    // puts on the labels
    cell.tweetTextNibLabel.text = tweet.tweetText
    cell.usernameNibLabel.text = tweet.username
    
    // userImage is always initially nil in our Tweet class(which is why we made it optional), this uses the function fetchImageForTweet to get it
    if tweet.userImage == nil {
      self.networkController.fetchImageForTweet(tweet, completionHandler: {(image) -> () in
        cell.userNibImage.image = tweet.userImage
      })
    } else {
      cell.userNibImage.image = tweet.userImage
    }
      return cell
  }
  
  // function to let you tap the cell and go to the detailed tweet
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    println(indexPath.row)
    
    // Instantiates the view controller with the specified identifier (the detailed page)
    let tweetVC = self.storyboard?.instantiateViewControllerWithIdentifier("TWEET_VC") as TweetViewController
    tweetVC.networkController = self.networkController
    tweetVC.tweet = self.tweets[indexPath.row]
    
    // Pushes a view controller onto the receiver’s stack and updates the display
    self.navigationController?.pushViewController(tweetVC, animated: true)
  }
}

