//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Chandler Griffin on 2/26/17.
//  Copyright © 2017 Chandler Griffin. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var profilePictureImageView: UIImageView!
    var endpoint: String?
    var user = PFUser.current()
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadImage()
    }
    
    func loadImage()    {
        if let file = user?["profile_pic"]  {
            (file as AnyObject).getDataInBackground(block: { (imageData: Data?, error: Error?) in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        self.profilePictureImageView.image = image
                    }
                }
            })
            
            self.profilePictureImageView.layer.cornerRadius = 100
            self.profilePictureImageView.clipsToBounds = true
        }
        usernameLabel.text = user?.username!
    }
    
    @IBAction func onTapProfileImage(_ sender: Any) {
        presentPhotoPicker(sender)
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func presentPhotoPicker(_ sender: Any) {
        let photoLibrary = UIImagePickerController()
        photoLibrary.delegate = self
        photoLibrary.allowsEditing = true
        photoLibrary.sourceType = UIImagePickerControllerSourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            if let mediaTypes = UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.photoLibrary){
                photoLibrary.mediaTypes = mediaTypes
                photoLibrary.delegate = self
                self.present(photoLibrary, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        profilePictureImageView.image = resize(image: editedImage, newSize: profilePictureImageView.frame.size)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true) { 
            self.onPost()
        }
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func onPost() {
        let image = profilePictureImageView.image!
        self.updateProfileImage(image: image, withCompletion: nil)
        loadImage()
    }
    
    /**
     Method to add a user post to Parse (uploading image file)
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    func updateProfileImage(image: UIImage?,withCompletion completion: PFBooleanResultBlock?) {
        // Add relevant fields to the object
        user?["profile_pic"] = getPFFileFromImage(image: image) // PFFile column type
        
        // Save object (following function will save the object in Parse asynchronously)
        user?.saveInBackground(block: completion)
    }
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "profile.png", data: imageData)
            }
        }
        return nil
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
