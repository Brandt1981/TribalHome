//
//  ServiceGroupTableViewController.swift
//  TribalHome
//
//  Created by Brandt Daniels on 11/29/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

let serviceSelectionSegueIdentifier = "ServiceSelectionSegueIdentifier"

class ServiceGroupTableViewController: UITableViewController {

    var home: HMHome! {
        
        didSet {
            
            home.delegate = self
            
        }
        
    }
    
    var serviceGroup: HMServiceGroup! {
        
        didSet {
            
            navigationItem.title = serviceGroup.name
            
        }
        
    }
    
    private var services: [HMService] {
        
        return serviceGroup.services.sorted { $0.name < $1.name}
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let navController = segue.destination as? UINavigationController, let serviceSelectionTVC = navController.topViewController as? ServiceSelectionTableViewController {
            
            serviceSelectionTVC.home = home
            
        }
        
    }

}

// MARK: - UITableViewDataSource

extension ServiceGroupTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return services.count

    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Services"

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let service = services[indexPath.row]
        
        cell.textLabel?.text = service.name
        
        cell.detailTextLabel?.text = service.accessory?.name
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let service = services[indexPath.row]
            
            let alert = UIAlertController(title: "Remove Service", message: "Are you sure you want to remove \(service.name) from \(serviceGroup.name)?", preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let deleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: { deleteAction in
                
                self.serviceGroup.removeService(service, completionHandler: { error in
                    
                    guard error == nil else {
                        
                        print("Error removing service: \(String(describing: service)), error: \(String(describing: error))")
                        
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

// MARK: - IBAction

extension ServiceGroupTableViewController {
    
    @IBAction private func addServiceButtonTapped() {
        
        performSegue(withIdentifier: serviceSelectionSegueIdentifier, sender: self)

    }
    
    @IBAction private func unwindToServiceGroupTVC(segue: UIStoryboardSegue) {
        
        if let serviceSelectionTVC = segue.source as? ServiceSelectionTableViewController {
            
            for service in serviceSelectionTVC.selectedServices {
                
                serviceGroup.addService(service, completionHandler: { error in
                    
                    guard error == nil else {
                        
                        print("Error adding service: \(String(describing: service)), error: \(String(describing: error))")
                        
                        return
                    }
                    
                    self.tableView.reloadData()
                    
                })
                
            }
        }
        
    }
    
}

// MARK: - HMHomeDelegate

extension ServiceGroupTableViewController: HMHomeDelegate {
    
    func home(_ home: HMHome, didUpdateNameFor group: HMServiceGroup) {
        
        if group == serviceGroup {
            
            navigationItem.title = group.name
            
        }
        
    }
    
    func home(_ home: HMHome, didRemove group: HMServiceGroup) {
        
        if group == serviceGroup {
            
            navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    func home(_ home: HMHome, didAdd service: HMService, to group: HMServiceGroup) {
        
        if group == serviceGroup {
            
            tableView.reloadData()
            
        }
        
    }
    
    func home(_ home: HMHome, didRemove service: HMService, from group: HMServiceGroup) {
        
        if group == serviceGroup {
            
            tableView.reloadData()
            
        }
        
    }
    
}
