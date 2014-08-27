//
//  ViewController.swift
//  classRoster
//
//  Created by William Richman on 8/7/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NewItemViewControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var classRoster = [[Person](), [Person]()] as Array
    let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        if let savedRoster = NSKeyedUnarchiver.unarchiveObjectWithFile(documentsPath + "/rosterArchive") as? [AnyObject] {
            println("Block 1")
            classRoster = savedRoster as [[Person]]
        }
        else {
            println("Block 2")
            self.populateRoster()
        }
        NSKeyedArchiver.archiveRootObject(classRoster, toFile: documentsPath + "/rosterArchive")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData()
//        classRoster = NSKeyedUnarchiver.unarchiveObjectWithFile(documentsPath + "/rosterArchive") as Array
    }

    override func viewDidDisappear(animated: Bool) {
        //NSKeyedArchiver.archiveRootObject(classRoster, toFile: documentsPath + "/rosterArchive")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.classRoster[section].count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        //get my cell
        let cell = tableView!.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        //configure it for the row
        var personForRow =  self.classRoster[indexPath.section][indexPath.row] as Person
        cell.textLabel.text = personForRow.fullName()
        //return the cell
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 2
    }

    /* Set labels for the two sections of the table */
    func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {

        if section == 0 {
            return "Students"
        }
        else if section == 1 {
            return "Teachers"
        }
        else {
            return "Test"
        }
    }
    
    /* Send the selected Person object to DetailViewController */
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "detailSegue" {
            var destination = segue.destinationViewController as DetailViewController
            var indexPath = tableView.indexPathForSelectedRow()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            var personForText = self.classRoster[indexPath.section][indexPath.row] as Person
            destination.personDisplayed = personForText
        }
        else if segue.identifier == "addPersonButton" {
            var destination = segue.destinationViewController as NewItemViewController
            destination.delegate = self
        }
    }
    
    /* Populate the classRoster array with the two subarrays */
    
    func populateRoster() {
        let path = NSBundle.mainBundle().pathForResource("ClassList", ofType: "plist")
        let PLArray = NSArray(contentsOfFile: path) as Array
        for classMember in PLArray {
            var firstName = classMember[0] as String
            var lastName = classMember[1] as String
            var role = classMember[2] as String
            var newPerson = Person()
            newPerson.firstName = firstName
            newPerson.lastName = lastName
            newPerson.role = role
            if role == "Teacher" {
                self.classRoster[1].append(newPerson)
            }
            else {
                self.classRoster[0].append(newPerson)
            }
        }
    }
    
    // MARK: - NewItemViewControllerDelegate
    
    func didFinishCreatingNewPerson(controller: NewItemViewController, newCreatedPerson: Person) {
        if newCreatedPerson.role == "Student" {
            self.classRoster[0].append(newCreatedPerson)
        }
        else {
            self.classRoster[1].append(newCreatedPerson)
        }
        controller.navigationController.popViewControllerAnimated(true)
    }

}