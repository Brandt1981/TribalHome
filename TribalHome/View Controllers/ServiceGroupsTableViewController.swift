//
//  ServiceGroupsTableViewController.swift
//  TribalHome
//
//  Created by Brandt Daniels on 11/22/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

let serviceGroupSegueIdentifier = "ServiceGroupSegueIdentifier"

class ServiceGroupsTableViewController: UITableViewController {

    var home: HMHome!
    
    private var serviceGroups: [HMServiceGroup] {
        
        return home.serviceGroups
        
    }
    
    private var selectedServiceGroup: HMServiceGroup?
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let serviceGroupTVC = segue.destination as? ServiceGroupTableViewController {
            
            serviceGroupTVC.serviceGroup = selectedServiceGroup
            
        }
        
    }

}

// MARK: - UITableViewDataSource

extension ServiceGroupsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return serviceGroups.count
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return home.name
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let serviceGroup = serviceGroups[indexPath.row]
        
        cell.textLabel?.text = serviceGroup.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let serviceGroup = serviceGroups[indexPath.row]
            
            let alert = UIAlertController(title: "Delete Service Group", message: "Are you sure you want to permanently delete \(serviceGroup.name)?", preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { deleteAction in
                
                self.home.removeServiceGroup(serviceGroup, completionHandler: { error in
                    
                    guard error == nil else {
                        
                        print("Error removing service group: \(String(describing: serviceGroup)), error: \(String(describing: error))")
                        
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

extension ServiceGroupsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedServiceGroup = serviceGroups[indexPath.row]
        
        performSegue(withIdentifier: serviceGroupSegueIdentifier, sender: self)
        
    }
    
}

// MARK: - IBAction

extension ServiceGroupsTableViewController {
    
    @IBAction private func addServiceGroupButtonTapped() {
        
        let alertController = UIAlertController(title: "New Service Group", message: "What is the name of the new service group?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak alertController] _ in
            
            if let alertController = alertController {
                
                let nameTextField = alertController.textFields![0] as UITextField
                
                let name = nameTextField.text ?? "ServiceGroup"
                
                self.home.addServiceGroup(withName: name, completionHandler: { serviceGroup, error in
                    
                    guard error == nil else {
                        
                        print("Error adding service group: \(String(describing: serviceGroup)), error: \(String(describing: error))")
                        
                        return
                    }
                    
                    guard serviceGroup != nil else {
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
