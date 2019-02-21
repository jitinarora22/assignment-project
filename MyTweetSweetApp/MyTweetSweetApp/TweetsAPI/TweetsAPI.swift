//
//  TweetsAPI.swift
//  MyTweetSweetApp
//
//  Created by Jitin on 19/02/19.
//  Copyright © 2019 Mindtree. All rights reserved.
//

import Foundation

@objc protocol TweetsDelegate{
  
  @objc optional func didReceiveTweetsInfoResponseSuccessfully(resultDict:AnyObject)
  @objc optional func didFailWithTweetsInfoError(error: NSError)
  
}

class TweetsAPI:NSObject {
  
  var delegate:TweetsDelegate?
  var finalUrl: String?
  
  func getTweetsInfo(Str:String)
  {
    if(Str == ""){
       finalUrl =  "https://api.twitter.com/1.1/search/tweets.json?q=all"
    }
    else{
      finalUrl =  "https://api.twitter.com/1.1/search/tweets.json?q=" + Str
    }
    let url = NSURL(string: finalUrl!)
 
    let request = NSMutableURLRequest(url: url! as URL)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("bearer AAAAAAAAAAAAAAAAAAAAAEYI9gAAAAAARQSlahxX%2FqRmNZjmEVoSlShwCSY%3D1Xn5Qsgzsk5UfN0cUxlm4vs1LrNZrbDU773LxX0fWs1jeKoASr", forHTTPHeaderField: "authorization")
    
    
    let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {
      (data, response, error) in
      
      if error != nil {
        DispatchQueue.global(qos: .userInitiated).async {
          
          DispatchQueue.main.async {
            self.delegate?.didFailWithTweetsInfoError!(error: error! as NSError)
            print(error!.localizedDescription)
          }
        }
      } else {
        
        do {
          
          if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject]
          {
            print(json)
            DispatchQueue.global(qos: .userInitiated).async {
              
              DispatchQueue.main.async {
                self.delegate?.didReceiveTweetsInfoResponseSuccessfully!(resultDict: json as AnyObject)
              }
            }
            
          }
          
        } catch {
          
          print("error in JSONSerialization")
          
        }
      }
      
    })
    task.resume()
  }
  
  
  
  
  
}
