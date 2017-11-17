//
//  ServicesTableViewController.swift
//  TribalHome
//
//  Created by TSL043 on 11/15/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

let characteristicsSegueIdentifier = "CharacteristicsSegueIdentifier"

class ServicesTableViewController: UITableViewController {

    var accessory: HMAccessory!
    
    private var services: [HMService] {
        
        return accessory.services
        
    }

    private var selectedService: HMService?
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let characteristicsTVC = segue.destination as? CharacteristicsTableViewController {
            
            characteristicsTVC.service = selectedService
            
        }
        
    }
    
}

// MARK: - UITableViewDataSource

extension ServicesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return services.count
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return accessory.name
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let service = services[indexPath.row]
        
        cell.textLabel?.text = service.name
        
        switch service.serviceType {
        case HMServiceTypeLabel:
            cell.detailTextLabel?.text = service.serviceType
        case HMServiceTypeLightbulb:
            cell.detailTextLabel?.text = "Light Bulb"
        case HMServiceTypeSwitch:
            cell.detailTextLabel?.text = "Switch"
        case HMServiceTypeThermostat:
            cell.detailTextLabel?.text = "Thermostat"
        case HMServiceTypeGarageDoorOpener:
            cell.detailTextLabel?.text = "Garage Door Opener"
        case HMServiceTypeAccessoryInformation:
            cell.detailTextLabel?.text = "Information"
        case HMServiceTypeFan:
            cell.detailTextLabel?.text = "Fan"
        case HMServiceTypeOutlet:
            cell.detailTextLabel?.text = "Outlet"
        case HMServiceTypeLockMechanism:
            cell.detailTextLabel?.text = "Lock Mechanism"
        case HMServiceTypeLockManagement:
            cell.detailTextLabel?.text = "Lock Management"
        default:
            break
        }
        
        return cell
    }
    
}

// MARK: - UITableViceDelegate

extension ServicesTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedService = services[indexPath.row]
        
        performSegue(withIdentifier: characteristicsSegueIdentifier, sender: self)
        
    }
    
}
