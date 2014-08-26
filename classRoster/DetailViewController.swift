//
//  detailViewController.swift
//  classRoster
//
//  Created by William Richman on 8/13/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import UIKit
import MobileCoreServices

class DetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var detailImage: UIImageView!
    var personDisplayed : Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstName.delegate = self
        self.lastName.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        self.firstName.text = self.personDisplayed?.firstName
        self.lastName.text = self.personDisplayed?.lastName
        /* If personDisplayed has an image, display it.  Otherwise photo stays as default. */
        if let image = personDisplayed?.image {
            self.detailImage.image = image
        }
        self.detailImage.layer.cornerRadius = self.detailImage.frame.width / 2
        self.detailImage.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        self.detailImage.layer.cornerRadius = self.detailImage.frame.width / 2
        self.detailImage.clipsToBounds = true
    }
    
    
    //MARK: - UITextFieldDelegate
    
    func textFieldDidEndEditing(textField: UITextField!) {
        self.personDisplayed?.firstName = self.firstName.text
        self.personDisplayed?.lastName = self.lastName.text
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - UIImagePickerControllerDelegate
    
    @IBAction func capture(sender : UIButton) {
        
        /* Check if Camera is available on device.  If not, give user option to use Photo Library */
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
            
        else {
            var alert = UIAlertController(title: "Alert", message: "This device does not have a supported camera.", preferredStyle: UIAlertControllerStyle.ActionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            /* Go to Photo Library instead of Camera*/
            alert.addAction(UIAlertAction(title: "Use Photo Library", style: UIAlertActionStyle.Default){
                    (action) in
                    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
                        var imagePicker = UIImagePickerController()
                        imagePicker.delegate = self
                        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                        imagePicker.allowsEditing = true
                        self.presentViewController(imagePicker, animated: true, completion: nil)
                    }
                })
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        //this gets fired when the image picker is done
        var editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        self.personDisplayed?.image = editedImage
        self.detailImage.image = editedImage
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        //this gets fired when the user cancels out of the process
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

}
