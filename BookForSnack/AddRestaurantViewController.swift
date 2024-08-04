//
//  AddRestaurantViewController.swift
//  BookForSnack
//
//  Created by WORK on 5/16/17.
//  Copyright © 2017 WORK. All rights reserved.
//

import UIKit

class AddRestaurantViewController: UITableViewController,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate,
        UITextFieldDelegate /* Overriding in order to use the next textField on return button pressed */ {
    
    var imagePath: String = ""
    var isVisited: Bool = false
    
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var editName: UITextField! {
        didSet {
            editName.becomeFirstResponder()
            editName.tag = 1 // Using tag to set when the user press return to jump to the next textField
            editName.delegate = self
        }
    }
    @IBOutlet var editType: UITextField! {
        didSet {
            editType.tag = 2 // Using tag to set when the user press return to jump to the next textField
            editType.delegate = self
        }
    }
    @IBOutlet var editLocation: UITextField! {
        didSet {
            editLocation.tag = 3 // Using tag to set when the user press return to jump to the next textField
            editLocation.delegate = self
        }
    }
    @IBOutlet var editPhone: UITextField! {
        didSet {
            editPhone.tag = 4 // Using tag to set when the user press return to jump to the next textField
            editPhone.delegate = self
        }
    }
    @IBOutlet var buttonYes: UIButton!
    @IBOutlet var buttonNo: UIButton!
    
    
    
    @IBAction func saveButtonItem(sender: UINavigationItem) {
        let name = editName.text
        let type = editType.text
        let location = editLocation.text
        let phoneText = editPhone.text
        
        if name == "" || type == "" || location == "" || phoneText == "" {
            AlertUtils.alert(self, title: nil, message: NSLocalizedString("All fields are mandatory!", comment: "All fields are mandatory!"), okButton: NSLocalizedString("Ok", comment: "Ok"))
            return
        }
        
        if imagePath == "" {
            AlertUtils.alert(self, title: nil, message: NSLocalizedString("You need to add a photo!", comment: "You need to add a photo!"), okButton: NSLocalizedString("Ok", comment: "Ok"))
            return
        }
        
        let restaurant = Restaurant(name: name!, type: type!, location: location!, phone: phoneText!, image: imagePath, isVisited: self.isVisited)
        
        print(restaurant)
        
        // Save restaurant to cloud
        DiscoverTableViewController.saveRecordToCloud(restaurant: restaurant)
        
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toggleYesNo(sender: UIButton) {
        isVisited =  !isVisited
        
        initButtons()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        initButtons()
        
        self.hideKeyboardWhenTappedAround() // Close keyboard
    
        Utils.tableViewRemoveAllSeparators(tableView) // Remove tableView separator
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    // Initialize buttons
    func initButtons() {
        if isVisited {
            buttonYes.backgroundColor = UIColor.red
            buttonNo.backgroundColor = UIColor.gray
        } else {
            buttonYes.backgroundColor = UIColor.gray
            buttonNo.backgroundColor = UIColor.red
        }
    }
    
    
    // Table cell selection implementation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPos = indexPath.row
        
        if indexPos == 0 {
            // Open gallery
            openImageLibrary()
            
        } else if indexPos != 4 {
            // Send focus to editField
            
            switch indexPos {
            case 1:
                 editName.becomeFirstResponder()
            case 2:
                 editType.becomeFirstResponder()
            case 3:
                 editLocation.becomeFirstResponder()
            case 4:
                 editPhone.becomeFirstResponder()
            default:
                print("")
            }
//            let currentCell = tableView.cellForRow(at: indexPath)!
//            let editField = currentCell as! UITextField
//            editField.becomeFirstResponder()
        }
        
        // Auto deselect the row
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    // Image picker implementation (will be called from the UIImagePickerControllerDelegate)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Get photo
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            setPicture(image)
        }
        
        // Get path
        if let imagePath = info[UIImagePickerControllerReferenceURL] as? NSURL {
            self.imagePath = imagePath.absoluteString!
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func setPicture(_ image: UIImage) {
        
        // Set imageView
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        /*  
            Setting constraints from code
        */
        let leadingConstraint = NSLayoutConstraint(item: imageView, attribute:
            NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem:
            imageView.superview, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        leadingConstraint.isActive = true
        
        let trailingConstraint = NSLayoutConstraint(item: imageView, attribute : NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal,toItem: imageView.superview, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        trailingConstraint.isActive = true
        
        let topConstraint = NSLayoutConstraint(item: imageView, attribute:
            NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem:
            imageView.superview, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: imageView, attribute:
            NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem:
            imageView.superview, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        bottomConstraint.isActive = true
        // End of constraints
    }
    
    func openImageLibrary() {
        AlertUtils.alert(self, message: "Choose your option", okButton: nil, asDialog: false, nil, [
                AlertUtils.ButtonAlert("Camera", buttonListener: { () in
                    self.openCamera()
                }),
                AlertUtils.ButtonAlert("Gallery", buttonListener: { () in
                    self.openGallery()
                }),
            ])
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            
            // Set listener
            imagePicker.delegate = self // IMPORTANT
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            
            // Set listener
            imagePicker.delegate = self // IMPORTANT
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    
    // MARK: - UITextFieldDelegate methods
    
    /*
         In the code above, we increase the current tag value by 1 and call to retrieve the next text field. Then we remove the focus of the current text field by calling
         and let the next text field become the first responder. 
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        
        } else {
            self.dismissKeyboard() // Close keyboard
        }
        
        return true
    }
    
    
    
    
    
    
    

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

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
