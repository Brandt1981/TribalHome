//
//  ZoneTableViewController.swift
//  TribalHome
//
//  Created by Brandt Daniels on 11/29/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

let zoneRoomSegueIdentifier = "ZoneRoomSegueIdentifier"

let roomSelectionSegueIdentifier = "RoomSelectionSegueIdentifier"

class ZoneTableViewController: UITableViewController {

    var home: HMHome!
    
    var zone: HMZone! {
        
        didSet {
            
            navigationItem.title = zone.name
            
        }
        
    }
    
    private var rooms: [HMRoom] {
        
        return zone.rooms.sorted { $0.name < $1.name}
        
    }
    
    private var selectedRoom: HMRoom?
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let roomTVC = segue.destination as? RoomTableViewController {
            
            roomTVC.room = selectedRoom
            
        } else if let navController = segue.destination as? UINavigationController, let roomSelectionTVC = navController.topViewController as? RoomSelectionTableViewController {
            
            roomSelectionTVC.home = home
            roomSelectionTVC.zone = zone
            
        }
        
    }

}

// MARK: - UITableViewDataSource

extension ZoneTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return rooms.count
        
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
            
            let alert = UIAlertController(title: "Remove Room", message: "Are you sure you want to remove \(room.name) from \(zone.name)?", preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let deleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: { deleteAction in
                
                self.zone.removeRoom(room, completionHandler: { error in
                    
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

extension ZoneTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRoom = rooms[indexPath.row]
        
        performSegue(withIdentifier: zoneRoomSegueIdentifier, sender: self)
        
    }
    
}

// MARK: - IBAction

extension ZoneTableViewController {
    
    @IBAction private func addRoomButtonTapped() {
        
        performSegue(withIdentifier: roomSelectionSegueIdentifier, sender: self)
        
    }
    
    @IBAction private func unwindToZoneTVC(segue: UIStoryboardSegue) {
        
        if let roomSelectionTVC = segue.source as? RoomSelectionTableViewController {
            
            for room in roomSelectionTVC.selectedRooms {
            
                zone.addRoom(room, completionHandler: { error in
                    
                    guard error == nil else {
                        return
                    }
                  
                    self.tableView.reloadData()
                    
                })
            
            }
        }
        
    }
}
