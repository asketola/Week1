//
//  Tweet.swift
//  TwitterClone2
//
//  Created by Annemarie Ketola on 1/9/15.
//  Copyright (c) 2015 Up Early, LLC. All rights reserved.
//

import UIKit

class Tweet {

  var tweetText : String
  var username : String
  var imageURL : String
  var userImage : UIImage?
  var tweetID : String
  var favoriteCount : String?
  var userID : String
  var retweet : Int
  var retweetCount : String
  var dateCreated : String
  var screenName :  String
  var bannerImage : UIImage?
  var location : String

  // Initialize all the variables from their seperate dictionaries
  init( _ jsonDictionary : [String : AnyObject]) {
  self.tweetID = jsonDictionary["id_str"] as String
  self.tweetText = jsonDictionary["text"] as String
  self.retweet = jsonDictionary["retweet_count"] as Int
  self.retweetCount = "\(retweet)"
  let userDictionary = jsonDictionary["user"] as [String : AnyObject]
  self.userID = userDictionary["id_str"] as String
  self.imageURL = userDictionary["profile_image_url"] as String
  self.username = userDictionary["name"] as String
  self.dateCreated = userDictionary["created_at"] as String
  self.screenName = userDictionary["screen_name"] as String
  self.location = userDictionary["location"] as String
  
  //println(userDictionary)
  println("tweetText: \(tweetText)")
  println("username: \(username)")
  println("imageURL: \(imageURL)")
  println("userImage: \(userImage)")
  println("tweetID: \(tweetID)")

  println("userID: \(userID)")
  println("retweet: \(retweet)")
  println("retweetCount: \(retweetCount)")
  println("dateCreated: \(dateCreated)")
  println("screenName: \(screenName)")
  println("location: \(location)")
  
  if jsonDictionary["in_reply_to_user_id"] is NSNull {
    println("nsnull")
  }
}

  // finds and renames the favorites count
func updateWithInfo(infoDictionary : [String : AnyObject]) {
  let favoriteNumber = infoDictionary["favorite_count"] as Int
  self.favoriteCount = "\(favoriteNumber)"
    println("favoriteCount: \(favoriteCount)")
  }
}
