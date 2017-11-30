//
//  RoomsTableViewController.swift
//  TribalHome
//
//  Created by Brandt Daniels on 11/21/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

let roomSegueIdentifier = "RoomSegueIdentifier"

class RoomsTableViewController: UITableViewController {

    var home: HMHome!
    
    private var rooms: [HMRoom] {
        
        return home.rooms
        
    }
    
    private var selectedRoom: HMRoom?
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let roomTVC = segue.destination as? RoomTableViewController {
            
            roomTVC.home = home
            roomTVC.room = selectedRoom
            
        }
        
    }

}

// MARK: - UITableViewDataSource

extension RoomsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return rooms.count
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return home.name
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let room = rooms[indexPath.row]
        
        cell.textLabel?.text = room.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let room = rooms[indexPath.row]
            
            let alert = UIAlertController(title: "Delete Room", message: "Are you sure you want to permanently delete \(room.name)?", preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { deleteAction in
                
                self.home.removeRoom(room, completionHandler: { error in
                    
                    guard error == nil else {
                        
                        print("Error removing room: \(String(describing: room)), error: \(String(describing: error))")
                        
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

extension RoomsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        selectedRoom = rooms[indexPath.row]
        
        performSegue(withIdentifier: roomSegueIdentifier, sender: self)
    
    }
    
}

// MARK: - IBAction

extension RoomsTableViewController {
    
    @IBAction private func addRoomButtonTapped() {
        
        let alertController = UIAlertController(title: "New Room", message: "What is the name of the new room?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak alertController] _ in
            
            if let alertController = alertController {
                
                let nameTextField = alertController.textFields![0] as UITextField
                
                let name = nameTextField.text ?? "Room"
                
                self.home.addRoom(withName: name, completionHandler: { room, error in
                    
                    guard error == nil else {
                        
                        print("Error adding room: \(String(describing: room)), error: \(String(describing: error))")
                        
                        return
                    }
                    
                    guard room != nil else {
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
