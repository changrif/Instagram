//
//  CaptureViewController.swift
//  Instagram
//
//  Created by Chandler Griffin on 2/26/17.
//  Copyright © 2017 Chandler Griffin. All rights reserved.
//

import UIKit

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var endpoint: String?
    var pictureExists = false
    
    @IBOutlet weak var capturedImage: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.pictureExists  {
            self.presentPhotoPicker(self)
        }   else    {
            captionTextField.becomeFirstResponder()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                self.pictureExists = true
                self.present(photoLibrary, animated: true, completion: nil)
            }
        }
        captionTextField.becomeFirstResponder()
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        capturedImage.image = resize(image: editedImage, newSize: capturedImage.frame.size)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
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
    
    @IBAction func onPost(_ sender: Any) {
        let image = capturedImage.image!
        let caption = self.captionTextField.text!
        
        InstaPost.postUserImage(image: image, withCaption: caption) { (success: Bool, error: Error?) in
            self.reset()
            self.tabBarController?.selectedIndex = 0
            self.pictureExists = false
        }
    }
    
    func reset()    {
        capturedImage.image = nil
        captionTextField.text = ""
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
