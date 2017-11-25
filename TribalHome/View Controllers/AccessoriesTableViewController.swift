//
//  AccessoriesTableViewController.swift
//  TribalHome
//
//  Created by TSL043 on 11/14/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

let accessorySegueIdentifier = "AccessorySegueIdentifier"

let accessoryBrowserSegueIdentifier = "AccessoryBrowserSegueIdentifier"

class AccessoriesTableViewController: UITableViewController {

    var home: HMHome!
    
    var room: HMRoom?
    
    private var accessories: [HMAccessory] {
    
        if let roomAccessories = room?.accessories {
            
            return roomAccessories.filter { $0.category.categoryType != HMAccessoryCategoryTypeBridge }.sorted { $0.name < $1.name}
            
        } else {
            
            return home.accessories.filter { $0.category.categoryType != HMAccessoryCategoryTypeBridge }.sorted { $0.name < $1.name}
            
        }
        
    }
    
    private var selectedAccessory: HMAccessory?
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let navController = segue.destination as? UINavigationController,
            let accessoryBrowserTVC = navController.topViewController as? AccessoryBrowserTableViewController {
            
            accessoryBrowserTVC.home = home
            
        } else if let accessoryTVC = segue.destination as? AccessoryTableViewController {
          
            accessoryTVC.home = home
            accessoryTVC.accessory = selectedAccessory
            
        }
        
    }
    
}

// MARK: - UITableViewDataSource

extension AccessoriesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return accessories.count
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return room?.name ?? home.name
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let accessory = accessories[indexPath.row]
        
        cell.textLabel?.text = accessory.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let accessory = accessories[indexPath.row]
            
            let alert = UIAlertController(title: "Delete Accessory", message: "Are you sure you want to permanently delete \(accessory.name)?", preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { deleteAction in
                
                self.home.removeAccessory(accessory, completionHandler: { error in
                    
                    guard error == nil else {
                        
                        print("Error removing accessory: \(String(describing: accessory)), error: \(String(describing: error))")
                        
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

// MARK: - UITableViewDelegate

extension AccessoriesTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedAccessory = accessories[indexPath.row]
        
        performSegue(withIdentifier: accessorySegueIdentifier, sender: self)
        
    }
    
}

// MARK: - IBAction

private extension AccessoriesTableViewController {
    
    @IBAction private func addAccessoryButtonTapped() {

        performSegue(withIdentifier: accessoryBrowserSegueIdentifier, sender: self)
        
    }
    
    @IBAction private func unwindToAccessoriesTVC(segue: UIStoryboardSegue) {
        
        tableView.reloadData()
        
    }
    
}
