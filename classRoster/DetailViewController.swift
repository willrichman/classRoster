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
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        self.firstName.text = self.personDisplayed?.firstName
        self.lastName.text = self.personDisplayed?.lastName
        if let image = personDisplayed?.image {
            self.detailImage.image = image
        }
            
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidEndEditing(textField: UITextField!) {
        self.personDisplayed?.firstName = self.firstName.text
        self.personDisplayed?.lastName = self.lastName.text
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func capture(sender : UIButton) {
        println("Button capture")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)

        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        //this gets fired when the image picker is done
        var editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        self.personDisplayed?.image = editedImage
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        //this gets fired when the user cancels out of the process
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}
