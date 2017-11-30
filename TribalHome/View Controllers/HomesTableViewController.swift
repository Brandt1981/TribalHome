//
//  HomesTableViewController.swift
//  HomeKitDemo
//
//  Created by Brandt Daniels on 11/14/17.
//  Copyright © 2017 Brandt Daniels. All rights reserved.
//

import HomeKit
import UIKit

let homeSegueIdentifier = "HomeSegueIdentifier"

class HomesTableViewController: UITableViewController {

    private let homeManager = HMHomeManager()
    
    private var selectedHome: HMHome?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeManager.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()

    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let homeTVC = segue.destination as? HomeTableViewController, let home = selectedHome {
            
            homeTVC.home = home
            
        }
        
    }

}

// MARK: - UITableViewDataSource

extension HomesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return homeManager.homes.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let home = homeManager.homes[indexPath.row]
        
        cell.textLabel?.text = home.name
        
        cell.detailTextLabel?.text = home.isPrimary ? "Primary" : nil
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let home = homeManager.homes[indexPath.row]
        
        return !home.isPrimary
        
    }
    
    override func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let home = homeManager.homes[indexPath.row]
            
            let alert = UIAlertController(title: "Delete Home", message: "Are you sure you want to permanently delete \(home.name)?", preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { deleteAction in
                
                self.homeManager.removeHome(home, completionHandler: { error in
                    
                    guard error == nil else {
                        
                        print("Error removing home: \(String(describing: home)), error: \(String(describing: error))")

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

extension HomesTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedHome = homeManager.homes[indexPath.row]
        
        performSegue(withIdentifier: homeSegueIdentifier, sender: self)
        
    }
    
}

// MARK: - IBAction

extension HomesTableViewController {
    
    @IBAction private func addHomeButtonTapped() {
        
        let alertController = UIAlertController(title: "New Home", message: "What is the name of the new home?", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak alertController] _ in
            
            if let alertController = alertController {
                
                let nameTextField = alertController.textFields![0] as UITextField
                
                let name = nameTextField.text ?? "Home"
                
                self.homeManager.addHome(withName: name) { home, error in
                    
                    guard error == nil else {
                        
                        print("Error adding home: \(String(describing: home)), error: \(String(describing: error))")
                        
                        return
                    }
                    
                    guard home != nil else {
                        return
                    }
                    
                    self.tableView.reloadData()

                }
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

// MARK: - HMHomeManagerDelegate

extension HomesTableViewController: HMHomeManagerDelegate {
    
    func homeManager(_ manager: HMHomeManager, didAdd home: HMHome) {
        
        tableView.reloadData()
        
    }
    
    func homeManager(_ manager: HMHomeManager, didRemove home: HMHome) {
        
        tableView.reloadData()
        
    }
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        
        tableView.reloadData()
        
    }
    
    func homeManagerDidUpdatePrimaryHome(_ manager: HMHomeManager) {
        
        tableView.reloadData()
        
    }
    
}
