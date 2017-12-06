//
//  AccessorySelectionTableViewController.swift
//  TribalHome
//
//  Created by Brandt Daniels on 11/29/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

protocol AccessorySelectionDelegate {
    
    func accessorySelectionTableViewController(_ accessorySelectionTableViewController: AccessorySelectionTableViewController, didSelectAccessories accessories: [HMAccessory])
    
}

class AccessorySelectionTableViewController: UITableViewController {
    
    var accessories: [HMAccessory]! {
        
        didSet {
            
            accessories.sort { $0.name < $1.name }
            
        }

    }
    
    var delegate: AccessorySelectionDelegate!
    
    private var selectedAccessories = [HMAccessory]()
    
}

// MARK: - UITableViewDataSource

extension AccessorySelectionTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return accessories.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let accessory = accessories[indexPath.row]
        
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
        
        let accessory = accessories[indexPath.row]
        
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

// MARK: - IBAction

extension AccessorySelectionTableViewController {
    
    @IBAction private func doneButtonTapped() {
        
        delegate.accessorySelectionTableViewController(self, didSelectAccessories: selectedAccessories)
        
    }
}
