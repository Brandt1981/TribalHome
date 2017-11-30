//
//  RotationDirectionTableViewCell.swift
//  TribalHome
//
//  Created by Brandt Daniels on 11/24/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

class RotationDirectionTableViewCell: UITableViewCell {

    private var characteristic: HMCharacteristic! {
        
        didSet {
            
            descriptionLabel.text = characteristic.localizedDescription
            
            characteristic.readValue(completionHandler: { error in
                
                guard error == nil else {
                    
                    return
                }
                
                self.directionSelector.selectedSegmentIndex = self.characteristic.value as! Int
                
            })
            
        }
        
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var directionSelector: UISegmentedControl!
 
    @IBAction private func directionChanged() {
        
        characteristic.writeValue(directionSelector.selectedSegmentIndex, completionHandler: { error in
            
            guard error == nil else {
                
                return
                
            }
            
            self.directionSelector.selectedSegmentIndex = self.characteristic.value as! Int
            
        })
        
    }
    
}

extension RotationDirectionTableViewCell {
    
    func configure(with characteristic: HMCharacteristic!) {
        
        self.characteristic = characteristic
        
    }
    
}
