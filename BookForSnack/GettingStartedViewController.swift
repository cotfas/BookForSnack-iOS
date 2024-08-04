//
//  GettingStartedViewController.swift
//  BookForSnack
//
//  Created by WORK on 22/02/2018.
//  Copyright © 2018 WORK. All rights reserved.
//

import UIKit

class GettingStartedViewController : UIViewController {
    
    @IBOutlet var pageControl : UIPageControl!
    @IBOutlet var nextButton : UIButton! {
        didSet {
            nextButton.layer.cornerRadius = 25.0
            nextButton.layer.masksToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
