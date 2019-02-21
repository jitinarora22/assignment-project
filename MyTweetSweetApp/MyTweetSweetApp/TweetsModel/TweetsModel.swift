//
//  TweetsModel.swift
//  MyTweetSweetApp
//
//  Created by Jitin on 19/02/19.
//  Copyright © 2019 Mindtree. All rights reserved.
//

import Foundation


class TweetsParameters  {
  var text : String!
  var favCount: Int!
  var retweetCount: Int!
  var twitterName: String!
  var handleName: String!
  var profileImage : String!
  
  init(){
    
    self.favCount = 0
    self.text = ""
    self.retweetCount = 0
    self.twitterName = ""
    self.handleName = ""
    self.profileImage = ""
  }
  
  
}

