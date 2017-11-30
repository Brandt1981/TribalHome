//
//  RoomSelectionTableViewController.swift
//  TribalHome
//
//  Created by Brandt Daniels on 11/29/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

class RoomSelectionTableViewController: UITableViewController {

    var home: HMHome!
    
    var zone: HMZone!
    
    var selectedRooms = [HMRoom]()
    
    private var availableRooms: [HMRoom] {
        
        return Array(Set(home.rooms).subtracting(Set(zone.rooms)))
        
    }
    
}

// MARK: - UITableViewDataSource

extension RoomSelectionTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableRooms.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let room = availableRooms[indexPath.row]
        
        cell.textLabel?.text = room.name
        
        if selectedRooms.contains(room) {
            
            cell.accessoryType = .checkmark
            
        } else {
            
            cell.accessoryType = .none
            
        }
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension RoomSelectionTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let room = availableRooms[indexPath.row]
        
        if selectedRooms.contains(room) {
            
            if let roomIndex = selectedRooms.index(of: room) {
            
                selectedRooms.remove(at: roomIndex)
                
            }
            
        } else {
            
            selectedRooms.append(room)
            
        }
        
        tableView.reloadData()
        
    }
    
}

// MARK: - IBAction

extension RoomSelectionTableViewController {
    
    @IBAction private func doneButtonTapped() {
        
        
    }
}
