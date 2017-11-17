//
//  PowerStateTableViewCell.swift
//  TribalHome
//
//  Created by TSL043 on 11/15/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

let powerStateCellReuseIdentifier = "PowerStateCellReuseIdentifier"

class PowerStateTableViewCell: UITableViewCell {

    var characteristic: HMCharacteristic! {
        
        didSet {
            textLabel?.text = characteristic.localizedDescription
            powerSwitch.addTarget(self, action: #selector(handlePowerSwitchUpdate(_:)), for: .valueChanged)
            powerSwitch.setOn(characteristic.value as! Bool, animated: false)
        }
        
    }
    
    private let powerSwitch = UISwitch()

}

extension PowerStateTableViewCell {
    
    func configure(with characteristic: HMCharacteristic) {
        
        self.characteristic = characteristic
        
        accessoryView = powerSwitch
        
    }
    
    @objc private func handlePowerSwitchUpdate(_ sender: UISwitch) {
        
        characteristic.writeValue(powerSwitch.isOn, completionHandler: { error in
            
            guard error == nil else {
                
                return
                
            }
            
            self.powerSwitch.setOn(self.characteristic.value as! Bool, animated: true)
            
        })
        
    }
    
}
