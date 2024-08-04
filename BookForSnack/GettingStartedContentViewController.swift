//
//  GettingStartedContentViewController.swift
//  BookForSnack
//
//  Created by WORK on 6/7/17.
//  Copyright © 2017 WORK. All rights reserved.
//

import UIKit

class GettingStartedContentViewController: UIViewController {
    
    /*
        By default, the transition style of the page view controller is set as . This style is perfect for book apps. For walkthrough screens, we prefer to use scrolling style. In the Attributes inspector, change the transition style to .
    */
    
    
    @IBOutlet var pageTitleLabel: UILabel!
    @IBOutlet var pageImageView: UIImageView!
    @IBOutlet var pageDescriptionLabel: UILabel!
    
    @IBOutlet var pageIndictor: UIPageControl!
    
    @IBOutlet var forwardButton: UIButton!
    
    
    
    var pageIndex: Int!
    var pageTitle: String!
    var pageImagePath: String!
    var pageDescription: String!
    
    
    /*
        Button action clicked
    */
    @IBAction func nextButtonClicked(sender: UIButton) {
        if (pageIndex == 0 || pageIndex == 1) {
            
            // Go next screen
            let pageViewController = parent as! GettingStartedPageViewController
            pageViewController.forward(index: pageIndex)
        } else{
            // Done
            dismiss(animated: true, completion: nil)
            
            // Save state to UserDefaults
            AppDelegate.saveGettingStarted(true)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Asign data to UI
        pageTitleLabel.text = pageTitle
        pageImageView.image = UIImage(named: pageImagePath)
        pageDescriptionLabel.text = pageDescription
        
        // Set page indicator
        pageIndictor.currentPage = pageIndex
        
        // Init next button
        switch pageIndex {
        case 0: forwardButton.setTitle(NSLocalizedString("NEXT", comment: "NEXT"), for: .normal)
        case 1: forwardButton.setTitle(NSLocalizedString("NEXT", comment: "NEXT"), for: .normal)
        case 2: forwardButton.setTitle(NSLocalizedString("DONE", comment: "DONE"), for: .normal)
        default: break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
