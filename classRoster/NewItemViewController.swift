//
//  NewItemViewController.swift
//  classRoster
//
//  Created by William Richman on 8/18/14.
//  Copyright (c) 2014 Will Richman. All rights reserved.
//

import UIKit

class NewItemViewController: UIViewController {

    @IBOutlet weak var newPersonImage: UIImageView!
    @IBOutlet weak var backToTableView: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillLayoutSubviews() {
        self.newPersonImage.layer.cornerRadius = self.newPersonImage.frame.width / 2
        self.newPersonImage.clipsToBounds = true
    }
}
