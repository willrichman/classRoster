//
//  Person.swift
//  classRoster
//
//  Created by William Richman on 8/7/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import Foundation
import UIKit

class Person: NSObject, NSCoding {
    var firstName : String
    var lastName : String
    var role : String
    var image : UIImage?
    
    init (firstName: String, lastName: String, role : String) {
        self.firstName = firstName
        self.lastName = lastName
        self.role = role
    }
    
    required init (coder aDecoder: NSCoder) {
        self.firstName = aDecoder.decodeObjectForKey("firstName") as String
        self.lastName = aDecoder.decodeObjectForKey("lastName") as String
        self.role = aDecoder.decodeObjectForKey("role") as String
        self.image? = aDecoder.decodeObjectForKey("image") as UIImage
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(firstName, forKey: "firstName")
        aCoder.encodeObject(lastName, forKey: "lastName")
        aCoder.encodeObject(role, forKey: "role")
        aCoder.encodeObject(image?, forKey: "image")
    }
    
    func fullName() -> String {
        return "\(self.firstName) \(self.lastName)"
    }
    
}