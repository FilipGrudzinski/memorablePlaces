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
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longpress(gestureRecognizer:)))
        
        uilpgr.minimumPressDuration = 2
        
        mapView.addGestureRecognizer(uilpgr)
    
        
        
        if activePlaces != -1 {
            
            if places.count > activePlaces {
            
                if let name = places[activePlaces]["name"] {
                
                    if let lat = places[activePlaces]["lat"] {
                    
                        if let long = places[activePlaces]["long"] {
                        
                            if let latitude = Double(lat) {
                            
                                if let longitude = Double(long) {
                                
                                    let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                                
                                    let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                
                                    let region = MKCoordinateRegion(center: coordinates, span: span)
                                
                                    mapView.setRegion(region, animated: true)
                                    
                                    let annotation = MKPointAnnotation()
                                    
                                    annotation.title =  name
                                    annotation.coordinate = coordinates
                                    self.mapView.addAnnotation(annotation)
                                    
                                
                                }
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
    
  
    }
    
    @objc func longpress(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizerState.began {
        
            let touchpoint = gestureRecognizer.location(in: self.mapView)
        
            let newCoordinate = mapView.convert(touchpoint, toCoordinateFrom: self.mapView)
            
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            var title = ""
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                if error != nil {
                    
                    print(error)
                    
                } else {
                    
                    if let placemark = placemarks?[0] {
                        
                        if placemark.thoroughfare != nil {
                            
                            title += placemark.thoroughfare! + " "
                            
                        }
                        
                        if placemark.subThoroughfare != nil {
                            
                            title += placemark.subThoroughfare!
                            
                        }
                        
                    }
                    
                }
                
                if title == "" {
                    
                    title = ("Added \(NSDate())")
                }
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = newCoordinate
                annotation.title = title
                self.mapView.addAnnotation(annotation)
                places.append(["name": title, "lat": String(newCoordinate.latitude), "long": String(newCoordinate.longitude)])
                
                
            })
        
           
        
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

