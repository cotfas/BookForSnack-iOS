//
//  RedesignedTableViewController.swift
//  BookForSnack
//
//  Created by WORK on 04/01/2018.
//  Copyright © 2018 WORK. All rights reserved.
//

import UIKit

import CoreData


class RedesignedTableViewController: UITableViewController, IDataHelper {
   
    var dataHelper: DataHelper! = DataHelper()
    var restaurants: [Restaurant] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Restoring the color of the navigation bar back to normal
        //Utils.restoreNavBarBackgroundColor(navigationController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Data init
        //restaurants = DummyData.initDataForRestaurants()
        dataHelper.setup(self)
        
        // Removing tableView divider
        Utils.tableViewRemoveBottomDivider(tableView)
        
        // For iOS11 Setting up the large title
        //Utils.largeTitle(navigationController)
        
        // Configure navigation bar appearance
        //Utils.configureNavBarAppearance(navigationController)
        
        // Changing navigation bar title
        //Utils.changeNavTitle(navigationController, "d")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func getTableView() -> UITableView {
        return tableView
    }
    
    func updateData(_ array: [Restaurant]) {
        restaurants = array
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellIdentifider = "RedesignedViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifider, for: indexPath) as! RedesignedViewCell
        
        let indexPos = indexPath.row
        
        
        let text = restaurants[indexPos].getRestaurantName()
        let location = restaurants[indexPos].getRestaurantLocation()
        let type = restaurants[indexPos].getRestaurantType()
        let image = restaurants[indexPos].getRestaurantImage()
        
        
        cell.titleLabel?.text = text
        cell.subTitleLabel?.text = type
        cell.locationLabel?.text = location
        cell.imageViewFull?.image = UIImage(data: image!)
        
        // Disabling click selector
        Utils.tableViewDisableClickSelector(tableView, cell)
        
        return cell
    }
    
    // Send data to the next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let identifier = "showRedesignedDetail"
        if segue.identifier == identifier {
            
            let indexPath = tableView.indexPathForSelectedRow
            
            if indexPath != nil {
                let indexPos = indexPath!.row
                
                let detail = segue.destination as! RedesignedDetailViewController
                
                detail.restaurant = restaurants[indexPos]
                
                // Hide bottom tab bar programatically if needed
                // From storyboard - enable "Hide bottom bar on push"
                detail.hidesBottomBarWhenPushed = false
            }
        }
    }
}
