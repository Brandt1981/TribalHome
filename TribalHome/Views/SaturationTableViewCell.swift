//
//  SaturationTableViewCell.swift
//  TribalHome
//
//  Created by TSL043 on 11/16/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

let saturationTableViewCellNibName = "SaturationTableViewCell"

class SaturationTableViewCell: UITableViewCell {

    private var characteristic: HMCharacteristic! {
        
        didSet {
            
            saturationValueLabel.text = nil
            
            characteristic.readValue(completionHandler: { error in
                
                guard error == nil else {
                    
                    return
                }
                
                self.saturationValueLabel.text = (self.characteristic.value as AnyObject).description + "%"
                self.saturationSlider.setValue(self.characteristic.value as! Float, animated: false)
                
            })
            
        }
        
    }
    
    @IBOutlet weak var saturationValueLabel: UILabel!
    
    @IBOutlet weak var saturationSlider: UISlider!
    
    @IBAction func saturationValueChanged(_ sender: UISlider) {
        
        self.saturationValueLabel.text = String(describing: Int(sender.value)) + "%"
        
    }
    
    @IBAction func saturationUpdated(_ sender: UISlider) {
        
        characteristic.writeValue(Int(sender.value), completionHandler: { error in
            
            guard error == nil else {
                
                return
                
            }
            
            self.saturationValueLabel.text = (self.characteristic.value as AnyObject).description + "%"
            self.saturationSlider.setValue(self.characteristic.value as! Float, animated: true)
            
        })
        
    }
    
}

extension SaturationTableViewCell {
    
    func configure(with characteristic: HMCharacteristic!) {
        
        self.characteristic = characteristic
        
    }
    
}
