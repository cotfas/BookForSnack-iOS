//
//  GettingStartedPageViewController.swift
//  BookForSnack
//
//  Created by WORK on 6/7/17.
//  Copyright © 2017 WORK. All rights reserved.
//

import UIKit

class GettingStartedPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    
    var pageHeadings = [NSLocalizedString("Personalize", comment: "Personalize"), NSLocalizedString("Locate", comment: "Locate"), NSLocalizedString("Discover", comment: "Discover")]
    
    var pageImages = ["foodpin-intro-1", "foodpin-intro-2", "foodpin-intro-3"]
    
    var pageContent = [NSLocalizedString("Pin your favorite restaurants and create your own food guide", comment: "Pin your favorite restaurants and create your own food guide"), NSLocalizedString("Search and locate your favourite restaurant on Maps", comment: "Search and locate your favourite restaurant on Maps"), NSLocalizedString("Find restaurants pinned by your friends and other foodies around the world", comment: "Find restaurants pinned by your friends and other foodies around the world")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initialise()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Init
    func initialise() {
        
        // Set the data source to itself
        dataSource = self
        
        // Create the first walkthrough screen
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward,
                               animated: true, completion: nil)
        }
    }
    
    
    /*
        Implement ViewPager methods
    */
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        // Get next
        var index: Int = (viewController as! GettingStartedContentViewController).pageIndex
        index = index + 1
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        // Get before
        var index: Int = (viewController as! GettingStartedContentViewController).pageIndex
        index = index - 1
        return contentViewController(at: index)
    }
    // End of definition
    
    
    
    // Helper method to create view controller
    func contentViewController(at index: Int) -> GettingStartedContentViewController? {
        if index < 0 || index >= pageHeadings.count {
            return nil
        }
        // Create a new view controller and pass suitable data.
        if let pageContentViewController =
            storyboard?.instantiateViewController(withIdentifier:
                "gettingStartedContentViewController") as? GettingStartedContentViewController {
            pageContentViewController.pageImagePath = pageImages[index]
            pageContentViewController.pageTitle = pageHeadings[index]
            pageContentViewController.pageDescription = pageContent[index]
            pageContentViewController.pageIndex = index
            return pageContentViewController
        }
        return nil
    }
    // End of helper
    
    
    
    /*
        Enable View pager dots (default)
    */
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageHeadings.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let pageContentViewController =
            storyboard?.instantiateViewController(withIdentifier:
                "gettingStartedContentViewController") as? GettingStartedContentViewController {
            
            if let index = pageContentViewController.pageIndex {
                return index
            }
        }
        return 0
    }
    // End of dots
    
    
    // Go next screen
    func forward(index: Int) {
        if let nextViewController = contentViewController(at: index + 1) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
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
