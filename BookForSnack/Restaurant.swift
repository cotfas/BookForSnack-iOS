//
//  Restaurant.swift
//  BookForSnack
//
//  Created by WORK on 5/9/17.
//  Copyright © 2017 WORK. All rights reserved.
//

import Foundation
import MapKit // For mapView

import CoreData // For dataBase

import Photos // Use the Photos Framework


/*
    Exstension to the xdatamodeld file + Codegen(ClassDefinition)
 */
extension Restaurant {
    
//    private var restaurantName: String?
//    private var restaurantLocation: String?
//    private var restaurantType: String?
//    private var restaurantImage: NSData?
//    private var restaurantPhone: String?
//    private var restaurantVisited: Bool = false
//    private var restaurantRating: String?
    

//    @nonobjc public class func fetchRequestOverrider() -> NSFetchRequest<Restaurant> {
//        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
//    }
    
    
    
    /*
        Restaurant(name: "Cafe Deadend", type: "Coffee & Tea Shop", location: "G/F, 72 Po Hing Fong, Sheung Wan, Hong Kong", phone: "232-923423", image: "cafedeadend.jpg", isVisited: false),
    */
    // When using as extension we need to add convenience as well - and also gives the ability to initialise the object without params
    convenience init(name restaurantName: String, type restaurantType: String, location restaurantLocation: String, phone restaurantPhone: String, image restaurantImage: String, isVisited restaurantVisited: Bool) {
        
        // Save to DB
        let managedObjectContext = AppDelegate.getDatabaseContext()!
        let entity = NSEntityDescription.entity(forEntityName: "Restaurant", in: managedObjectContext)!
        self.init(entity: entity, insertInto: managedObjectContext)
    
        // Only available to iOS10
        //self.init(context: AppDelegate.getDatabaseContext()!)
        
        
        setter(name: restaurantName, type: restaurantType, location: restaurantLocation, phone: restaurantPhone, image: restaurantImage, isVisited: restaurantVisited)
        
        // Save to database
        AppDelegate.saveDatabaseContext()
    }
    
    func setter(name restaurantName: String, type restaurantType: String, location restaurantLocation: String, phone restaurantPhone: String, image restaurantImage: String, isVisited restaurantVisited: Bool) {
        
        self.restaurantName = restaurantName
        self.restaurantLocation = restaurantLocation
        self.restaurantType = restaurantType
        self.restaurantPhone = restaurantPhone
        self.restaurantVisited = restaurantVisited
        
        setterRestaurantImage(restaurantImage)
    }
    
    
    public func getRestaurantName() -> String! {
        return restaurantName;
    }
    
    public func getRestaurantType() -> String! {
        return restaurantType;
    }
    
    public func getRestaurantLocation() -> String! {
        return restaurantLocation;
    }
    
    public func getRestaurantImage() -> Data! {
        return restaurantImage! as Data;
    }
    
    public func getRestaurantPhone() -> String! {
        return restaurantPhone;
    }
    
    public func getRestaurantRating() -> String! {
        return restaurantRating;
    }
    
    public func isRestaurantVisited() -> Bool {
        return restaurantVisited;
    }
    
    
    public func setterRestaurantRating(_ restaurantRating: String) {
        self.restaurantRating = restaurantRating
        
        // Save to database
        AppDelegate.saveDatabaseContext()
    }
    
    public func setterRestaurantVisited(_ restaurantVisited: Bool) {
        self.restaurantVisited = restaurantVisited
        
        // Save to database
        AppDelegate.saveDatabaseContext()
    }
    
    private func setterRestaurantImage(_ restaurantImage: String?) {
        
        // Set default image if null
//        if restaurantImage == nil || restaurantImage == "" {
//            setDefaultPhoto()
//            return
//        }
        
        
        // Setting selected image
        if let uiImage: UIImage = UIImage(named: restaurantImage!) {
            if let data = UIImagePNGRepresentation(uiImage) {
                let nsData = NSData(data: data)
                self.restaurantImage = nsData as Data
                
                // Success case
                return
            }
        }
        
        // Trying to get image from AssetLibrary
        if let assetLibrary = restaurantImage {
            
            // Declare your asset url
            if let assetUrl = URL(string: assetLibrary) {
            
                // Retrieve the list of matching results for your asset url
                let fetchResult = PHAsset.fetchAssets(withALAssetURLs: [assetUrl], options: nil)
                
                if let photo = fetchResult.firstObject {
                    // Retrieve the image for the first result
                    PHImageManager.default().requestImage(for: photo, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: nil) {
                    image, info in
                        
                        // Here is the image
                        
                        if let myImage = image {
                            if let data = UIImagePNGRepresentation(myImage) {
                                let nsData = NSData(data: data)
                                self.restaurantImage = nsData as Data
                            
                                // Save to database
                                AppDelegate.saveDatabaseContext()
                                
                                // Success case
                                return
                            }
                        }
                    }
                }
            }
        }
        
        // Set default image if null
        setDefaultPhoto()
    }
    
    // Setting default photo when needed
    private func setDefaultPhoto() {
        let restaurantImage = "photoalbum"
        if let uiImage: UIImage = UIImage(named: restaurantImage) {
            if let data = UIImagePNGRepresentation(uiImage) {
                let nsData = NSData(data: data)
                self.restaurantImage = nsData as Data
            }
        }
    }
    
    
    
    // Coordonates
    public func getCoordonate(_ closure: @escaping (CLLocationCoordinate2D) -> ()) {
        
        var coordonateLocation: CLLocationCoordinate2D?
        
        if restaurantLocation == nil {
            return
        }
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(self.restaurantLocation!, completionHandler: { placemarks, error in
            
            if let error = error {
                print(error)
                return
            }
            
            if placemarks == nil {
                return
            }
            
            for p in placemarks! {
                coordonateLocation = p.location?.coordinate
                
                closure(coordonateLocation!)
                return
            }
        })
        
        //return coordonateLocation
    }
    
    public func initPinOnMap(_ mapView : MKMapView, _ showTitle : Bool, _ zoomEnabled : Bool) {
        
        self.getCoordonate({ location in
            
            let annotation = MKPointAnnotation()
            if (showTitle) {
                annotation.title = self.getRestaurantName()
                annotation.subtitle = self.getRestaurantType()
            }
            annotation.coordinate = location
            
            // Add pins to map - will automatically zoom
            mapView.showAnnotations([annotation], animated: true)
            
            // Automatically show tooltip
            mapView.selectAnnotation(annotation, animated: true) // when is selected it will show first as big icon
            
            
            // Set zoom level
            if (zoomEnabled) {
                let zoom = 250.0
                let region = MKCoordinateRegionMakeWithDistance(location, zoom, zoom)
                mapView.setRegion(region, animated: true)
            }
            
            // Other map setup
            
            /*
             showTraffic - shows any high traffic on your map view
             showScale - shows a scale on the top-left corner of your map view.
             showCompass - displays a compass control on the top-right corner of your map view. Please note that the compass will only appear when the map is rotated a little bit away from pure north.
             
             Need to be called on viewDidLoad
             */
            mapView.showsCompass = true
            mapView.showsTraffic = true
            mapView.showsScale = true
        })
    }
}
