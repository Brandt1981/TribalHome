//
//  ActionSetTableViewController.swift
//  TribalHome
//
//  Created by Brandt Daniels on 11/28/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

let actionAccessorySelectionSegueIdentifier = "ActionAccessorySelectionSegueIdentifier"

class ActionSetTableViewController: UITableViewController {
    
    var home: HMHome!
    
    var actionSet: HMActionSet! {
        
        didSet {
            
            navigationItem.title = actionSet.name
            
        }
        
    }
    
    private var actions: [HMAction] {
        
        return Array(actionSet.actions)
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let navController = segue.destination as? UINavigationController, let accessorySelectionTVC = navController.topViewController as? AccessorySelectionTableViewController {
            
            accessorySelectionTVC.accessories = home.accessories
            accessorySelectionTVC.delegate = self
            
        }
        
    }
    
}

// MARK: - UITableViewDataSource

extension ActionSetTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return actions.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let action = actions[indexPath.row]
        
        cell.textLabel?.text = String(describing: action.uniqueIdentifier)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let action = actions[indexPath.row]
            
            let alert = UIAlertController(title: "Remove Action", message: "Are you sure you want to remove \(String(describing: action.uniqueIdentifier)) from \(actionSet.name)?", preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let deleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: { deleteAction in
                
                self.actionSet.removeAction(action, completionHandler: { error in
                    
                    guard error == nil else {
                        
                        print("Error removing action \(String(describing: action.uniqueIdentifier)), error: \(String(describing: error))")
                        
                        return
                    }
                    
                    self.tableView.reloadData()
                    
                })
                
            })
            
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
            
        }
        
    }
    
}

// MARK: - AccessorySelectionDelegate

extension ActionSetTableViewController: AccessorySelectionDelegate {
    
    func accessorySelectionTableViewController(_ accessorySelectionTableViewController: AccessorySelectionTableViewController, didSelectAccessories accessories: [HMAccessory]) {
        
        for accessory in accessories {
            
            for service in accessory.services {
                
                for characteristic in service.characteristics {
                    
                    if characteristic.properties.contains(HMCharacteristicPropertyWritable) {
                        
                        if let targetValue = characteristic.value as? NSCopying {
                            
                            let writeAction = HMCharacteristicWriteAction(characteristic: characteristic, targetValue: targetValue)
                            
                            actionSet.addAction(writeAction, completionHandler: { error in
                                
                                guard error == nil else {
                                    
                                    print("Error adding action \(String(describing: writeAction)), error: \(String(describing: error))")
                                    
                                    return
                                }
                                
                                self.tableView.reloadData()
                                
                            })
                            
                        }
                    }
                }
                
            }
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

// MARK: - IBAction

extension ActionSetTableViewController {
    
    @IBAction private func addActionButtonTapped() {
        
        performSegue(withIdentifier: actionAccessorySelectionSegueIdentifier, sender: self)
        
    }
}
