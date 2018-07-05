//
//  ViewController.swift
//  memorablePlaces
//
//  Created by Filip on 05.07.2018.
//  Copyright © 2018 Filip. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if activePlaces != -1 {
            
            if places.count > activePlaces {
            
                if let name = places[activePlaces]["name"] {
                
                    if let lat = places[activePlaces]["lat"] {
                    
                        if let long = places[activePlaces]["long"] {
                        
                            if let latitude = Double(lat) {
                            
                                if let longitude = Double(long) {
                                
                                    //let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                
                                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                
                                    let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                                
                                    self.mapView.setRegion(region, animated: true)
                                    
                                    let annotation = MKPointAnnotation()
                                    annotation.coordinate = coordinate
                                    annotation.title = name
                                    self.mapView.addAnnotation(annotation)
                                
                                }
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
  
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

