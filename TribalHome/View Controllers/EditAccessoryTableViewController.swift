//
//  EditAccessoryTableViewController.swift
//  TribalHome
//
//  Created by Brandt Daniels on 11/24/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

let editAccessoryUnwindSegueIdentifier = "EditAccessoryUnwindSegueIdentifier"

class EditAccessoryTableViewController: UITableViewController {
    
    var home: HMHome!
    
    var accessory: HMAccessory! {
        
        didSet {
            
            navigationItem.title = accessory.name
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: String(describing: IdentifyTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: IdentifyTableViewCell.self))
        
        tableView.register(UINib(nibName: String(describing: RemoveAccessoryTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: RemoveAccessoryTableViewCell.self))
        
    }
    
}

// MARK: - UITableViewDataSource

extension EditAccessoryTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return accessory.services.filter({ (service) -> Bool in
                service.serviceType != HMServiceTypeAccessoryInformation
            }).count
        case 1:
            
            if let informationService = accessory.services.first(where: { $0.serviceType == HMServiceTypeAccessoryInformation }) {
                
                return informationService.characteristics.count
                
            } else {
                return 0
            }
            
        case 2:
            return 1
        default:
            break
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Services"
        case 1:
            return "Accessory Information"
        default:
            return nil
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        
        let row = indexPath.row
        
        if section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "serviceReuseIdentifier", for: indexPath)
            
            let services = accessory.services.filter({ (service) -> Bool in
                service.serviceType != HMServiceTypeAccessoryInformation
            })
            
            let service = services[row]
            
            cell.textLabel?.text = service.localizedDescription
            
            return cell
            
        } else if section == 1 {
            
            if let informationService = accessory.services.first(where: { $0.serviceType == HMServiceTypeAccessoryInformation }) {
                
                let characteristic = informationService.characteristics[row]
                
                if characteristic.characteristicType == HMCharacteristicTypeIdentify {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: IdentifyTableViewCell.self), for: indexPath) as! IdentifyTableViewCell
                    
                    cell.configure(with: characteristic)
                    
                    return cell
                    
                } else {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "informationReuseIdentifier", for: indexPath)
                    
                    
                    cell.textLabel?.text = characteristic.localizedDescription
                    
                    if characteristic.properties.contains(HMCharacteristicPropertyReadable) {
                        
                        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                        spinner.startAnimating()
                        
                        cell.detailTextLabel?.text = nil
                        cell.accessoryView = spinner
                        
                        characteristic.readValue(completionHandler: { error in
                            
                            cell.accessoryView = nil
                            
                            guard error == nil else {
                                
                                print("error: \(String(describing: error))")
                                
                                cell.detailTextLabel?.text = "X"
                                
                                return
                            }
                            
                            cell.detailTextLabel?.text = (characteristic.value as AnyObject).description
                            
                        })
                        
                    }
                    
                    return cell
                    
                }
                
            }
            
            return UITableViewCell()
            
        } else if section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RemoveAccessoryTableViewCell.self), for: indexPath) as! RemoveAccessoryTableViewCell
            
            cell.configure(with: accessory, delegate: self)
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
            
            return cell
            
        }
        
    }
    
}

// MARK: - RemoveAccessoryDelegate

extension EditAccessoryTableViewController: RemoveAccessoryDelegate {
    
    func remove(accessory: HMAccessory) {
        
        let alert = UIAlertController(title: "Delete Accessory", message: "Are you sure you want to permanently delete \(accessory.name)?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { deleteAction in
            
            self.home.removeAccessory(accessory, completionHandler: { error in
                
                guard error == nil else {
                    
                    print("Error removing accessory: \(String(describing: accessory)), error: \(String(describing: error))")
                    
                    return
                    
                }
                
                self.performSegue(withIdentifier: editAccessoryUnwindSegueIdentifier, sender: self)
                
            })
            
        })
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
