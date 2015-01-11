//
//  NetworkController.swift
//  TwitterClone2
//
//  Created by Annemarie Ketola on 1/9/15.
//  Copyright (c) 2015 Up Early, LLC. All rights reserved.
//

import Foundation
import Accounts
import Social

class NetworkController {
  
  // global variables that let us reuse the part of code that checks to see if the user has a twitter account
  var twitterAccount : ACAccount?
  var imageQueue = NSOperationQueue()
  
  init() {
  }

  func fetchHomeTimeline( completionHandler : ([Tweet]?, String?) -> ()) {
    
    // creates a blank place to store your accounts
    let accountStore = ACAccountStore()
    
    // who/where/type of account you are getting
    let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
    
    // request access with use of a "handler"
    accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted : Bool, error : NSError!) -> Void in
      
      // if you get access
      if granted {
        
        // see if the user has an account
        let accounts = accountStore.accountsWithAccountType(accountType)
        
        
        if !accounts.isEmpty {accounts
          
          // if multiple accounts are found, you have to pick one
          self.twitterAccount = accounts.first as? ACAccount
          
          // API from twitter website, put into a variable
          let requestURL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
          
          // the social request
          let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: nil)
          
          // connect the social request with the account
          twitterRequest.account = self.twitterAccount
          
          // perform the request and get the data with the "Handler"
          twitterRequest.performRequestWithHandler() {(data, response, error) -> Void in
            
            // this part checks to see if the code given back in the json file is good or not and lets it keep moving on to parse the data
            switch response.statusCode {
            case 200...299:
              println("this is great!")
              
              // serialization decodes the json file into what we can read into an array
              if let jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [AnyObject] {
                var tweets = [Tweet]() // creates the tweets array for the networkController
                for object in jsonArray { // loops through the array
                  if let jsonDictionary = object as? [String : AnyObject] { // required code to make it fit into the Tweet Class
                    let tweet = Tweet(jsonDictionary) // separates the array for the info for 1 Tweet Class element (all parts)
                    tweets.append(tweet) // adds the tweet element into the tweets array
                  }
                }
                
                // bring the info back into the main thread and makes it finish up business using the complettionHandler
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                  completionHandler(tweets, nil)
              })
            }
            case 300...599: // if the code was bad, the program jumps down here to see what bad code it was and let us know
              println("No bueno!")
              completionHandler(nil, "No bueno also")
              default:
              println("default case fired")
            }
          }
        }
      }
    }
  }
  
  func fetchInfoForTweet(tweetID : String, completionHandler : ([String : AnyObject]?, String?) -> ()) {
    
    // puts the address in the variable
    let requestURL = "https://api.twitter.com/1.1/statuses/show.json?id=\(tweetID)"
    let url = NSURL(string: requestURL)
    // the social request
    let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url!, parameters: nil)
    request.account = self.twitterAccount
    
    // performs the request
    request.performRequestWithHandler{ (data, response, error) -> Void in
      if error == nil {
        switch response.statusCode {
        case 200...299:
          println("this is great")
          
           // serialization decodes the json file into what we can read into an array
          if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String : AnyObject] {
            // bring the info back into the main thread and makes it finish up business using the complettionHandler
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
              completionHandler(jsonDictionary, nil)
            })
          }
        default:
          println("this is the defualt case")
        }
      }
    }
  }
  
  func fetchImageForTweet(tweet : Tweet, completionHandler: (UIImage?) -> ()) {
    
    if let imageURL = NSURL(string: tweet.imageURL) {
      
      // moves work to a background thread
      self.imageQueue.addOperationWithBlock({ () -> Void in
        
        // gets the data of the image
        if let imageData = NSData(contentsOfURL: imageURL) {
          
          // puts it in an image property
        tweet.userImage = UIImage(data: imageData)
          
          //  bring the info back into the main thread and makes it finish up business using the complettionHandler
          NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            completionHandler(tweet.userImage)
          })
        }
      })
    }
  }
  
  func fetchTimelineForUser(userID : String, completionHandler : ([Tweet]?, String?) -> ()) {
    // makes a variable holding the API address from twitter
    let requestURL = NSURL(string: "https://api.twitter.com/1.1/user_timeline.json?user_id=\(userID)")
    
    // the social request
    let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL!, parameters: nil)
    
    // connect the social request with the account
    request.account = self.twitterAccount
    
    // perform the request and get the data with the "Handler" puts it in the background and puts it in the background
    request.performRequestWithHandler{ (data, response, error) -> Void in
      if error == nil {
        switch response.statusCode {
        case 200...299:
          println("this is great")
          
          // serialization decodes the json file into what we can read into an array
          if let jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [AnyObject] {
            var tweets = [Tweet]()  // creates the tweets array for the networkController
            for object in jsonArray {  // loops through array
              if let jsonDictionary = object as? [String: AnyObject] {  // required code to make it fit into the Tweet Class
                let tweet = Tweet(jsonDictionary)  // makes it a single element
                tweets.append(tweet) // add to array
              }
            }
             // bring the info back into the main thread and makes it finish up business using the complettionHandler
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
              completionHandler(tweets, nil)
            })
          }
        default:
          println("default case hit")
        }
      }
    }
  }
  
  func fetchBannerForBackground (tweet: Tweet, completionHandler : (UIImage?) -> ()) {
    // makes a variable holding the API address from twitter
    let requestURL = NSURL(string: "https://api.twitter.com/1.1/users/profile_banner.json?screen_name=\(tweet.screenName)")
    
    // the social request
    let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL!, parameters: nil)
    
    // connect the social request with the account
    request.account = self.twitterAccount
    
    // perform the request and get the data with the "Handler" puts it in the background and puts it in the background
    request.performRequestWithHandler{ (data, response, error) -> Void in
      if error == nil {
        switch response.statusCode {
        case 200...299:
          println("this is great")
          
          // serialization decodes the json file into what we can read into an array
          if let jsonArray = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject] {
            if let sizes = jsonArray["sizes"] as? [String: AnyObject] {
              if let webRetina = sizes["web_retina"] as? [String: AnyObject] {
                var bannerURL = webRetina["url"] as String
                if let imageData = NSData(contentsOfURL: NSURL(string: bannerURL)!) {
                  tweet.bannerImage = UIImage(data: imageData)
                }
              }
            }
            
                // bring the info back into the main thread and makes it finish up business using the complettionHandler
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                  completionHandler(tweet.bannerImage)
              })
            }
        case 300...599: // if the code was bad, the program jumps down here to see what bad code it was and let us know
          println("No bueno!")
        default:
          println("default case fired")
        }
      }
    }
  }
  
}
