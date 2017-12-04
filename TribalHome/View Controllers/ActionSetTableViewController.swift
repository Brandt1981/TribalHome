//
//  ActionSetTableViewController.swift
//  TribalHome
//
//  Created by Brandt Daniels on 11/28/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

class ActionSetTableViewController: UITableViewController {

    var actionSet: HMActionSet! {
        
        didSet {
            
            navigationItem.title = actionSet.name
            
        }
        
    }
    
    private var actions: [HMAction] {
        
        return Array(actionSet.actions)
        
    }

}

// MARK: - UITableViewDataSource

extension ActionSetTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return actions.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let action = actions[indexPath.row]
        
        cell.textLabel?.text = String(describing: action.uniqueIdentifier)
        
        return cell
    }
    
}
