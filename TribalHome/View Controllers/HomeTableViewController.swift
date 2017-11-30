//
//  HomeTableViewController.swift
//  TribalHome
//
//  Created by Brandt Daniels on 11/21/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

let accessoriesSegueIdentifier = "AccessoriesSegueIdentifier"

let roomsSegueIdentifier = "RoomsSegueIdentifier"

let zonesSegueIdentifier = "ZonesSegueIdentifier"

let serviceGroupsSegueIdentifier = "ServiceGroupsSegueIdentifier"

let actionSetsSegueIdentifier = "ActionSetsSegueIdentifier"

class HomeTableViewController: UITableViewController {

    var home: HMHome! {
        
        didSet {
            
            self.navigationItem.title = home.name
            
        }
        
    }
    
    private enum HomeRow: Int {
        
        case accessories, rooms, zones, serviceGroups, actionSets

        
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let row = HomeRow(rawValue: indexPath.row) {
            
            switch row {
                
            case .accessories:
                performSegue(withIdentifier: accessoriesSegueIdentifier, sender: self)
            case .rooms:
                performSegue(withIdentifier: roomsSegueIdentifier, sender: self)
            case .zones:
                performSegue(withIdentifier: zonesSegueIdentifier, sender: self)
            case .serviceGroups:
                performSegue(withIdentifier: serviceGroupsSegueIdentifier, sender: self)
            case .actionSets:
                performSegue(withIdentifier: actionSetsSegueIdentifier, sender: self)
                
            }
            
        }
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let accessoriesTVC = segue.destination as? AccessoriesTableViewController {
            
            accessoriesTVC.home = home
            
        } else if let roomsTVC = segue.destination as? RoomsTableViewController {
            
            roomsTVC.home = home
            
        } else if let zonesTVC = segue.destination as? ZonesTableViewController {
            
            zonesTVC.home = home
            
        } else if let serviceGroupsTVC = segue.destination as? ServiceGroupsTableViewController {
            
            serviceGroupsTVC.home = home
            
        } else if let actionSetsTVC = segue.destination as? ActionSetsTableViewController {
            
            actionSetsTVC.home = home
            
        }
        
    }
    

}
