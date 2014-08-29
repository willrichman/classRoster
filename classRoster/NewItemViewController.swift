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

class NewItemViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var rolePickerButton: UISegmentedControl!
    @IBOutlet weak var newFirstNameText: UITextField!
    @IBOutlet weak var newPersonImage: UIImageView!
    @IBOutlet weak var newLastNameText: UITextField!
    @IBOutlet weak var backToTableView: UINavigationItem!
    @IBOutlet weak var newGitHubProfileImage: UIImageView!
    @IBOutlet weak var newGitHubUsername: UITextField!
    
    var newPerson = Person()
    var newFirstName = "default"
    var newLastName = "default"
    var newRole = "Student"
    var delegate: NewItemViewControllerDelegate?
    var imageDownloadQueue = NSOperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newFirstNameText.delegate = self
        self.newLastNameText.delegate = self
        self.newGitHubUsername.delegate = self
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
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
                    var imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
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
        self.newPerson.image = editedImage
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        //this gets fired when the user cancels out of the process
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Navigation
    @IBAction func getGitHubButton(sender: AnyObject) {
        weak var wself: NewItemViewController? = self
        /* If the text box does not have a git hub name in it, show alert */
        if self.newGitHubUsername.text == "" {
            /* Create and display an AlertController that will prompt for the user name, then return it and save it to the current Person's gitHubUserName property.  Will then contact GitHub API and download/display the photo. */
            var alertTextField : UITextField = UITextField()
            var gitHubPrompt = UIAlertController(title: "GitHub", message: "What is this person's GitHub user name?", preferredStyle: UIAlertControllerStyle.Alert)
            gitHubPrompt.addAction(UIAlertAction(title: "Enter", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                if let sself = wself {
                    println(alertTextField.text)
                    sself.newPerson.gitHubUserName = alertTextField.text as String
                    sself.newGitHubUsername.text = sself.newPerson.gitHubUserName
                    let userName = sself.newPerson.gitHubUserName
                    println(userName)
                    sself.getGitHubProfilePicture(userName!)
                }
                })
            
            gitHubPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            gitHubPrompt.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                textField.placeholder = "Username"
                alertTextField = textField
            })
            self.presentViewController(gitHubPrompt, animated: true, completion: nil)
        }
        else {
            self.getGitHubProfilePicture(self.newGitHubUsername.text)
        }
    }
    
    func getGitHubProfilePicture(userNameBeingDownloaded: String) -> Void {
        let githubURL = NSURL(string: "https://api.github.com/users/\(userNameBeingDownloaded)")
        var profilePhotoURL = NSURL()
        self.imageDownloadQueue.addOperationWithBlock { () -> Void in
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(githubURL, completionHandler: { (data, response, error) -> Void in
                println("Task completed")
                if error != nil {
                    // If there is an error in the web request, print to console
                    println(error.localizedDescription)
                }
                var err: NSError?
                
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                if err != nil {
                    // If there is an error parsing JSON, print it to the console
                    println("JSON Error \(err!.localizedDescription)")
                }
                if let avatarURL = jsonResult["avatar_url"] as? String {
                    println("AvatarURL = " + avatarURL)
                    profilePhotoURL = NSURL(string: avatarURL)
                }
                var profilePhotoData = NSData(contentsOfURL: profilePhotoURL)
                var profilePhotoImage = UIImage(data: profilePhotoData)
                // Switch to main queue to update UI
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    println("Main queue block run")
                    self.newGitHubProfileImage.image = profilePhotoImage as UIImage
                    self.newPerson.profileImage = profilePhotoImage as UIImage
                    self.newPersonImage.image = profilePhotoImage as UIImage
                    self.newPerson.image = profilePhotoImage as UIImage
                })
            })
            task.resume()
        }
    }

    @IBAction func addPersonButton(sender: AnyObject) {
        /* Set the new person's properties to the properties set in this controller */
        self.newPerson.firstName = self.newFirstNameText.text
        self.newPerson.lastName = self.newLastNameText.text
        self.newPerson.gitHubUserName = self.newGitHubUsername.text
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

