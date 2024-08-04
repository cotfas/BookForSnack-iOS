//
//  AboutTableViewController.swift
//  BookForSnack
//
//  Created by WORK on 6/9/17.
//  Copyright © 2017 WORK. All rights reserved.
//

import UIKit

import SafariServices


class AboutTableViewController: UITableViewController {
    
    var sectionTitles = [NSLocalizedString("Leave Feedback", comment: "Leave Feedback"),        NSLocalizedString("Follow Us", comment: "Follow Us")]
    var sectionContent = [[NSLocalizedString("Rate us on App Store", comment: "Rate us on App Store"),
                           NSLocalizedString("Tell us your feedback", comment: "Tell us your feedback"),
                           NSLocalizedString("Open Video", comment: "Open Video")],
                          [NSLocalizedString("Twitter", comment: "Twitter"),
                           NSLocalizedString("Facebook", comment: "Facebook"),
                           NSLocalizedString("Pinterest", comment: "Pinterest")]]
    var links = ["https://twitter.com/appcodamobile",
                 "https://facebook.com/appcodamobile", "https://www.pinterest.com/appcoda/"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        // Remove unused separators
        Utils.tableViewRemoveUnusedSeparators(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionContent[section].count
    }
    
    
    /*
        Table view setup
    */
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
        section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:
            indexPath)
        // Configure the cell...
        cell.textLabel?.text = sectionContent[indexPath.section][indexPath.row]
        return cell
    }
    // End of setup
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Feedback section
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                // Rate us
                if let url = URL(string: links[indexPath.row]) {
                    
                    if #available(iOS 10.0, *) {
                        // Open with safari
                        UIApplication.shared.open(url)
                    } else {
                        // Fallback on earlier versions
                    }
                }
            } else if (indexPath.row == 1) {
                performSegue(withIdentifier: "showWebView", sender: nil)
            } else if (indexPath.row == 2) {
                performSegue(withIdentifier: "showVideoView", sender: nil)
            }
        } else if (indexPath.section == 1) {
            
            // Open url by Safari WebView
            if let url = URL(string: links[indexPath.row]) {
                let safariController = SFSafariViewController(url: url)
                present(safariController, animated: true, completion: nil)
            }
        }
        
        
        // Auto deselect items
        tableView.deselectRow(at: indexPath, animated: false)
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
