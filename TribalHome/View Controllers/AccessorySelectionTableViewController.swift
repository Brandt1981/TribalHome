//
//  AccessorySelectionTableViewController.swift
//  TribalHome
//
//  Created by Brandt Daniels on 11/29/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

class AccessorySelectionTableViewController: UITableViewController {

    var home: HMHome!
    
    var room: HMRoom!
    
    var selectedAccessories = [HMAccessory]()
    
    private var availableAccessories: [HMAccessory] {
        
        return home.roomForEntireHome().accessories
        
    }
    
}

// MARK: - UITableViewDataSource

extension AccessorySelectionTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return availableAccessories.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let accessory = availableAccessories[indexPath.row]
        
        cell.textLabel?.text = accessory.name
        
        if selectedAccessories.contains(accessory) {
            
            cell.accessoryType = .checkmark
            
        } else {
            
            cell.accessoryType = .none
            
        }
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension AccessorySelectionTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let accessory = availableAccessories[indexPath.row]
        
        if selectedAccessories.contains(accessory) {
            
            if let accessoryIndex = selectedAccessories.index(of: accessory) {
                
                selectedAccessories.remove(at: accessoryIndex)
                
            }
            
        } else {
            
            selectedAccessories.append(accessory)
            
        }
        
        tableView.reloadData()
        
    }
    
}
