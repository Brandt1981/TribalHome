//
//  ZonesTableViewController.swift
//  TribalHome
//
//  Created by Brandt Daniels on 11/22/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

let zoneSegueIdentifier = "ZoneSegueIdentifier"

class ZonesTableViewController: UITableViewController {

    var home: HMHome!
    
    var zones: [HMZone] {
        
        return home.zones.sorted { $0.name < $1.name}
        
    }

    private var selectedZone: HMZone?
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let zoneTVC = segue.destination as? ZoneTableViewController {
            
            zoneTVC.home = home
            zoneTVC.zone = selectedZone
            
        }
        
    }
    
}

// MARK: - UITableViewDataSource

extension ZonesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return zones.count
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return home.name
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let zone = zones[indexPath.row]
        
        cell.textLabel?.text = zone.name
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let zone = zones[indexPath.row]

            let alert = UIAlertController(title: "Delete Zone", message: "Are you sure you want to permanently delete \(zone.name)?", preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { deleteAction in
                
                self.home.removeZone(zone, completionHandler: { error in
                    
                    guard error == nil else {
                        
                        print("Error removing zone: \(String(describing: zone)), error: \(String(describing: error))")
                        
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

extension ZonesTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedZone = zones[indexPath.row]
        
        performSegue(withIdentifier: zoneSegueIdentifier, sender: self)
        
    }
    
}

// MARK: - IBAction

extension ZonesTableViewController {
    
    @IBAction private func addZoneButtonTapped() {
        
        let alertController = UIAlertController(title: "New Zone", message: "What is the name of the new zone?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak alertController] _ in
            
            if let alertController = alertController {
                
                let nameTextField = alertController.textFields![0] as UITextField
                
                let name = nameTextField.text ?? "Zone"
                
                self.home.addZone(withName: name, completionHandler: { zone, error in
                    
                    guard error == nil else {
                        
                        print("Error adding zone: \(String(describing: zone)), error: \(String(describing: error))")
                        
                        return
                    }
                    
                    guard zone != nil else {
                        return
                    }
                    
                    self.tableView.reloadData()
                    
                })
                
            }
        }
        
        addAction.isEnabled = false
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        alertController.addTextField { textField in
            
            textField.placeholder = "Name"
            textField.autocapitalizationType = .words

            NotificationCenter.default.addObserver(
                forName: Notification.Name.UITextFieldTextDidChange,
                object: textField,
                queue: OperationQueue.main,
                using: { notification in
                    
                    addAction.isEnabled = textField.text != ""
                    
            })
            
        }
        
        present(alertController, animated: true, completion: nil)
        
    }
    
}
