//
//  HomeViewController.swift
//  Instagram
//
//  Created by Chandler Griffin on 2/20/17.
//  Copyright © 2017 Chandler Griffin. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var posts: [PFObject] = []
    var endpoint: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeNavigationController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! UINavigationController
        let homeViewController = homeNavigationController.topViewController as! HomeViewController
        homeViewController.endpoint = "home"
        homeNavigationController.tabBarItem.title = "Home"
        homeNavigationController.tabBarItem.image = UIImage(named: "home")?.stretchableImage(withLeftCapWidth: 30, topCapHeight: 30)
        
        let captureNavigationController = storyboard.instantiateViewController(withIdentifier: "CaptureViewController") as! UINavigationController
        let captureViewController = captureNavigationController.topViewController as! CaptureViewController
        captureViewController.endpoint = "capture"
        captureNavigationController.tabBarItem.title = "Capture"
        captureNavigationController.tabBarItem.image = UIImage(named: "capture")?.stretchableImage(withLeftCapWidth: 30, topCapHeight: 30)
        
        let profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! UINavigationController
        let profileViewController = profileNavigationController.topViewController as! ProfileViewController
        profileViewController.endpoint = "profile"
        profileNavigationController.tabBarItem.title = "Profile"
        profileNavigationController.tabBarItem.image = UIImage(named: "profile")?.stretchableImage(withLeftCapWidth: 30, topCapHeight: 30)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeNavigationController, captureNavigationController, profileNavigationController]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayMessage(message: "Fetching Posts...")
        delay(delay: 2, closure: {
            self.refreshTimeline()
        }, withCompletion: {
            self.endHUD()
        })
    }
    
    func refreshTimeline(){
        queryPosts()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "instaCell", for: indexPath) as! InstaCell
        
        let post = self.posts[indexPath.row]
        print(post)
        let user = post["author"] as! PFObject
        
        if let file = user["profile_pic"]   {
            (file as AnyObject).getDataInBackground(block: { (imageData: Data?, error: Error?) in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                    cell.profileImageView.image = image
                    }
                }
            })
            cell.usernameLabel.text = user["username"] as! String?

            cell.showUser(exists: true)
        }   else    {
            cell.showUser(exists: false)
        }
        
        cell.postLabel.text = post["caption"] as! String?
        
        let pictureFile = post["media"]
        
        (pictureFile as AnyObject).getDataInBackground(block: { (imageData: Data?, error: Error?) in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    cell.capturedImageView.image = image
                }
            }
        })
        return cell
    }
    
    @IBAction func logout(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func queryPosts() {
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                self.posts = posts
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func displayMessage(message: String?)   {
        //Start Loading with MBProgressHUD
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = message!
    }
    
    func delay(delay:Double, closure:@escaping ()->(), withCompletion completion: @escaping ()->())    {
        let mainQueue = DispatchQueue.main
        let deadline = DispatchTime.now() + delay
        mainQueue.asyncAfter(deadline: deadline){
            closure()
            completion()
        }
    }
    
    func endHUD()   {
        MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
