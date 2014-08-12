//
//  ViewController.swift
//  classRoster
//
//  Created by William Richman on 8/7/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        populateRoster()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func populateRoster() {
        let path = NSBundle.mainBundle().pathForResource("ClassList", ofType: "plist")
        let PLArray = NSArray(contentsOfFile: path) as Array
        var classRoster = [] as Array
        for classMember in PLArray {
            var firstName = classMember[0] as String
            var lastName = classMember[1] as String
            var newPerson = Person(firstName: firstName, lastName: lastName)
            println("\(newPerson.fullName())")
            classRoster.append(newPerson)
        }
    }
}

