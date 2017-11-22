//
//  ActionSetsTableViewController.swift
//  TribalHome
//
//  Created by TSL043 on 11/22/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

class ActionSetsTableViewController: UITableViewController {

    var home: HMHome!
    
    private var actionSets: [HMActionSet] {
        
        return home.actionSets
        
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
    
}
