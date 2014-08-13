//
//  ViewController.swift
//  classRoster
//
//  Created by William Richman on 8/7/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var classRoster = [] as Array
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        populateRoster()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.classRoster.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        //get my cell
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        //configure it for the row
        var personForRow =  self.classRoster[indexPath.row] as Person
        cell.textLabel.text = personForRow.fullName()
        //return the cell
        return cell
    }
    
//    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
//        return 3
//    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println(indexPath.row)
    }
    
    func populateRoster() {
        let path = NSBundle.mainBundle().pathForResource("ClassList", ofType: "plist")
        let PLArray = NSArray(contentsOfFile: path) as Array
        for classMember in PLArray {
            var firstName = classMember[0] as String
            var lastName = classMember[1] as String
            var newPerson = Person(firstName: firstName, lastName: lastName)
            self.classRoster.append(newPerson)
        }
    }
}

