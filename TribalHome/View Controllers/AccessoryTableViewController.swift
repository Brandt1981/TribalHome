//
//  AccessoryTableViewController.swift
//  TribalHome
//
//  Created by Brandt Daniels on 11/24/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

let editAccessorySegueIdentifier = "EditAccessorySegueIdentifier"

class AccessoryTableViewController: UITableViewController {
    
    var home: HMHome!
    
    var accessory: HMAccessory! {
        
        didSet {
            
            navigationItem.title = accessory.name
            
        }
        
    }
    
    private var services: [HMService] {
        
        return accessory.services
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PowerStateTableViewCell.self, forCellReuseIdentifier: powerStateCellReuseIdentifier)
        
        tableView.register(UINib(nibName: brightnessTableViewCellNibName, bundle: nil), forCellReuseIdentifier: String(describing: BrightnessTableViewCell.self))
        
        tableView.register(UINib(nibName: hueTableViewCellNibName, bundle: nil), forCellReuseIdentifier: String(describing: HueTableViewCell.self))
        
        tableView.register(UINib(nibName: saturationTableViewCellNibName, bundle: nil), forCellReuseIdentifier: String(describing: SaturationTableViewCell.self))
        
        tableView.register(UINib(nibName: lockTargetStateTableViewCellNibName, bundle: nil), forCellReuseIdentifier: String(describing: LockTargetStateTableViewCell.self))
        
        tableView.register(UINib(nibName: identifyTableViewCellNibName, bundle: nil), forCellReuseIdentifier: String(describing: IdentifyTableViewCell.self))
        
        tableView.register(UINib(nibName: String(describing: RotationSpeedTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: RotationSpeedTableViewCell.self))
        
        tableView.register(UINib(nibName: String(describing: RotationDirectionTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: RotationDirectionTableViewCell.self))
        
        for service in services {
            
            for characteristic in service.characteristics {
                
                if characteristic.properties.contains(HMCharacteristicPropertySupportsEventNotification) {
                    
                    characteristic.enableNotification(true, completionHandler: { error in
                        
                        guard error == nil else {
                            return
                        }
                        
                    })
                    
                }
                
            }
            
        }
        
        accessory.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        for service in services {
            
            for characteristic in service.characteristics {
                
                if characteristic.properties.contains(HMCharacteristicPropertySupportsEventNotification) {
                    
                    characteristic.enableNotification(false, completionHandler: { error in
                        
                        guard error == nil else {
                            return
                        }
                        
                    })
                    
                }
                
            }
            
        }
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let navController = segue.destination as? UINavigationController,
        let editAccessoryTVC = navController.topViewController as? EditAccessoryTableViewController {
            
            editAccessoryTVC.home = home
            editAccessoryTVC.accessory = accessory
            
        }
        
    }

}

// MARK: - UITableViewDataSource

extension AccessoryTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        let sortedServices = sorted(accessory.services)
        
        return sortedServices.count
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sortedServices = sorted(accessory.services)
        
        let service = sortedServices[section]
        
        return sorted(service.characteristics).count
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sortedServices = sorted(accessory.services)
        
        let service = sortedServices[section]
        
        return serviceTypeString(for: service)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sortedServices = sorted(accessory.services)
        
        let service = sortedServices[indexPath.section]
        
        let characteristic = sorted(service.characteristics)[indexPath.row]
        
        return cell(for: characteristic, at: indexPath)
        
    }
    
}

// MARK: - IBAction

extension AccessoryTableViewController {
    
    @IBAction private func editAccessoryTapped() {
        
        performSegue(withIdentifier: editAccessorySegueIdentifier, sender: self)
        
    }
    
    @IBAction private func unwindToAccessoryTVC(segue: UIStoryboardSegue) {
        
        tableView.reloadData()
        
    }
    
}

// MARK: - Private

extension AccessoryTableViewController {
    
    func sorted(_ services: [HMService]) -> [HMService] {
        
        return services.filter { $0.serviceType != HMServiceTypeAccessoryInformation }.sorted { $0.isPrimaryService && !$1.isPrimaryService }
        
    }
    
    func sorted(_ characteristics: [HMCharacteristic]) -> [HMCharacteristic] {

        return characteristics.filter { $0.characteristicType != HMCharacteristicTypeName }
        
    }

    func serviceTypeString(for service: HMService) -> String {
        
        var serviceTypeString: String
        
        switch service.serviceType {
            
        case HMServiceTypeLabel:
            serviceTypeString = "Label"
        case HMServiceTypeLightbulb:
            serviceTypeString = "Light Bulb"
        case HMServiceTypeSwitch:
            serviceTypeString = "Switch"
        case HMServiceTypeThermostat:
            serviceTypeString = "Thermostat"
        case HMServiceTypeGarageDoorOpener:
            serviceTypeString = "Garage Door Opener"
        case HMServiceTypeAccessoryInformation:
            serviceTypeString = "Accessory Information"
        case HMServiceTypeFan:
            serviceTypeString = "Fan"
        case HMServiceTypeOutlet:
            serviceTypeString = "Outlet"
        case HMServiceTypeLockMechanism:
            serviceTypeString = "Lock Mechanism"
        case HMServiceTypeLockManagement:
            serviceTypeString = "Lock Management"
        default:
            serviceTypeString = service.serviceType
            
        }
        
        return serviceTypeString
        
    }
    
    func cell(for characteristic: HMCharacteristic, at indexPath: IndexPath) -> UITableViewCell {
        
        if characteristic.characteristicType == HMCharacteristicTypePowerState {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: powerStateCellReuseIdentifier, for: indexPath) as! PowerStateTableViewCell
            
            cell.configure(with: characteristic)
            
            return cell
            
        } else if characteristic.characteristicType == HMCharacteristicTypeBrightness {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BrightnessTableViewCell.self), for: indexPath) as! BrightnessTableViewCell
            
            cell.configure(with: characteristic)
            
            return cell
            
        } else if characteristic.characteristicType == HMCharacteristicTypeHue {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HueTableViewCell.self), for: indexPath) as! HueTableViewCell
            
            cell.configure(with: characteristic)
            
            return cell
            
        } else if characteristic.characteristicType == HMCharacteristicTypeSaturation {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SaturationTableViewCell.self), for: indexPath) as! SaturationTableViewCell
            
            cell.configure(with: characteristic)
            
            return cell
            
        } else if characteristic.characteristicType == HMCharacteristicTypeIdentify {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: IdentifyTableViewCell.self), for: indexPath) as! IdentifyTableViewCell
            
            cell.configure(with: characteristic)
            
            return cell
            
        } else if characteristic.characteristicType == HMCharacteristicTypeTargetLockMechanismState {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LockTargetStateTableViewCell.self), for: indexPath) as! LockTargetStateTableViewCell
            
            cell.configure(with: characteristic)
            
            return cell
            
        } else if characteristic.characteristicType == HMCharacteristicTypeRotationSpeed {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RotationSpeedTableViewCell.self), for: indexPath) as! RotationSpeedTableViewCell
            
            cell.configure(with: characteristic)
            
            return cell
            
        } else if characteristic.characteristicType == HMCharacteristicTypeRotationDirection {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RotationDirectionTableViewCell.self), for: indexPath) as! RotationDirectionTableViewCell
            
            cell.configure(with: characteristic)
            
            return cell
            
        }
            
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
                        
            cell.textLabel?.text = characteristic.localizedDescription
                        
            if characteristic.properties.contains(HMCharacteristicPropertyReadable) {
                
                let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                spinner.startAnimating()
                
                cell.detailTextLabel?.text = nil
                cell.accessoryView = spinner
                
                characteristic.readValue(completionHandler: { error in
                    
                    cell.accessoryView = nil
                    
                    guard error == nil else {
                        
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                        print("error: \(String(describing: error))")
                        
                        cell.detailTextLabel?.text = "X"
                        
                        return
                    }
                    
                    if characteristic.characteristicType == HMCharacteristicTypeCurrentLockMechanismState {
                        
                        if let value = characteristic.value as? Int {
                            
                            var state = "Unknown"
                            
                            switch value {
                            case 0:
                                state = "Unsecured"
                            case 1:
                                state = "Secured"
                            case 2:
                                state = "Jammed"
                            case 3:
                                state = "Unknown"
                            default:
                                break
                            }
                            
                            cell.detailTextLabel?.text = state
                            
                        }
                        
                    } else {
                        
                        cell.detailTextLabel?.text = (characteristic.value as AnyObject).description
                        
                    }
                    
                })
                
            }
            
            return cell
            
        }
        
    }
    
}

// MARK: - HMAccessoryDelegate

extension AccessoryTableViewController: HMAccessoryDelegate {
    
    func accessory(_ accessory: HMAccessory, service: HMService, didUpdateValueFor characteristic: HMCharacteristic) {
        
        if let serviceSection = sorted(accessory.services).index(of: service) {
            
            let service = sorted(accessory.services)[serviceSection]
            
            if let characteristicRow = sorted(service.characteristics).index(of: characteristic) {
                
                let indexPath = IndexPath(row: characteristicRow, section: serviceSection)
                
                tableView.reloadRows(at: [indexPath], with: .none)
                
            }
            
        }
        
    }
    
}
