//
//  AccessoryBrowserTableViewController.swift
//  TribalHome
//
//  Created by Brandt Daniels on 11/14/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

let accessoryBrowserUnwindSegueIdentifier = "AccessoryBrowserUnwindSegueIdentifier"

class AccessoryBrowserTableViewController: UITableViewController {

    var home: HMHome!
    
    private let accessoryBrowser = HMAccessoryBrowser()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        accessoryBrowser.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        accessoryBrowser.startSearchingForNewAccessories()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        accessoryBrowser.stopSearchingForNewAccessories()
        
    }

}

// MARK: - UITableViewDataSource

extension AccessoryBrowserTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return accessoryBrowser.discoveredAccessories.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let accessory = accessoryBrowser.discoveredAccessories[indexPath.row]
        
        cell.textLabel?.text = accessory.name
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension AccessoryBrowserTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        accessoryBrowser.stopSearchingForNewAccessories()
        
        let selectedAccessory = accessoryBrowser.discoveredAccessories[indexPath.row]

        home.addAccessory(selectedAccessory, completionHandler: { error in
            
            guard error == nil else {
                //TODO: Handle error better
                print(String(describing: error))
                self.accessoryBrowser.startSearchingForNewAccessories()
                return
            }
            
            self.performSegue(withIdentifier: accessoryBrowserUnwindSegueIdentifier, sender: self)
            
        })
        
    }
    
}

// MARK: - HMAccessoryBrowserDelegate

extension AccessoryBrowserTableViewController: HMAccessoryBrowserDelegate {
    
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        
        tableView.reloadData()
        
    }
    
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didRemoveNewAccessory accessory: HMAccessory) {
        
        tableView.reloadData()
        
    }
    
}
