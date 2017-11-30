//
//  ActionSetsTableViewController.swift
//  TribalHome
//
//  Created by Brandt Daniels on 11/22/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

let actionSetSegueIdentifier = "ActionSetSegueIdentifier"

class ActionSetsTableViewController: UITableViewController {

    var home: HMHome!
    
    private var actionSets: [HMActionSet] {
        
        return home.actionSets
        
    }
    
    private var selectedActionSet: HMActionSet?
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let actionSetTVC = segue.destination as? ActionSetTableViewController {
            
            actionSetTVC.actionSet = selectedActionSet
            
        }
        
    }

}

// MARK: - UITableDataSource

extension ActionSetsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return actionSets.count
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return home.name
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let actionSet = actionSets[indexPath.row]
        
        cell.textLabel?.text = actionSet.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let actionSet = actionSets[indexPath.row]
            
            let alert = UIAlertController(title: "Delete Action Set", message: "Are you sure you want to permanently delete \(actionSet.name)?", preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { deleteAction in
                
                self.home.removeActionSet(actionSet, completionHandler: { error in
                    
                    guard error == nil else {
                        
                        print("Error removing action set: \(String(describing: actionSet)), error: \(String(describing: error))")
                        
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

extension ActionSetsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedActionSet = actionSets[indexPath.row]
        
        performSegue(withIdentifier: actionSetSegueIdentifier, sender: self)
        
    }
    
}

// MARK: - IBAction

extension ActionSetsTableViewController {
    
    @IBAction private func addActionSetButtonTapped() {
        
        let alertController = UIAlertController(title: "New Action Set", message: "What is the name of the new action set?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak alertController] _ in
            
            if let alertController = alertController {
                
                let nameTextField = alertController.textFields![0] as UITextField
                
                let name = nameTextField.text ?? "ActionSet"
                
                self.home.addActionSet(withName: name, completionHandler: { actionSet, error in
                    
                    guard error == nil else {
                        
                        print("Error adding action set: \(String(describing: actionSet)), error: \(String(describing: error))")
                        
                        return
                    }
                    
                    guard actionSet != nil else {
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
