//
//  ServiceSelectionTableViewController.swift
//  TribalHome
//
//  Created by Brandt Daniels on 12/4/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

class ServiceSelectionTableViewController: UITableViewController {

    var home: HMHome!
    
    var selectedServices = [HMService]()
    
    private var accessories: [HMAccessory] {

        return home.accessories
            .filter { $0.nonInformationalServices.count != 0 }
            .sorted { $0.name < $1.name }
        
    }

}

// MARK: - UITableViewDataSource

extension ServiceSelectionTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return accessories.count
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let accessory = accessories[section]
        
        return accessory.nonInformationalServices.count
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let accessory = accessories[section]
        
        return accessory.name
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let accessory = accessories[indexPath.section]
        
        let service = accessory.nonInformationalServices[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        cell.textLabel?.text = service.name
        
        if selectedServices.contains(service) {
            
            cell.accessoryType = .checkmark
            
        } else {
            
            cell.accessoryType = .none
            
        }
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension ServiceSelectionTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let accessory = accessories[indexPath.section]
        
        let service = accessory.nonInformationalServices[indexPath.row]
        
        if selectedServices.contains(service) {
            
            if let serviceIndex = selectedServices.index(of: service) {
                
                selectedServices.remove(at: serviceIndex)
                
            }
            
        } else {
            
            selectedServices.append(service)
            
        }
        
        tableView.reloadData()
        
    }
    
}

// MARK: - HMAccessory

private extension HMAccessory {
    
    var nonInformationalServices: [HMService] {
        
        return services.filter { $0.serviceType != HMServiceTypeAccessoryInformation }
        
    }
    
}
