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

let accessorySelectionSegueIdentifier = "AccessorySelectionSegueIdentifier"

class RoomTableViewController: UITableViewController {

    var home: HMHome! {
        
        didSet {
            
            home.delegate = self
            
        }
        
    }
    
    var room: HMRoom! {
        
        didSet {
            
            navigationItem.title = room.name
            
        }
        
    }
    
    private var accessories: [HMAccessory] {
        
        return room.accessories.sorted { $0.name < $1.name}
        
    }
    
    private var selectedAccessory: HMAccessory?
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let accessoryTVC = segue.destination as? AccessoryTableViewController {
            
            accessoryTVC.home = home
            accessoryTVC.accessory = selectedAccessory
            
        } else if let navController = segue.destination as? UINavigationController, let accessorySelectionTVC = navController.topViewController as? AccessorySelectionTableViewController {
            
            accessorySelectionTVC.accessories = home.roomForEntireHome().accessories
            accessorySelectionTVC.delegate = self
            
        }
        
    }

}

// MARK: - UITableViewDataSource

extension RoomTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return accessories.count
        
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
            
            let alert = UIAlertController(title: "Remove Accessory", message: "Are you sure you want to remove \(accessory.name) from \(room.name)?", preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let deleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: { deleteAction in
                
                self.home.assignAccessory(accessory, to: self.home.roomForEntireHome(), completionHandler: { error in
                    
                    guard error == nil else {
                        
                        print("Error assigning accessory \(String(describing: accessory)), error: \(String(describing: error))")
                        
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

extension RoomTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedAccessory = accessories[indexPath.row]
        
        performSegue(withIdentifier: roomAccessorySegueIdentifier, sender: self)
        
    }
}

// MARK: - AccessorySelectionDelegate

extension RoomTableViewController: AccessorySelectionDelegate {
    
    func accessorySelectionTableViewController(_ accessorySelectionTableViewController: AccessorySelectionTableViewController, didSelectAccessories accessories: [HMAccessory]) {
        
        for accessory in accessories {
            
            self.home.assignAccessory(accessory, to: room, completionHandler: { error in
                
                guard error == nil else {
                    
                    print("Error assigning accessory \(String(describing: accessory)), error: \(String(describing: error))")
                    
                    return
                }
                
                self.tableView.reloadData()
                
            })
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

// MARK: - HMHomeDelegate

extension RoomTableViewController: HMHomeDelegate {
    
    func home(_ home: HMHome, didRemove room: HMRoom) {
        
        if room == self.room {
            
            navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    func home(_ home: HMHome, didUpdateNameFor room: HMRoom) {
        
        if room == self.room {
            
            navigationItem.title = room.name
            
        }
        
    }
    
    func home(_ home: HMHome, didRemove accessory: HMAccessory) {
        
        if room.accessories.contains(accessory) {
            
            tableView.reloadData()
            
        }
        
    }
    
    func home(_ home: HMHome, didUpdate room: HMRoom, for accessory: HMAccessory) {
        
        if room == self.room {
            
            tableView.reloadData()
            
        }
        
    }
    
}

// MARK: - IBAction

extension RoomTableViewController {
    
    @IBAction private func addAccessoryButtonTapped() {
        
        performSegue(withIdentifier: accessorySelectionSegueIdentifier, sender: self)

    }
    
}
