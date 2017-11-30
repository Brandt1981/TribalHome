//
//  IdentifyTableViewCell.swift
//  TribalHome
//
//  Created by Brandt Daniels on 11/16/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

let identifyTableViewCellNibName = "IdentifyTableViewCell"

class IdentifyTableViewCell: UITableViewCell {

    private var characteristic: HMCharacteristic!
    
    @IBAction func identifyButtonTapped(_ sender: UIButton) {
        
        characteristic.writeValue(true, completionHandler: { error in
            
            guard error == nil else {
                return
            }
            
        })
        
    }
    
}

extension IdentifyTableViewCell {
    
    func configure(with characteristic: HMCharacteristic!) {
        
        self.characteristic = characteristic
        
    }
    
}
