//
//  MapViewController.swift
//  BookForSnack
//
//  Created by WORK on 5/15/17.
//  Copyright © 2017 WORK. All rights reserved.
//

import UIKit

import MapKit // For mapView


class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var restaurant: Restaurant?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Init pin
        initPinOnMap()
        
        // Other map initializations
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsTraffic = true
        
        // Show navBar
        Utils.navigationBarShow(navigationController, true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initPinOnMap() {
        // Set class delegate/listener
        mapView.delegate = self // IMPORTANT
        
        restaurant?.initPinOnMap(mapView, true, false)
    }
    
    /*
        Customizing the icon view with MKMapViewDelegate
    */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        /*
            PUT image to map tooltip pin
        */
        let identifier = "MyPin"
        if annotation.isKind(of: MKUserLocation.self) {
            // Returning here in order to show current location with blue dot!
            return nil
        }
        
        if true {
            if #available(iOS 11.0, *) {
                return newAnotation(mapView, annotation, identifier)
            } else {
                // Fallback on earlier versions
            }
        }
        
        /*
            Tooltip style
        */
        
        // Reuse the annotation if possible
        var annotationView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation,
                                                 reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        // Add icon to left of the opened tooltip
        let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 53, height: 53))
        let image = restaurant?.getRestaurantImage()
        leftIconView.image = UIImage(data: image!)
        annotationView?.leftCalloutAccessoryView = leftIconView
        
        // Setting pin color
        annotationView?.pinTintColor = UIColor.orange
     
    
        return annotationView
    }

    @available(iOS 11.0, *)
    func newAnotation(_ mapView: MKMapView, _ annotation: MKAnnotation, _ identifier : String) -> MKAnnotationView? {
        
        /*
            New iOS11 annotation style as balon icon
        */
        
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        annotationView?.glyphText = "😋"
        annotationView?.markerTintColor = UIColor.orange
        
        return annotationView
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
