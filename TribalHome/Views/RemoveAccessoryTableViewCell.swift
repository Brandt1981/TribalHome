//
//  RemoveAccessoryTableViewCell.swift
//  TribalHome
//
//  Created by TSL043 on 11/24/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

protocol RemoveAccessoryDelegate {
    func remove(accessory: HMAccessory)
}

class RemoveAccessoryTableViewCell: UITableViewCell {

    private var accessory: HMAccessory!
    
    private var delegate: RemoveAccessoryDelegate!
    
    @IBAction private func removeAccessoryButtonTapped() {
        
        delegate.remove(accessory: accessory)
        
    }
    
}

extension RemoveAccessoryTableViewCell {
    
    func configure(with accessory: HMAccessory!, delegate: RemoveAccessoryDelegate) {
        
        self.accessory = accessory
        
        self.delegate = delegate
        
    }
    
}
