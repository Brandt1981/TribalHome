//
//  ServiceGroupTableViewController.swift
//  TribalHome
//
//  Created by Brandt Daniels on 11/29/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

class ServiceGroupTableViewController: UITableViewController {

    var serviceGroup: HMServiceGroup! {
        
        didSet {
            
            navigationItem.title = serviceGroup.name
            
        }
        
    }
    
    private var services: [HMService] {
        
        return serviceGroup.services.sorted { $0.name < $1.name}
        
    }

}

// MARK: - UITableViewDataSource

extension ServiceGroupTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return services.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let service = services[indexPath.row]
        
        cell.textLabel?.text = service.name
        
        return cell
    }
    
}
