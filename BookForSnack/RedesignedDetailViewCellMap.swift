//
//  RedesignedDetailViewCellMap.swift
//  BookForSnack
//
//  Created by WORK on 20/01/2018.
//  Copyright © 2018 WORK. All rights reserved.
//

import UIKit
import MapKit

class RedesignedDetailViewCellMap : UITableViewCell {

    @IBOutlet var mapView: MKMapView!
    
    public func configure(_ restaurant : Restaurant!) {
        
        restaurant.initPinOnMap(mapView, false, true)
    }
}
