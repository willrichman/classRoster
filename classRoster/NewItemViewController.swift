//
//  NewItemViewController.swift
//  classRoster
//
//  Created by William Richman on 8/18/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import UIKit

protocol NewItemViewControllerDelegate {
    func didFinishCreatingNewPerson(controller: NewItemViewController, newCreatedPerson: Person)
}

class NewItemViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var rolePickerButton: UISegmentedControl!
    @IBOutlet weak var newFirstNameText: UITextField!
    @IBOutlet weak var newPersonImage: UIImageView!
    @IBOutlet weak var newLastNameText: UITextField!
    @IBOutlet weak var backToTableView: UINavigationItem!
    
    var newPerson = Person()
    var newFirstName = "default"
    var newLastName = "default"
    var newRole = "Student"
    var delegate: NewItemViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newFirstNameText.delegate = self
        self.newLastNameText.delegate = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        if let image = newPerson.image {
            self.newPersonImage.image = image
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillLayoutSubviews() {
        self.newPersonImage.layer.cornerRadius = self.newPersonImage.frame.width / 2
        self.newPersonImage.clipsToBounds = true
    }
    
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK: - UIImagePickerControllerDelegate
    
    @IBAction func getNewPicture(sender: AnyObject) {
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
        self.newPersonImage.image = editedImage
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        //this gets fired when the user cancels out of the process
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Navigation
    
    @IBAction func addPersonButton(sender: AnyObject) {
        /* Set the new person's properties to the properties set in this controller */
        self.newPerson.firstName = self.newFirstNameText.text
        self.newPerson.lastName = self.newLastNameText.text
        if rolePickerButton.selectedSegmentIndex == 1 {
            self.newPerson.role = "Teacher"
        }
        else {
            self.newPerson.role = "Student"
        }
        self.newPerson.image = self.newPersonImage.image
        

        if delegate != nil {
            delegate!.didFinishCreatingNewPerson(self, newCreatedPerson: self.newPerson)
        }
    }
}

