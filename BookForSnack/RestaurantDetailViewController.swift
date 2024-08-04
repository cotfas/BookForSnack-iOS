//
//  RestaurantDetailViewController.swift
//  BookForSnack
//
//  Created by WORK on 5/8/17.
//  Copyright © 2017 WORK. All rights reserved.
//

import UIKit

import MapKit


class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var restaurantLabelName: UILabel!
    @IBOutlet var restaurantLabelLocation: UILabel!
    @IBOutlet var restaurantLabelPhone: UILabel!
    @IBOutlet var restaurantLabelType: UILabel!
    
    @IBOutlet var mapView: MKMapView!
    
    
    var restaurant: Restaurant?
    

    /*  
        Unwind segue - close view controler to this
     
        And data parsing back
    */
    @IBAction func close(segue: UIStoryboardSegue) {
        print("close")
        
        //dismiss(animated: true, completion: nil)
        
        // Dismiss with animations
        dismiss(animated: true, completion: {
            let scaleTransform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            self.restaurantImageView.transform = scaleTransform
            self.restaurantImageView.alpha = 0
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: [], animations: {
                self.restaurantImageView.transform = .identity
                self.restaurantImageView.alpha = 1
            }, completion: nil)
        })
    }
    
    // Unwind action method
    @IBAction func ratingButtonClicked(segue: UIStoryboardSegue) {
        if let button = segue.identifier {
           
            var rating = ""
            
            switch button {
            case "good":
                rating = "good"
            case "like":
                rating = "like"
            case "dislike":
                rating = "dislike"
            
            default:
                rating = ""
            }
            
            restaurant?.setterRestaurantRating(rating)
            restaurant?.setterRestaurantVisited(true)
            
            // Update tableView UI data
            tableView.reloadData()
            
            // Update database
            //AppDelegate.saveDatabaseContext()
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    // Send data to Review screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Review screen
        let identifier = "showReview"
        
        if identifier == segue.identifier {
            let screen = segue.destination as! ReviewViewController
            screen.image = restaurant?.getRestaurantImage()
        }
    
        // Map screen
        let identifierMap = "showMap"
        
        if identifierMap == segue.identifier {
            let screen = segue.destination as! MapViewController
            screen.restaurant = restaurant
        }
    }
    
    // Called when view is shown
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Enable/disable hideBarsOnSwipe per view controler
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Show image in imageView
        restaurantImageView.image = UIImage(data: restaurant!.getRestaurantImage())
        
        restaurantLabelName.text = restaurant?.getRestaurantName()
        restaurantLabelLocation.text = restaurant?.getRestaurantLocation()
        restaurantLabelType.text = restaurant?.getRestaurantType()
        restaurantLabelPhone.text = restaurant?.getRestaurantPhone()
        
        
        // TableView customize
        Utils.tableViewCustomize(tableView)
        
        // Change navigation back button text
        Utils.changeNavBackButton(navigationController)
        
        // Set title in middle
        title = restaurant?.getRestaurantName()
    
        // Enable tableView auto row height size
        Utils.enableTableViewAutoRow(tableView)
        
    
        // Initialize Gesture Listener used when clicking on map
        let gestureListener = UITapGestureRecognizer(target: self, action: #selector(openMapScreen))
        mapView.addGestureRecognizer(gestureListener)
        
        // Add pin on map
        initPinOnMap()
        
        // Disabling inherited large title from the parent main viewControler
        Utils.largeTitleInheritedDisabled(navigationItem)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellIdentifider = "Cell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifider, for: indexPath) as! RestaurantDetailViewCell
        
        let indexPos = indexPath.row
    
        
        switch indexPos {
        case 0:
            let field = NSLocalizedString("Name", comment: "Name")
            let value = restaurant?.getRestaurantName()
            cell.fieldLabel?.text = field
            cell.valueLabel?.text = value
        case 1:
            let field = NSLocalizedString("Type", comment: "Type")
            let value = restaurant?.getRestaurantType()
            cell.fieldLabel?.text = field
            cell.valueLabel?.text = value
        case 2:
            let field = NSLocalizedString("Location", comment: "Location")
            let value = restaurant?.getRestaurantLocation()
            cell.fieldLabel?.text = field
            cell.valueLabel?.text = value
        case 3:
            let field = NSLocalizedString("Phone", comment: "Phone")
            let value = restaurant?.getRestaurantPhone()
            cell.fieldLabel?.text = field
            cell.valueLabel?.text = value
        case 4:
            let field = NSLocalizedString("Visited", comment: "Visited")
            let value = restaurant?.isRestaurantVisited()
            cell.fieldLabel?.text = field
            cell.valueLabel?.text = value! ? NSLocalizedString("Yes", comment: "Yes") : NSLocalizedString("No", comment: "No")
        default:
            cell.fieldLabel?.text = ""
            cell.valueLabel?.text = ""
        }
        
        // Remove cell color
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    
    // Open the map screen
    @objc func openMapScreen() {
        performSegue(withIdentifier: "showMap", sender: self)
    }
    
    // Show pin on map
    func initPinOnMap() {
        
        restaurant?.initPinOnMap(mapView, false, true)
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
