//
//  EditHomeTableViewController.swift
//  TribalHome
//
//  Created by Brandt Daniels on 12/21/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

let editHomeUnwindSegueIdentifier = "EditHomeUnwindSegueIdentifier"

let editNameSegueIdentifier = "EditNameSegueIdentifier"

class EditHomeTableViewController: UITableViewController {

    var homeManager: HMHomeManager!
    
    var home: HMHome! {
        
        didSet {
            
            home.delegate = self
            
            navigationItem.title = home.name
            
        }
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let editNameTVC = segue.destination as? EditNameTableViewController {
            
            editNameTVC.home = home
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if cell.reuseIdentifier == "nameReuseIdentifier" {
            cell.detailTextLabel?.text = home.name
        } else if cell.reuseIdentifier == "currentUserReuseIdentifier" {
            cell.detailTextLabel?.text = home.currentUser.name
        } else if cell.reuseIdentifier == "homeHubReuseIdentifier" {
            cell.detailTextLabel?.text = home.stringForHomeHubState()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if let reuseIdentifier = cell?.reuseIdentifier {
            
            if reuseIdentifier == "nameReuseIdentifier" {
                
                performSegue(withIdentifier: editNameSegueIdentifier, sender: self)
                
            } else if reuseIdentifier == "manageUsersReuseIdentifier" {
                
                home.manageUsers(completionHandler: { error in
                    
                    guard error == nil else {
                        return
                    }
 
                    self.tableView.deselectRow(at: indexPath, animated: true)
                    
                })
                
            }
            
        }
        
    }

}

// MARK: - IBAction

extension EditHomeTableViewController {
    
    @IBAction private func deleteHomeTapped() {
        
        let alert = UIAlertController(title: "Delete Home", message: "Are you sure you want to permanently delete \(home.name)?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { deleteAction in
            
            self.homeManager.removeHome(self.home, completionHandler: { error in
                
                guard error == nil else {
                    
                    print("Error removing home: \(String(describing: self.home)), error: \(String(describing: error))")
                    
                    return
                    
                }
                
                self.performSegue(withIdentifier: editHomeUnwindSegueIdentifier, sender: self)
                
            })
            
        })
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

extension EditHomeTableViewController: HMHomeDelegate {
    
    func homeDidUpdateName(_ home: HMHome) {
        
        if home == self.home {
            
            navigationItem.title = home.name
            
            tableView.reloadData()
            
        }
        
    }
    
}

// MARK: - HMHome

extension HMHome {
    
    func stringForHomeHubState() -> String {
        
        switch homeHubState {
            
        case .notAvailable:
            return "Not Available"
        case .connected:
            return "Connected"
        case .disconnected:
            return "Disconnected"
        
        }
        
    }
    
}
