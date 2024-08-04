//
//  DiscoverTableViewController.swift
//  BookForSnack
//
//  Created by WORK on 6/10/17.
//  Copyright © 2017 WORK. All rights reserved.
//

import UIKit

import CloudKit

/*
    CloudKit URL - https://icloud.developer.apple.com/dashboard/
 */

class DiscoverTableViewController: UITableViewController {

    @IBOutlet var spinner: UIActivityIndicatorView!
    
    
    // Data from Cloud
    var restaurants:[CKRecord] = []
    
    // Cache images from Cloud for later use
    var imageCache = NSCache<CKRecordID, NSURL>()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        // Get data from cloud
        //fetchAllRecordsFromCloud()
        fetchAllRecordsFromCloudOperationalAPI()
        
        
        // SHOW progress loading
        //showProgressLoading()
        showProgressLoadingUi()
        
        
        // Enable pull to refresh
        enablePullToRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:
            indexPath)
        // Configure the cell...
        let restaurant = restaurants[indexPath.row]
        cell.textLabel?.text = restaurant.object(forKey: "restaurantName") as? String
        
        
        // Set the default image
        cell.imageView?.image = UIImage(named: "photoalbum")
        
        // Get phtoto from CKAsset from memory that was downloaded from cloud
        /*if let image = restaurant.object(forKey: "restaurantPhoto") {
            let imageAsset = image as! CKAsset
            
            if let imageData = try? Data.init(contentsOf: imageAsset.fileURL) {
                cell.imageView?.image = UIImage(data: imageData)
            }
        }*/
        //getPhotoFromCloudInBackground(restaurant, cell)
        setImageFromCacheIfAvailable(restaurant, cell)
        
     return cell
    }
    
    
    func setImageFromCacheIfAvailable(_ restaurant: CKRecord, _ cell: UITableViewCell) {
        // Check if the image is stored in cache
        if let imageFileURL = imageCache.object(forKey: restaurant.recordID) {
            // Fetch image from cache
            print("Get image from cache")
            if let imageData = try? Data.init(contentsOf: imageFileURL as URL) {
                cell.imageView?.image = UIImage(data: imageData)
            }
        } else {
            // Otherwise we download it from cloud
            getPhotoFromCloudInBackground(restaurant, cell)
        }
    }
    
    func getPhotoFromCloudInBackground(_ restaurant: CKRecord, _ cell: UITableViewCell) {
        // Fetch Image from Cloud in background
        let publicDatabase = CKContainer.default().publicCloudDatabase
        let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
        fetchRecordsImageOperation.desiredKeys = ["restaurantPhoto"]
        fetchRecordsImageOperation.queuePriority = .veryHigh
        fetchRecordsImageOperation.perRecordCompletionBlock = { (record, recordID,
            error) -> Void in
            if let error = error {
                print("Failed to get restaurant image: \(error.localizedDescription)")
                return
            }
            if let restaurantRecord = record {
                OperationQueue.main.addOperation() {
                    if let image = restaurantRecord.object(forKey: "restaurantPhoto") {
                        let imageAsset = image as! CKAsset
                        if let imageData = try? Data.init(contentsOf: imageAsset.fileURL) {
                            cell.imageView?.image = UIImage(data: imageData)
                        }
                        
                        
                        // Add the image URL to cache
                        self.imageCache.setObject(imageAsset.fileURL as NSURL, forKey: restaurant.recordID)
                    }
                }
            }
        }
        publicDatabase.add(fetchRecordsImageOperation)
    }
    
    
    @objc func fetchAllRecordsFromCloudOperationalAPI() {
        // Remove existing records before refreshing > used for pullToRefresh
        restaurants.removeAll()
        tableView.reloadData()
        
        
        // Fetch data using Convenience API
        let cloudContainer = CKContainer.default()
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        
        // Sort the results by date
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending:
            false)]
        
        // Create the query operation with the query
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["restaurantName"/*, "restaurantPhoto"*/]
        queryOperation.queuePriority = .veryHigh
        queryOperation.resultsLimit = 50
        queryOperation.recordFetchedBlock = { (record) -> Void in
            self.restaurants.append(record)
            
            // Show results in realtime
//            OperationQueue.main.addOperation {
//                self.tableView.reloadData()
//            }
        }
        queryOperation.queryCompletionBlock = { (cursor, error) -> Void in
            if let error = error {
                print("Failed to get data from iCloud - \(error.localizedDescription)")
                return
            }
            print("Successfully retrieve the data from iCloud")
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
                
                // Hide progress loading
                self.hideProgressLoadingUi()
                
                // Hide pull to refresh
                self.hidePullToRefresh()
            }
        }
        // Execute the query
        publicDatabase.add(queryOperation)
    }
    
    
    // DEPRECATED
    func fetchAllRecordsFromCloud() {
        // Fetch data using Convenience API
        let cloudContainer = CKContainer.default()
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        
        publicDatabase.perform(query, inZoneWith: nil, completionHandler: {
            (results, error) -> Void in
            
            if let error = error {
                print(error)
                return
            }
            if let results = results {
                print("Completed the download of Restaurant data")
                self.restaurants = results
                
                
                // If you put reloadData here will not work properly because is from background thread
                //self.tableView.reloadData()
                
                
                // RUN ON UI
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
                
            }
        })
    }
    
                
    
    func showProgressLoadingUi() {
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        tableView.addSubview(spinner)
        spinner.startAnimating()
    }
    
    func hideProgressLoadingUi() {
        spinner.stopAnimating()
    }
    
    
    func showProgressLoadingProgramatically() {
        let spinner:UIActivityIndicatorView = UIActivityIndicatorView()
        spinner.activityIndicatorViewStyle = .gray
        spinner.center = view.center
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    
    /*
        Pull to refresh method
        #selector will trigger the method name declarated in the class
    */
    func enablePullToRefresh() {
        // Pull To Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(fetchAllRecordsFromCloudOperationalAPI), for: UIControlEvents.valueChanged)
    }
    
    func hidePullToRefresh() {
        if let refreshControl = self.refreshControl {
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
        }
    }
    
    
    
    /*
        Save record to cloud
    */
    static func saveRecordToCloud(restaurant:Restaurant!) -> Void {
        
        // Prepare the record to save
        let record = CKRecord(recordType: "Restaurant")
        record.setValue(restaurant.getRestaurantName(), forKey: "restaurantName")
        record.setValue(restaurant.getRestaurantType(), forKey: "restaurantType")
        record.setValue(restaurant.getRestaurantLocation(), forKey: "restaurantLocation")
        record.setValue(restaurant.getRestaurantPhone(), forKey: "restaurantPhone")
        
        let imageData = restaurant.getRestaurantImage()! as Data
        
        // Resize the image
        let originalImage = UIImage(data: imageData)!
        let scalingFactor = (originalImage.size.width > 1024) ? 1024 / originalImage.size.width : 1.0
        let scaledImage = UIImage(data: imageData, scale: scalingFactor)!
        
        // Write the image to local file for temporary use
        let imageFilePath = NSTemporaryDirectory() + restaurant.getRestaurantName()!
        let imageFileURL = URL(fileURLWithPath: imageFilePath)
        try? UIImageJPEGRepresentation(scaledImage, 0.8)?.write(to: imageFileURL)
        
        // Create image asset for upload
        let imageAsset = CKAsset(fileURL: imageFileURL)
        record.setValue(imageAsset, forKey: "restaurantPhoto")
        
        // Get the Public iCloud Database
        let publicDatabase = CKContainer.default().publicCloudDatabase
        
        // Save the record to iCloud
        publicDatabase.save(record, completionHandler: { (record, error) -> Void  in
            // Remove temp file
            try? FileManager.default.removeItem(at: imageFileURL)
        })
    }
    
    
    
    
    
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
