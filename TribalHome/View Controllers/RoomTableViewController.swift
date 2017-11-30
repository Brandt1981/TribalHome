//
//  RoomTableViewController.swift
//  TribalHome
//
//  Created by Brandt Daniels on 11/29/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

let roomAccessorySegueIdentifier = "RoomAccessorySegueIdentifier"

class RoomTableViewController: UITableViewController {

    var home: HMHome!
    
    var room: HMRoom! {
        
        didSet {
            
            navigationItem.title = room.name
            
        }
        
    }
    
    private var selectedAccessory: HMAccessory?
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let accessoryTVC = segue.destination as? AccessoryTableViewController {
            
            accessoryTVC.home = home
            accessoryTVC.accessory = selectedAccessory
            
        }
        
    }

}

// MARK: - UITableViewDataSource

extension RoomTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return room.accessories.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let accessory = room.accessories[indexPath.row]
        
        cell.textLabel?.text = accessory.name
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension RoomTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedAccessory = room.accessories[indexPath.row]
        
        performSegue(withIdentifier: roomAccessorySegueIdentifier, sender: self)
        
    }
}
