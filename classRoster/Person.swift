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
    var firstName : String = "Default"
    var lastName : String = "Person"
    var role : String = "Student"
    var gitHubUserName : String?
    var image : UIImage?
    var profileImage : UIImage?
    
//    init (firstName: String, lastName: String, role : String) {
//        self.firstName = firstName
//        self.lastName = lastName
//        self.role = role
//        super.init()
//    }
    
    required init (coder aDecoder: NSCoder!) {
        self.firstName = aDecoder.decodeObjectForKey("firstName") as String
        self.lastName = aDecoder.decodeObjectForKey("lastName") as String
        self.role = aDecoder.decodeObjectForKey("role") as String
        if self.gitHubUserName != nil {
            self.gitHubUserName? = aDecoder.decodeObjectForKey("gitHubUserName") as String
        }
        if self.image != nil {
            self.image? = aDecoder.decodeObjectForKey("image") as UIImage!
        }
        if self.profileImage != nil {
            self.profileImage? = aDecoder.decodeObjectForKey("profileImage") as UIImage!
        }
    }
    
    override init() {
    
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(self.firstName, forKey: "firstName")
        aCoder.encodeObject(self.lastName, forKey: "lastName")
        aCoder.encodeObject(self.role, forKey: "role")
        aCoder.encodeObject(self.gitHubUserName, forKey: "gitHubUserName")
        aCoder.encodeObject(self.image?, forKey: "image")
        aCoder.encodeObject(self.profileImage?, forKey: "profileImage")
    }
    
    func fullName() -> String {
        return "\(self.firstName) \(self.lastName)"
    }
    
}