//
//  detailViewController.swift
//  classRoster
//
//  Created by William Richman on 8/13/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    var personDisplayed : Person?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        self.firstName.text = self.personDisplayed?.firstName
        self.lastName.text = self.personDisplayed?.lastName
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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