//
//  RedesignedDetailTable.swift
//  BookForSnack
//
//  Created by WORK on 16/01/2018.
//  Copyright © 2018 WORK. All rights reserved.
//

import Foundation
import UIKit


class RedesignedDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    
    @IBOutlet var tableView : UITableView!;
    @IBOutlet var tableViewHeader : RedesignedDetailViewHeader!;
    
    var restaurant : Restaurant!;
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure navigation bar appearance
        Utils.configureNavBarAppearance(navigationController, self.tableView)
        
        //Utils.hideNavBarTitle(navigationController)
        //Utils.changeNavTitle(navigationController, "New Title")
        Utils.hideNavBarBackButtonTitle(navigationController)
        
        
        // WORKS - Hidding the title - Needed to clear the text in the back navigation
        //self.navigationItem.title = " "
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Restoring the color of the navigation bar back to normal
        Utils.restoreNavBarBackgroundColor(navigationController)
        
        // WORKS - Hidding the title - Needed to clear the text in the back navigation
        //self.navigationItem.title = "Old title"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let name = restaurant.getRestaurantName()
        let location = restaurant.getRestaurantLocation()
        let image = restaurant.getRestaurantImage()
    
        tableViewHeader.titleLabel?.text = name
        tableViewHeader.subTitleLabel?.text = location
        tableViewHeader.imageViewFull?.image = UIImage(data: image!)
        tableViewHeader.imageViewHeart?.isHidden = !restaurant.isRestaurantVisited()
        
        // Link the tableView with the current methods
        tableView.dataSource = self
        tableView.delegate = self
        
        // Remove tableView separator
        Utils.tableViewRemoveAllSeparators(tableView)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    // MARK: - UITableViewDataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let indexPos = indexPath.row
        
        switch indexPos {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RedesignedDetailViewCellFirst.self), for: indexPath) as! RedesignedDetailViewCellFirst
                
                cell.titleLabel.text = restaurant.getRestaurantPhone()
                cell.imageViewIcon.image = UIImage(named: "phone")
                
                Utils.tableViewDisableClickSelector(tableView, cell)
                
                return cell
            
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RedesignedDetailViewCellFirst.self), for: indexPath) as! RedesignedDetailViewCellFirst
                
                cell.titleLabel.text = restaurant.getRestaurantLocation()
                cell.imageViewIcon.image = UIImage(named: "map")
                
                Utils.tableViewDisableClickSelector(tableView, cell)
                
                return cell
            
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RedesignedDetailViewCellSecond.self), for: indexPath) as! RedesignedDetailViewCellSecond
                
                cell.titleLabel.text = restaurant.getRestaurantType()
                
                Utils.tableViewDisableClickSelector(tableView, cell)
                
                return cell
            
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RedesignedDetailViewCellSeparator.self), for: indexPath) as! RedesignedDetailViewCellSeparator
                
                Utils.tableViewDisableClickSelector(tableView, cell)
                
                return cell
            
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RedesignedDetailViewCellMap.self), for: indexPath) as! RedesignedDetailViewCellMap
                
                cell.configure(restaurant)
                
                Utils.tableViewDisableClickSelector(tableView, cell)
                
                return cell
            
            default:
                // Adding default to avoid "switch must be exhausive"
                fatalError("error")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPos = indexPath.row
        
        if (indexPos == 3) {
            performSegue(withIdentifier: "showMapDetail", sender: self)
        }
    }
    
    // Send data to next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Map screen
        let identifierMap = "showMapDetail"
        
        if identifierMap == segue.identifier {
            let screen = segue.destination as! MapViewController
            screen.restaurant = restaurant
        }
    }
}
