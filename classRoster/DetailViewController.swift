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
    @IBOutlet weak var gitHubUserNameText: UITextField!
    @IBOutlet weak var displayedProfileImage: UIImageView!
    var personDisplayed : Person?
    var imageDownloadQueue = NSOperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstName.delegate = self
        self.lastName.delegate = self
        self.gitHubUserNameText.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        self.firstName.text = self.personDisplayed?.firstName
        self.lastName.text = self.personDisplayed?.lastName
        if let gitHubUserName = self.personDisplayed?.gitHubUserName {
            self.gitHubUserNameText.text = gitHubUserName
        }
        
        /* If personDisplayed has an image, display it.  Otherwise photo stays as default. */
        if let image = personDisplayed?.image {
            self.detailImage.image = image
        }
        if let image = personDisplayed?.profileImage {
            self.displayedProfileImage.image = image
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
        if self.gitHubUserNameText.text != "" {
            self.personDisplayed?.gitHubUserName = self.gitHubUserNameText.text
        }
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

    @IBAction func getGitHubButton(sender: AnyObject) {
        weak var wself: DetailViewController? = self
        /* If the current person does not have a gitHub username saved, show alert */
        if self.personDisplayed?.gitHubUserName == nil {
            /* Create and display an AlertController that will prompt for the user name, then return it and save it to the current Person's gitHubUserName property.  Will then contact GitHub API and download/display the photo. */
            var alertTextField : UITextField = UITextField()
            var gitHubPrompt = UIAlertController(title: "GitHub", message: "What is this person's GitHub user name?", preferredStyle: UIAlertControllerStyle.Alert)
            gitHubPrompt.addAction(UIAlertAction(title: "Enter", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                if let sself = wself {
                    println(alertTextField.text)
                    sself.personDisplayed?.gitHubUserName = alertTextField.text as String
                    sself.gitHubUserNameText.text = sself.personDisplayed?.gitHubUserName
                    let userName = sself.personDisplayed?.gitHubUserName
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
                    self.displayedProfileImage.image = profilePhotoImage as UIImage
                    self.personDisplayed?.profileImage = profilePhotoImage as UIImage
                    self.detailImage.image = profilePhotoImage as UIImage
                    self.personDisplayed?.image = profilePhotoImage as UIImage
                })
            })
            task.resume()
        }
    }
}
