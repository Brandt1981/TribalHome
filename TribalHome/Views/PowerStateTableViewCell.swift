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
            
            if let onState = characteristic.value as? Bool {
                powerSwitch.setOn(onState, animated: false)
            }
        }
        
    }
    
    private let powerSwitch = UISwitch()

}

extension PowerStateTableViewCell {
    
    func configure(with characteristic: HMCharacteristic!) {
        
        self.characteristic = characteristic
        
        selectionStyle = .none
        
        accessoryView = powerSwitch
        
    }
    
    @objc private func handlePowerSwitchUpdate(_ sender: UISwitch) {
        
        characteristic.writeValue(powerSwitch.isOn, completionHandler: { error in
            
            guard error == nil else {
                
                return
                
            }
            
            if let onState = self.characteristic.value as? Bool {
                self.powerSwitch.setOn(onState, animated: true)
            }
            
        })
        
    }
    
}
