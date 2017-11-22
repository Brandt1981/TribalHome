//
//  ServiceGroupsTableViewController.swift
//  TribalHome
//
//  Created by TSL043 on 11/22/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

class ServiceGroupsTableViewController: UITableViewController {

    var home: HMHome!
    
    private var serviceGroups: [HMServiceGroup] {
        
        return home.serviceGroups
        
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
    
}
