//
//  LoginViewController.swift
//  Instagram
//
//  Created by Chandler Griffin on 2/20/17.
//  Copyright © 2017 Chandler Griffin. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var delay: Double = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signIn(_ sender: Any) {
        let username = usernameField.text
        let password = passwordField.text
        
        if username?.characters.count == 0 {
            displayWarning(message: "Username field is empty.")
            return
        } else if password?.characters.count == 0 {
            displayWarning(message: "Password field is empty.")
            return
        }   else    {
            PFUser.logInWithUsername(inBackground: username!, password: password!) { (user: PFUser?, error: Error?) in
                if(user != nil)  {
                    self.displayMessage(message: "Signing in...")
                    self.emptyFields()
                    self.delay(delay: self.delay)   {
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                        self.endHUD()
                    }
                }   else    {
                    print(error?.localizedDescription as Any)
                }
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        let newUser = PFUser()
        
        //User Properties
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        if newUser.username?.characters.count == 0 {
            displayWarning(message: "Username field is empty.")
            return
        } else if newUser.password?.characters.count == 0 {
            displayWarning(message: "Password field is empty.")
            return
        }   else    {
            newUser.signUpInBackground { (success: Bool, error: Error?) in
                if(success) {
                    self.displayMessage(message: "Signing up...")
                    self.emptyFields()
                    self.delay(delay: self.delay)   {
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                        self.endHUD()
                    }
                }   else    {
                    print(error?.localizedDescription as Any)
                }
            }
        }
    }
    
    func emptyFields()  {
        usernameField.text = ""
        passwordField.text = ""
    }
    
    func displayMessage(message: String?)   {
        //Start Loading with MBProgressHUD
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = message!
    }
    
    func displayWarning(message: String?)   {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        
        present(alertController, animated: true) {
            // optional code for what happens after the alert controller has finished presenting
        }
    }
    
    func delay(delay:Double, closure:@escaping ()->())    {
        let mainQueue = DispatchQueue.main
        let deadline = DispatchTime.now() + delay
        mainQueue.asyncAfter(deadline: deadline){
            closure()
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
