//
//  ViewController.swift
//  memorablePlaces
//
//  Created by Filip on 05.07.2018.
//  Copyright © 2018 Filip. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()  //declaration of manager to tracking user location
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longpress(gestureRecognizer:)))  // declaration of gesture
        
        uilpgr.minimumPressDuration = 2  //Set time to how long user should long press
        
        mapView.addGestureRecognizer(uilpgr)  //use a long press gesture on map
    
        
        if activePlaces == -1 {  // Default -1 to open map with user location instead of row
            
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            
        } else { // Do when user tap on row
            
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
            var subtitle = ""
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                if error != nil {
                    
                    print(error as Any)
                    
                } else {
                    
                    if let placemark = placemarks?[0] {
                        
                        if placemark.thoroughfare != nil {
                            
                            title += placemark.thoroughfare! + " "
                            
                        }
                        
                        if placemark.subThoroughfare != nil {
                            
                            title += placemark.subThoroughfare!
                            
                        }
                        
                        if placemark.subAdministrativeArea != nil {
                            
                            subtitle += placemark.subAdministrativeArea!
                            
                        }
                        
                    }
                    
                }
                
                if title == "" {
                    
                    title = ("Added \(NSDate())") // if title is empty set date insteed of name

                }
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = newCoordinate
                annotation.title = title
                annotation.subtitle = subtitle
                self.mapView.addAnnotation(annotation)
                places.append(["name": title, "lat": String(newCoordinate.latitude), "long": String(newCoordinate.longitude)]) // add long press place to places array
                
                UserDefaults.standard.set(places, forKey: "places")  // saves permanently place
                
            })
        
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        /*
        let userLocation: CLLocation = locations[0] // Long way
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let latDelta: CLLocationDegrees = 0.02
        let longDelta: CLLocationDegrees = 0.02
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: coordinate, span: span) */
        
        //Short way
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)) // tracking user location
        
        self.mapView.setRegion(region, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

