//
//  Person.swift
//  classRoster
//
//  Created by William Richman on 8/7/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import Foundation
import UIKit

class Person {
    var firstName : String
    var lastName : String
    var image : UIImage?
    
    init (firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    func fullName() -> String {
        return "\(self.firstName) \(self.lastName)"
    }
}