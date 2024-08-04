//
//  RestaurantTableViewController.swift
//  BookForSnack
//
//  Created by WORK on 5/7/17.
//  Copyright © 2017 WORK. All rights reserved.
//

import UIKit

class RestaurantViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet var emptyView : UIImageView!
    
    let actionSheetEnabled = true
    var restaurants: [Restaurant] = []
    
    // Search functionallity
    var restaurantsHolder:[Restaurant] = []
    var searchResults:[Restaurant] = []
    
    var searchController: UISearchController!
    
    
    
    /*
        Unwind segue - close view controler to this
     */
    @IBAction func uwindToHomeScreen(segue: UIStoryboardSegue) {
        print("uwindToHomeScreen")
        
    }
    
    
    // Hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Update data changes
    private func reloadUI() {
        // Init
        restaurants = DummyData.initDataForRestaurants()
        // Update data changes
        tableView.reloadData() // Updating UI tableView with data
    }
    
    // Called when view is shown
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadUI()
        
        // Enable/disable hideBarsOnSwipe per view controler
        //Utils.hideBarsOnSwipe(navigationController)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        // Init
        restaurants = DummyData.initDataForRestaurants()
        
        // Add search bar to UI
        addingSearchBar()
        
        // Open Getting Started screen
        openGettingStarterViewPager()
        
        // Setting the UI tableView for Tablet as centered
        Utils.setTableViewForTablet(tableView)
        
        // For iOS11 Setting up the large title
        Utils.largeTitle(navigationController)
    
        // Configure navigation bar appearance
        //Utils.configureNavBarAppearance(navigationController)
        
        Utils.tableViewEmptyView(tableView, emptyView, false) // Setup emptyView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        Utils.tableViewEmptyView(tableView, emptyView, (restaurants.count == 0)) // Setup emptyView
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurants.count
    }

    /*
        Initialize childs
    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifider = "Cell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifider, for: indexPath) as! RestaurantViewCell
        
        
        let indexPos = indexPath.row
        
        let text = restaurants[indexPos].getRestaurantName()
        let location = restaurants[indexPos].getRestaurantLocation()
        let type = restaurants[indexPos].getRestaurantType()
        let image = restaurants[indexPos].getRestaurantImage()
        
        
        cell.nameLabel?.text = text
        cell.locationLabel?.text = location
        cell.typeLabel?.text = type
        cell.imageViewThumb?.image = UIImage(data: image!)
        
        // Keep data
        if (restaurants[indexPos].isRestaurantVisited()) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    /*
        Method to detect when will be selected an cell - before selection you can dismiss or override
    */
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
       return indexPath
    }
    
    /*
        Child selected
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !actionSheetEnabled {
            return
        }
        
        
        let indexPos = indexPath.row
        
        
        /*
            Call action
        */
        let callActionCallback = { (action:UIAlertAction!) -> Void in
            let alertMessage = UIAlertController(title: NSLocalizedString("Error", comment: "Error"), message: NSLocalizedString("Please try again tomorrow!", comment: "Please try again tomorrow!"), preferredStyle: UIAlertControllerStyle.alert) // You can also use .alert without UIAlertControllerStyle.
            
            let action = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: UIAlertActionStyle.cancel, handler: nil)
            alertMessage.addAction(action)
            
            // We present the AlertController modally
            self.present(alertMessage, animated: true, completion: nil)
        }
        
        /* 
            Checking action
        */
        let checkinActionCallback = { (action:UIAlertAction!) -> Void in
            self.toggleCheck(tableView, indexPath)
        }
        
        
        // Showing an Alert
        let userMenu = UIAlertController(title: "", message: NSLocalizedString("What you want to do?", comment: "What you want to do?"), preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
        userMenu.addAction(cancelAction)
        
        let callAction = UIAlertAction(title: NSLocalizedString("Call 123-000-\(indexPos)", comment: "Call 123-000-\(indexPos)"), style:
            UIAlertActionStyle.default, handler: callActionCallback)
        userMenu.addAction(callAction)
        
        let text = restaurants[indexPos].isRestaurantVisited() ? NSLocalizedString("Un-Checkin", comment: "Un-Checkin") : NSLocalizedString("Checkin", comment: "Checkin")
        let checkinAction = UIAlertAction(title: text, style:
            UIAlertActionStyle.default, handler: checkinActionCallback)
        userMenu.addAction(checkinAction)
        
        /*
            Case for tablet to avoid crash upon opening the alert (it will be openned as popover)
        */
        if let popoverController = userMenu.popoverPresentationController {
            if let cell = tableView.cellForRow(at: indexPath) {
                popoverController.sourceView = cell
                popoverController.sourceRect = cell.bounds
            }
        }
        // End of definition
        
        // Showing the alert modally
        present(userMenu, animated: true, completion: nil)
        
        // Auto deselect the selected row
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    /*
        Toggling the check for an item
    */
    func toggleCheck(_ tableView: UITableView, _ indexPath: IndexPath) {
        
        let indexPos = indexPath.row
        
        self.restaurants[indexPos].setterRestaurantVisited(!self.restaurants[indexPos].isRestaurantVisited())
        
        if (self.restaurants[indexPos].isRestaurantVisited()) {
            // Setting an checkmark icon (there are 4 = disclosure indicator, detail disclosure button, checkmark and button
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
    
    /*
        Swipe to delete
        This method does not contain more buttons > it will only contain delete button
    */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    
        
        if editingStyle == .delete {
            deleteRow(tableView, indexPath)
        }
        
        /*
            When tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) 
            is overwritten - this implementation does not work
        */
    }
    
    /*
        Swipe to right
    */
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Check action button
        let checkAction = UIContextualAction(style: .normal, title: "Check") {
            (action, sourceView, completitionHandler) in
            
            self.toggleCheck(tableView, indexPath)
            
            // Dismissing the action button (must be called!)
            completitionHandler(true) // true = means the action was performed with success
        }
        
        // Changing the action button color - values needs to be between 0-1 (or use UIColor.red)
        checkAction.backgroundColor = UIColor.green
        // Adding an icon to the action button
        checkAction.image = UIImage(named: "check")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [checkAction])
    
        return swipeConfiguration
        
        //return UISwipeActionsConfiguration(actions: []) // returning empty will disable the feature
    }
    
    /*
        Swipe to left
     */
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Delete action button
        let deleteAction = UIContextualAction(style: .destructive, title: "New Delete") {
            (action, sourceView, completitionHandler) in
            
            // Do the actual remove here
            self.deleteRow(tableView, indexPath)
            
            // Dismissing the action button (must be called!)
            completitionHandler(true) // true = means the action was performed with success
        }
        
        // Share action button
        let shareAction = UIContextualAction(style: .normal, title: "New Sharer") {
            (action, sourceView, completitionHandler) in
            
            // Open sharer
            self.openSharer(indexPath)
            
            // Dismissing the action button (must be called!)
            completitionHandler(true) // true = means the action was performed with success
        }
        
        // Changing the action button color - values needs to be between 0-1 (or use UIColor.red)
        shareAction.backgroundColor = UIColor(red: 100/255, green: 40/255, blue: 60/255, alpha: 1.0)
        // Adding an icon to the share action button
        shareAction.image = UIImage(named: "about")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
        return swipeConfiguration
    }
    
    /*
        Edit row actions
        Override swipe buttons
        This method will contain more actions when the user swipe the cell
        From iOS 11 this method is deprecated and the new functions are leadingSwipeActionsConfigurationForRowAt + trailingSwipeActionsConfigurationForRowAt
    */
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //let indexPos = indexPath.row
      
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: NSLocalizedString("Share", comment: "Share")) { (action, indexPath) in
            
            // Open sharer
            self.openSharer(indexPath)
        }
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: NSLocalizedString("Delete", comment: "Delete")) { (UITableViewRowAction, IndexPath) in
            
            // Removing the item
            self.deleteRow(tableView, indexPath)
        }
        
        // Set color
        let colorRed = UIColor.red
        let colorGreen = UIColor.green
        
        shareAction.backgroundColor = colorGreen
        deleteAction.backgroundColor = colorRed
        
        
        return [deleteAction, shareAction]
    }
    
    /*
        Opening the sharer functionality
    */
    func openSharer(_ indexPath: IndexPath) {
        
        let indexPos = indexPath.row
        
        
        // Start Sharer
        let text = NSLocalizedString("Check this app!", comment: "Check this app!")
        
        // Add Image
        let image = self.restaurants[indexPos].getRestaurantImage()
        let imageToShare = UIImage(data: image!)
        
        // Starting the sharer intent activity (you can pass text or other media eg images or both)
        let activityControler = UIActivityViewController(activityItems: [text, imageToShare!], applicationActivities: nil)
        
        /*
            Case for tablet to avoid crash upon opening the activity (it will be openned as popover)
         */
        if let popoverController = activityControler.popoverPresentationController {
            if let cell = tableView.cellForRow(at: indexPath) {
                popoverController.sourceView = cell
                popoverController.sourceRect = cell.bounds
            }
        }
        // End of definition
        
        
        self.present(activityControler, animated: true, completion: nil)
    }
    
    /*
        Delete a item
    */
    func deleteRow(_ tableView: UITableView, _ indexPath: IndexPath) {
        
        let indexPos = indexPath.row
        
        let deleted = restaurants.remove(at: indexPos)
        
        // Refresh UI - all
        //tableView.reloadData() // Updating UI tableView with data
        
        // Refresh UI by removing from tableView
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        
        // Delete from database
        AppDelegate.getDatabaseContext()?.delete(deleted)
        AppDelegate.saveDatabaseContext()
    }
    
    
    // Send data to next screen
    // This method will be called before the segue from storyboard is executed (in order to initialise objects with data)
    // First do the CTRL drag from cell to next viewController and select segue>show
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /*
         Type of segues:
         Show - when the show style is used, the content is pushed on top of the current view controller stack. A back button will be displayed in the navigation bar for navigating back to the original view controller. Typically, we use this segue type for navigation controllers.
         
         Show detail - similar to the show style, but the content in the detail (or destination) view controller replaces the top of the current view controller stack. For example, if you select show detail instead of show in the FoodPin app, there will be no navigation bar and back button in the detail view. 
         Present modally - presents the content modally. When used, the detail view controller will be animated up from the bottom and cover the entire screen on iPhone. A good example of present modally segue is the "Add" feature of the built-in Calendar app. When you click the + button in the app, it brings up a "New Event" screen from the bottom. 
         Present as popover - Present the content as a popover anchored to an existing view. Popover is commonly found in iPad apps, and you have already implemented popover in earlier chapters.
        */
        
        if segue.identifier == "showRestaurantDetail" {
            
            let indexPath = tableView.indexPathForSelectedRow
            
            if indexPath != nil {
                let indexPos = indexPath!.row
                
                let detail = segue.destination as! RestaurantDetailViewController
                
                detail.restaurant = restaurants[indexPos]
               
                // Initialise coordonates
                //detail.restaurant?.initCoordonate()
                
                
                // Hide bottom tab bar programatically if needed
                // From storyboard - enable "Hide bottom bar on push"
                detail.hidesBottomBarWhenPushed = true
            }
        }
    }
    
    
    /*
        Adding search functionallity
    */
    private func determineData() {
        // Determing which data should use based on the searchBar opened or not
        // Keep in mind that this option works without adding code to the tableView methods
        if searchController.isActive {
            restaurants = searchResults
        } else {
            restaurants = restaurantsHolder
        }
    }
    
    private func isSearchBarActive() -> Bool {
        return searchController.isActive
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        // Update search results to the UI
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            determineData()
            tableView.reloadData() // Updating UI tableView with data
        }
    }
    
    private func addingSearchBar() {
        searchController = UISearchController(searchResultsController: nil) // Param represents where to show the results of searching, nil means showing the results in the same view as searching (+ showing results in a different UI format)
        searchController.searchResultsUpdater = self // update listener
        // Adding the searchBar
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
            tableView.tableHeaderView = searchController.searchBar
        }
        
        // Controls whether the underlying content is dimmed during a search
        searchController.dimsBackgroundDuringPresentation = false
        
        restaurantsHolder = restaurants
        
        // Customize search bar
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor.brown
        searchController.searchBar.placeholder = NSLocalizedString("Search restaurants...", comment: "Search restaurants...")
    }
    
    func filterContent(for searchText: String) {
        // Searching and retriving all items from the array that contains the searched query
        
        var foundAny = false
        searchResults = restaurantsHolder.filter({ (restaurant) -> Bool in
            if let name = restaurant.getRestaurantName() {
                let isMatch = name.localizedCaseInsensitiveContains(searchText)
                            || restaurant.getRestaurantLocation().localizedCaseInsensitiveContains(searchText)
                
                foundAny = true
                return isMatch
            }
            return false
        })
        
        if !foundAny || searchText == "" {
            searchResults = restaurantsHolder
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return !isSearchBarActive()
    }
    
    // End of search
    

    
    // Open View Pager on first app startup
    func openGettingStarterViewPager() {
        // Only open once
        if (AppDelegate.isGettingStarted()) {
            return
        }
        
        // Storyboard ID = gettingStartedViewPager or gettingStartedViewController
        if let pageViewController =
            storyboard?.instantiateViewController(withIdentifier: "gettingStartedViewController")
                as? GettingStartedViewController {
            present(pageViewController, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    
    
    
    
    

    
        
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
