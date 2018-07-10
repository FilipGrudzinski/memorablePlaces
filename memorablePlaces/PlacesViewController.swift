//
//  PlacesViewController.swift
//  memorablePlaces
//
//  Created by Filip on 05.07.2018.
//  Copyright © 2018 Filip. All rights reserved.
//

import UIKit

var places = [Dictionary<String, String>()]  // Create array to keep places
var activePlaces = -1

class PlacesViewController: UITableViewController {

    //var activeRow = 0
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let tempPlaces = UserDefaults.standard.object(forKey: "places") as? [Dictionary<String, String>] {
            
            places = tempPlaces
            
        }
        
        if places.count == 1 && places[0].count == 0 {
            
            places.remove(at: 0)
            places.append(["name": "Poznań","lat": "52.398407", "long": "16.931172"])
            //UserDefaults.standard.set(places, forKey: "places")
            
        }
 
        activePlaces = -1
        table.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return places.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        if places[indexPath.row]["name"] != nil { // Testing if places name taped from table is not nil
            cell.textLabel?.text = places[indexPath.row]["name"]
        }
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        activePlaces = indexPath.row  // set activePlaces to row to open mapView with saved row position
        performSegue(withIdentifier: "toMapView", sender: nil)
        
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
   
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            places.remove(at: indexPath.row)
            table.reloadData()
            UserDefaults.standard.set(places, forKey: "places")
            
        }
        
    }

}
