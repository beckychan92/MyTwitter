//
//  TweetsViewController.swift
//  MyTwitter
//
//  Created by Barbara Ristau on 1/22/17.
//  Copyright © 2017 FeiLabs. All rights reserved.
//

import UIKit


class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MyCustomCellDelegator {
  
  var tweets: [Tweet]?
  var tweetID: String?
  var tweet: Tweet?
  
  var saveCountLabel: UILabel?
  var saveButton: UIButton?
  
  //let HeaderViewIdentifier = "TableViewHeaderView"
  //var headerView: UIView?

  // infinite scrolling properties
  var isMoreDataLoading = false
  var loadingMoreView: InfiniteScrollActivityView?

  // UIRefreshControl
  let refreshControl = UIRefreshControl()
  
  // date formatter 
  let dateFormatter = DateFormatter()
  

  @IBOutlet weak var tableView: UITableView!


  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My Tweets"
       // UIColor(red:0.75, green:0.92, blue:0.95, alpha:1.0) // hex# beebf3
      
        // Set up Infinite Scroll loading indicator 
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
      
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
    
        // Implement refresh control
        // Bind action to refresh control & add to tableview
        self.refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        self.tableView.insertSubview(refreshControl, at: 0)
  
        // Set up Notification for Segue 
    //  NotificationCenter.default.addObserver(self, selector: #selector(goToProfileView), name: NSNotification.Name(rawValue: "ProfileView"), object: nil)
  
        // Setting up tableview
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
     //   tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
    
        makeNetworkCall()
 
      
        }

  // MARK: - TableView Methods
  
  //func numberOfSections(in tableView: UITableView) -> Int {
  //  return tweets?.count ?? 0
 // }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets?.count ?? 0
    
   // return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
    
    cell.backgroundColor = UIColor(red:0.92, green:0.98, blue:0.99, alpha:1.0) // hex# ebfbfd // color for retweet and save
    cell.selectionStyle = .none
    
  //  cell.delegate = self - used this for segue
    
    let tweet = tweets?[indexPath.row]
    cell.tweet = tweet
    
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    tableView.reloadData()
    
  }
  
  
  
 /* func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
  
    headerView = UIView(frame: CGRect(x:0, y:0, width: 320, height: 50))
    headerView?.backgroundColor = UIColor(red:0.36, green:0.72, blue:0.78, alpha:0.7)  // hex#5CB7C8 // color used for retweet
    headerView?.tag = section
    
    tweet = tweets?[section]
    tweetID = tweet?.idStr
    
    // add date to header
    if let date = tweet?.timestamp {
      
      let label = addDateToHeader(date: date)
      headerView?.addSubview(label)
    }
 */
    
    /*
    // add retweet button to header
    let retweetButton = addRetweetButtonToHeader()
    headerView?.addSubview(retweetButton)
    
    // add retweet Label to header 
    if let retweetCount = tweet?.retweetCount {
      let retweetLabel = addRetweetLabelToHeader(count: String(retweetCount))
      headerView?.addSubview(retweetLabel)
    }
    */
    
    // add save button to header 
    /*
    saveButton = addSaveButtonToHeader(tweet: tweet!)
    saveButton?.tag = section
    headerView?.addSubview(saveButton!)
    
    // add save label to header 
    if let saveCount = tweet?.favoritesCount {
      saveCountLabel = addSaveLabelToHeader(count: String(saveCount))
      headerView?.addSubview(saveCountLabel!)
    }
 */
    
   // return headerView
 // }
  
 /* func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
 
    var height = tableView.sectionHeaderHeight
    height = 20
    
    return height
  }
 */
  
  /*
  
  func addDateToHeader(date: Date) -> UILabel{
    
    dateFormatter.dateFormat = "MMM d, h:mm a"
    
    let label = UILabel(frame: CGRect(x:0, y:0, width: 80, height: 15))
    label.center = CGPoint(x: 50, y: 5)
    label.textAlignment = .center
    label.adjustsFontSizeToFitWidth = true
    label.adjustsFontForContentSizeCategory = true
    label.textColor = UIColor(red:0.12, green:0.51, blue:0.59, alpha:1.0) // hex#1F8396 // color used for retweet     
    label.text = dateFormatter.string(from: date)
    
    return label
 
  }
 */
  
  /*
  
  func addRetweetButtonToHeader() -> UIButton {
    
    let retweetButton = UIButton()
    retweetButton.setImage(#imageLiteral(resourceName: "retweet_blue24"), for: .normal)
    
    retweetButton.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
    retweetButton.center = CGPoint(x: 150, y: 10)
    
    return retweetButton
  }
  
  func addRetweetLabelToHeader(count: String) -> UILabel {
    
    let retweetLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 15))
    retweetLabel.center = CGPoint(x: 175, y: 10)
    retweetLabel.textAlignment = .center
    retweetLabel.adjustsFontSizeToFitWidth = true
    retweetLabel.adjustsFontForContentSizeCategory = true
    retweetLabel.textColor = UIColor(red:0.12, green:0.51, blue:0.59, alpha:1.0) // hex#1F8396
    retweetLabel.text = count
    
    return retweetLabel
    
  }
  
  
  func addSaveButtonToHeader(tweet: Tweet) -> UIButton {
    
    saveButton = UIButton()
    
    if (tweet.favorited)! {
      saveButton?.setImage(#imageLiteral(resourceName: "unsave_red24"), for: .normal)
    } else if (tweet.favorited == false) {
      saveButton?.setImage(#imageLiteral(resourceName: "save24"), for: .normal)
    }
    saveButton?.isEnabled = true
    saveButton?.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
    saveButton?.center = CGPoint(x: 300, y: 10)
    saveButton?.addTarget(self, action: #selector(onSave), for: UIControlEvents.touchUpInside)
   // saveButton?.tag = 1
    
    return saveButton!
  }
  
  func addSaveLabelToHeader(count: String) -> UILabel {
    
    saveCountLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 15))
    saveCountLabel?.center = CGPoint(x: 325, y: 10)
    saveCountLabel?.textAlignment = .center
    saveCountLabel?.adjustsFontSizeToFitWidth = true
    saveCountLabel?.adjustsFontForContentSizeCategory = true
    saveCountLabel?.textColor = UIColor(red:0.12, green:0.51, blue:0.59, alpha:1.0) // hex#1F8396
    saveCountLabel?.text = count
    
    return saveCountLabel!

  }
 
 
 */
  
  // MARK: - ScrollView & Refresh Control 
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {

    if (!isMoreDataLoading) {
      
      /// Calculate the position of one screen length before the bottom of the results 
      let scrollViewContentHeight = tableView.contentSize.height
      let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
      
      // When the user has scrolled past the threshold, start requesting 
      if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
        isMoreDataLoading = true
        
        // Update position of loadingMOreView, and start loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView?.frame = frame
        loadingMoreView!.startAnimating()
        
        // code to load more results
        loadMoreData()
      }
    }
  }
  
  func refreshControlAction(_ refreshControl: UIRefreshControl) {
    
    let refreshURL = URL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
    var request = URLRequest(url: refreshURL!)
    request.httpMethod = "get"
    
    //let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    //let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in

    let session = URLSession.shared
    
    session.dataTask(with: request) {data, response, Error in
      // update data
      print("Refreshing the data")
      
      // reload tableview
      self.tableView.reloadData()
      
      // tell the refresh control to stop spinning
      refreshControl.endRefreshing()
      
      
      }.resume()
  }
  
  // MARK: - Logout
  
  
  @IBAction func logout(_ sender: UIBarButtonItem) {
      TwitterClient.sharedInstance.logout()
  }
  
  // MARK: - Network Call
  
  func makeNetworkCall() {
    
    // Getting the tweets via the API
    TwitterClient.sharedInstance.homeTimeline(success: { (tweets: [Tweet]) -> () in
      self.tweets = tweets
      
      for tweet in tweets {
        print("tweet: \(tweet.text!)")
        print("1. retweeted: \(tweet.retweeted!)")
        print("2. favorited: \(tweet.favorited!)")
        print("3. idStr: \(tweet.idStr!)")
        print("4. id: \(tweet.id!)")
        
        if let retweetedStatus = tweet.retweetedStatus {
          let retweet = Tweet.tweetAsDictionary(tweet.retweetedStatus!)
          let originalID = retweet.idStr
          print("5. Retweet: \(originalID!)")
        } else {
          print("5. not a retweet")
        }
        
        if tweet.currentUserRetweet != nil {
          print("6. currentUserRetweet:\(tweet.currentUserRetweet!)")
        }
        
        print("7. Fav Count: \(tweet.favoritesCount!)")
        
        self.tableView.reloadData()
      }
      
    }, failure: { (error: Error) -> () in
      print("Error: \(error.localizedDescription)")
    })
  }
  
  func loadMoreData() {
    
    let loadMoreURL = URL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
    var request = URLRequest(url: loadMoreURL!)
    request.httpMethod = "get"
    
    let session = URLSession.shared
    
    session.dataTask(with: request) {data, response, Error in
      print("Entered the completion handler")
      
      
    }.resume()
  }
  
// MARK: - SAVING & UNSAVING AS FAVORITE 
  
 @IBAction func onSave(_ sender: UIButton!) {

      let buttonTag = (self.saveButton?.tag)!
  
      tweet = tweets?[buttonTag]
  
      TwitterClient.sharedInstance.createFav(params: ["id": tweet!.idStr!], success: { (tweet) -> () in
      
          print("Saving TweetID: \(tweet!.idStr!) to favorites. New Status is: \(tweet!.favorited!).  FavCount is: \(tweet!.favoritesCount!)")
        
        }, failure: { (error: Error) -> () in
          print("Could not successfully save tweet.  Error: \(error.localizedDescription)")
      })
  
      tableView.reloadData()
    }
  
  
  func unSaveAsFavorite() {
    
    TwitterClient.sharedInstance.unSaveAsFavorite(params: ["id": tweetID!], success: { (tweet) -> () in
      
      print("Removing from favorites")

      print("Status after unsaving: \(tweet!.favorited!)")
      self.saveCountLabel?.textColor = UIColor(red:0.12, green:0.51, blue:0.59, alpha:1.0)
      self.saveButton?.setImage(#imageLiteral(resourceName: "save24"), for: .normal)
      self.tableView.reloadData()
    }, failure: { (error: Error) -> () in
      print("Error: \(error.localizedDescription)")
    })
  }
  
  
  
  
  
    // MARK: - Navigation
  
  @IBAction func onCompose(_ sender: UIBarButtonItem) {
    print("Going to compose a tweet")
    performSegue(withIdentifier: "Compose", sender: self)
  }
  
  func callSegueFromCell(myData dataobject: User) {
    
    let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileView") as! ProfileViewController
    let userToSend = dataobject
    profileVC.user = userToSend
    self.navigationController?.pushViewController(profileVC, animated: true)
  }
  
  
  
 //  func goToProfileView() {
    
   // self.performSegue(withIdentifier: "ProfileView", sender: dataobject)
 // }
  
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
      print("prepare for segue called")
      
      if segue.identifier == "TweetDetail" {
        

//        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
  //      let tweet = tweets?[indexPath.row]
    //    cell.tweet = tweet
      
        let cell = sender as! TweetCell
      //  let indexPath = tableView.indexPath(for: cell)
      //  let tweet = tweets?[(indexPath?.row)!]
        
        let sendingTweet = cell.tweet
        
        print("Tweet text: \(sendingTweet!.text!)")
        
        let detailVc = segue.destination as! TweetDetailsViewController
        detailVc.tweet = sendingTweet
        detailVc.tweets = tweets
    
      
       /*
        if segue.identifier == "ProfileView" {

          let profileUser = sender as! User!
          let profileVc = segue.destination as! ProfileViewController
          profileVc.user = profileUser
            
        }
 
 */
         
            //
          
         //  let cell = sender as! TweetCell
        //  let sendingTweet = cell.tweet
      
          
//          print("Tweet text: \(sendingTweet!.text!)")
          
       //   profileVc.tweets = tweets
       //   profileVc.tweet.user = sendingTweet?.user
          
       // }
        
        if segue.identifier == "Compose" {
          
          let composeVc = segue.destination as! ComposeViewController
          
        }
        
        
        
      }
      
    }


  

  }
