//
//  HueTableViewCell.swift
//  TribalHome
//
//  Created by Brandt Daniels on 11/16/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

let hueTableViewCellNibName = "HueTableViewCell"

class HueTableViewCell: UITableViewCell {

    private var characteristic: HMCharacteristic! {
        
        didSet {
            
            hueValueLabel.text = nil
            
            characteristic.readValue(completionHandler: { error in
                
                guard error == nil else {
                    
                    return
                }
                
                self.hueValueLabel.text = (self.characteristic.value as AnyObject).description + "°"
                self.hueSlider.setValue(self.characteristic.value as! Float, animated: false)
                
            })
            
        }
        
    }
    
    @IBOutlet weak var hueValueLabel: UILabel!
    
    @IBOutlet weak var hueSlider: UISlider!
    
    @IBAction func hueValueChanged(_ sender: UISlider) {
        
        self.hueValueLabel.text = String(describing: Int(sender.value)) + "°"
        
    }
    
    @IBAction func hueUpdated(_ sender: UISlider) {
        
        characteristic.writeValue(Int(sender.value), completionHandler: { error in
            
            guard error == nil else {
                
                return
                
            }
            
            self.hueValueLabel.text = (self.characteristic.value as AnyObject).description + "°"
            self.hueSlider.setValue(self.characteristic.value as! Float, animated: true)
            
        })
        
    }
    
}

extension HueTableViewCell {
    
    func configure(with characteristic: HMCharacteristic!) {
        
        self.characteristic = characteristic
        
    }
    
}
