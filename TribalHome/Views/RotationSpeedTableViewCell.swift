//
//  RotationSpeedTableViewCell.swift
//  TribalHome
//
//  Created by Brandt Daniels on 11/24/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

class RotationSpeedTableViewCell: UITableViewCell {

    private var characteristic: HMCharacteristic! {
        
        didSet {
            
            rotationSpeedValueLabel.text = nil
            
            characteristic.readValue(completionHandler: { error in
                
                guard error == nil else {
                    
                    return
                }
                
                self.rotationSpeedValueLabel.text = (self.characteristic.value as AnyObject).description + "%"
                self.rotationSpeedSlider.setValue(self.characteristic.value as! Float, animated: false)
                
            })
            
        }
        
    }

    @IBOutlet weak var rotationSpeedValueLabel: UILabel!
    
    @IBOutlet weak var rotationSpeedSlider: UISlider!
    
    @IBAction func rotationSpeedValueChanged(_ sender: UISlider) {
        
        self.rotationSpeedValueLabel.text = String(describing: Int(sender.value)) + "%"
        
    }
    
    @IBAction func rotationSpeedUpdated(_ sender: UISlider) {
        
        characteristic.writeValue(Int(sender.value), completionHandler: { error in
            
            guard error == nil else {
                
                return
                
            }
            
            self.rotationSpeedValueLabel.text = (self.characteristic.value as AnyObject).description + "%"
            self.rotationSpeedSlider.setValue(self.characteristic.value as! Float, animated: true)
            
        })
        
    }
    
}

extension RotationSpeedTableViewCell {
    
    func configure(with characteristic: HMCharacteristic!) {
        
        self.characteristic = characteristic
        
    }
    
}
