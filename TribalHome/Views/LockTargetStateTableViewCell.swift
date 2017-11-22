//
//  LockTargetStateTableViewCell.swift
//  TribalHome
//
//  Created by TSL043 on 11/16/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

let lockTargetStateTableViewCellNibName = "LockTargetStateTableViewCell"

class LockTargetStateTableViewCell: UITableViewCell {
    
    private var characteristic: HMCharacteristic! {
        
        didSet {
            
            descriptionLabel.text = characteristic.localizedDescription
            
            characteristic.readValue(completionHandler: { error in
                
                guard error == nil else {
                    
                    return
                }
                
                self.lockControl.selectedSegmentIndex = self.characteristic.value as! Int
                
            })
            
        }
        
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var lockControl: UISegmentedControl!
    
    @IBAction private func lockControlChanged() {
        
        characteristic.writeValue(lockControl.selectedSegmentIndex, completionHandler: { error in
            
            guard error == nil else {
                
                return
                
            }
            
            self.lockControl.selectedSegmentIndex = self.characteristic.value as! Int

        })
        
    }

}

extension LockTargetStateTableViewCell {
    
    func configure(with characteristic: HMCharacteristic!) {
        
        self.characteristic = characteristic
        
    }
    
}
