//
//  CharacteristicsTableViewController.swift
//  TribalHome
//
//  Created by TSL043 on 11/15/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

class CharacteristicsTableViewController: UITableViewController {
    
    var service: HMService!
    
    private var characteristics: [HMCharacteristic] {
        
        return service.characteristics
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.register(PowerStateTableViewCell.self, forCellReuseIdentifier: powerStateCellReuseIdentifier)
        
        tableView.register(UINib(nibName: brightnessTableViewCellNibName, bundle: nil), forCellReuseIdentifier: String(describing: BrightnessTableViewCell.self))
        
        tableView.register(UINib(nibName: hueTableViewCellNibName, bundle: nil), forCellReuseIdentifier: String(describing: HueTableViewCell.self))
        
        tableView.register(UINib(nibName: saturationTableViewCellNibName, bundle: nil), forCellReuseIdentifier: String(describing: SaturationTableViewCell.self))
        
        tableView.register(UINib(nibName: lockTargetStateTableViewCellNibName, bundle: nil), forCellReuseIdentifier: String(describing: LockTargetStateTableViewCell.self))
        
        tableView.register(UINib(nibName: identifyTableViewCellNibName, bundle: nil), forCellReuseIdentifier: String(describing: IdentifyTableViewCell.self))
        
        for characteristic in characteristics {
            
            if characteristic.properties.contains(HMCharacteristicPropertySupportsEventNotification) {
                
                characteristic.enableNotification(true, completionHandler: { error in
                    
                    guard error == nil else {
                        return
                    }
                    
                })
                
            }
            
        }
        
        service.accessory?.delegate = self

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        for characteristic in characteristics {
            
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

// MARK: - UITableViewDataSource

extension CharacteristicsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return characteristics.count
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return service.name
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let characteristic = characteristics[indexPath.row]
        
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

extension CharacteristicsTableViewController: HMAccessoryDelegate {
    
    func accessory(_ accessory: HMAccessory, service: HMService, didUpdateValueFor characteristic: HMCharacteristic) {
        
        if let index = characteristics.index(of: characteristic) {
            
            let indexPath = IndexPath(row: index, section: 0)
            
            tableView.reloadRows(at: [indexPath], with: .none)
            
        }
        
    }
    
}
