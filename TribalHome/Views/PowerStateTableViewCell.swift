//
//  PowerStateTableViewCell.swift
//  TribalHome
//
//  Created by Brandt Daniels on 11/15/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

let powerStateCellReuseIdentifier = "PowerStateCellReuseIdentifier"

class PowerStateTableViewCell: UITableViewCell {

    var characteristic: HMCharacteristic! {
        
        didSet {
            
            if let onState = self.characteristic.value as? Bool {
                self.powerSwitch.setOn(onState, animated: true)
            }
            
            characteristic.readValue(completionHandler: { error in
                
                guard error == nil else {
                    
                    return
                }
                
                self.powerSwitch.setOn(self.characteristic.value as! Bool, animated: false)
                
            })
            
            textLabel?.text = characteristic.localizedDescription
            powerSwitch.addTarget(self, action: #selector(handlePowerSwitchUpdate(_:)), for: .valueChanged)

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
            
            self.powerSwitch.setOn(self.characteristic.value as! Bool, animated: true)
            
        })
        
    }
    
}
