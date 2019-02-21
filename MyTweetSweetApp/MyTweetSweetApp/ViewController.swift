//
//  ViewController.swift
//  MyTweetSweetApp
//
//  Created by Jitin on 19/02/19.
//  Copyright © 2019 Mindtree. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TweetsDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
  
  @IBAction func popularityAction(_ sender: Any) {
    sortedTweets()
  }
  
  @IBOutlet weak var tweetsTableView: UITableView!
  
  @IBOutlet weak var popularityFilter: UIButton!
  @IBOutlet weak var sortbyLabel: UILabel!
  @IBOutlet weak var tweetSearchBar: UISearchBar!
  
  var tweetInfoList = [TweetsParameters]()
  var sortedTweetList = [TweetsParameters]()
  var data = [String]()
  var filtered = [String]()
  var actInd = UIActivityIndicatorView()
  var searchActive : Bool = false
  var sortActive : Bool = false
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    actInd.center = self.view.center
    actInd.hidesWhenStopped = true
    actInd.style = UIActivityIndicatorView.Style.gray
    actInd.startAnimating()
    self.view.addSubview(actInd)
    popularityFilter.isEnabled = false
    tweetSearchBar.delegate = self
    tweetsTableView.isHidden = true
    getTweetsList(query: "all")
    
    
    // Do any additional setup after loading the view, typically from a nib.
    let nibName = UINib(nibName: "TableViewCell", bundle: nil)
    tweetsTableView.register(nibName, forCellReuseIdentifier: "TableViewCell")
  }
  
  func getTweetsList(query: String ){
    let tweetAPIHelper = TweetsAPI()
    tweetAPIHelper.delegate = self;
    tweetAPIHelper.getTweetsInfo(Str: query)
  }
  
  func didReceiveTweetsInfoResponseSuccessfully(resultDict: AnyObject) {
    
    print(resultDict)
    data.removeAll()
    
    let responseDict = resultDict as! [String: Any]
    let tweetArr = responseDict["statuses"] as! [[String:Any]]
    for impObject in tweetArr{
      let modelObject = TweetsParameters()
      let trackDict = impObject as? [String:Any]
      
      let name = impObject["text"]
      if (name != nil && !(name is NSNull)){
        modelObject.text = name as? String
        data.append((name as? String)!)
      }
      
      let rCount = impObject["retweet_count"]
      if (rCount != nil && !(rCount is NSNull)){
        modelObject.retweetCount = rCount as? Int
      }
      
      let fCount = impObject["favourites_count"]
      if (fCount != nil && !(fCount is NSNull)){
        modelObject.favCount = fCount as? Int
      }
      
      let userDict = impObject["user"] as? [String:Any]
      
      let userName = userDict?["name"]
      if (userName != nil && !(userName is NSNull)){
        modelObject.twitterName = userName as? String
      }
      
      let hName = userDict?["screen_name"]
      if (hName != nil && !(hName is NSNull)){
        modelObject.handleName = hName as? String
      }
      
      let imageStr = userDict?["profile_image_url"]
      if (imageStr != nil && !(imageStr is NSNull)){
        modelObject.profileImage = imageStr as? String
      }
      self.tweetInfoList.append(modelObject)
      tweetsTableView.reloadData()
      
    }
    tweetsTableView.isHidden = false
    actInd.stopAnimating()
 
    popularityFilter.isEnabled = true
    
    
  }
  
  func didFailWithProductsError(error: NSError) {
    print ("failed")
    
  }
  
  func sortedTweets(){
    sortedTweetList = tweetInfoList.sorted(by: { $0.retweetCount > $1.retweetCount || $0.favCount > $1.favCount} )
    
    print(sortedTweetList)
    sortActive = true
    tweetsTableView.reloadData()
  }
  
  //MARK: UISEARCHBAR DELEGATE METHODS
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print("searchText \(searchText)")
    
    getTweetsList(query: searchText)
    searchBar.showsCancelButton = true
    filtered = data.filter({ (text) -> Bool in
      let tmp: NSString = text as NSString
      let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
      return range.location != NSNotFound
    })
    if(filtered.count == 0){
      searchActive = false;
    } else {
      searchActive = true;
    }
    tweetsTableView.reloadData()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    print("searchText \(String(describing: searchBar.text))")
    filtered.removeAll()
    getTweetsList(query: searchBar.text!)
    filtered = data.filter({ (text) -> Bool in
      let tmp: NSString = text as NSString
      let range = tmp.range(of: searchBar.text!, options: NSString.CompareOptions.caseInsensitive)
      return range.location != NSNotFound
    })
    if(filtered.count == 0){
      searchActive = false;
    } else {
      searchActive = true;
    }
    tweetsTableView.reloadData()
    searchBar.resignFirstResponder()
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = false
    searchBar.text = ""
    searchBar.resignFirstResponder()
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar){
    searchBar.resignFirstResponder()
    searchBar.showsCancelButton = false
  }
  
  //MARK: UITABLEVIEW DELEGATE METHODS
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if(searchActive) {
      return filtered.count
    }
    else if(sortActive){
      return sortedTweetList.count
    }
    return data.count
  }
  
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    print("prefetchRowsAt \(indexPaths)")
  }
  
  func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    print("cancelPrefetchingForRowsAt \(indexPaths)")
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 5
  }
  
  // Make the background color show through
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = UIColor.clear
    return headerView
  }
  
  // create a cell for each table view row
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tweetsTableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
    cell.layer.borderWidth = 0.5
    cell.layer.borderColor = UIColor.lightGray.cgColor
    cell.layer.masksToBounds = true
    cell.layer.cornerRadius = 12;
    
   cell.profileImage.layer.cornerRadius = (cell.profileImage.frame.width)/3.0
    cell.profileImage.layer.masksToBounds = true
    
    if(sortActive){
      cell.name.text = self.sortedTweetList[indexPath.row].twitterName
      cell.handleName.text = self.sortedTweetList[indexPath.row].handleName
      cell.userText.text =  self.sortedTweetList[indexPath.row].text
      cell.favourite.text = String(self.sortedTweetList[indexPath.row].favCount)
      cell.retweets.text = String(self.sortedTweetList[indexPath.row].retweetCount)
      
      
      let url = URL(string: self.sortedTweetList[indexPath.row].profileImage)
      let data = try? Data(contentsOf: url!)
      let finalPicture = UIImage(data: data! as Data)
      
      cell.profileImage.image = finalPicture
    }
    else{
    
    cell.name.text = self.tweetInfoList[indexPath.row].twitterName
    cell.handleName.text = self.tweetInfoList[indexPath.row].handleName
    cell.userText.text =  self.tweetInfoList[indexPath.row].text
    cell.favourite.text = String(self.tweetInfoList[indexPath.row].favCount)
    cell.retweets.text = String(self.tweetInfoList[indexPath.row].retweetCount)
    
    
    let url = URL(string: self.tweetInfoList[indexPath.row].profileImage)
    let data = try? Data(contentsOf: url!)
      if(data != nil){
    let finalPicture = UIImage(data: data! as Data)
    cell.profileImage.image = finalPicture
      }
    }
    return cell
  }
  
  // method to run when table view cell is tapped
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("You tapped cell number \(indexPath.row).")
  }
  
  
}


