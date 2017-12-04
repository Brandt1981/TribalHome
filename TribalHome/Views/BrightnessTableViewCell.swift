//
//  BrightnessTableViewCell.swift
//  TribalHome
//
//  Created by Brandt Daniels on 11/15/17.
//  Copyright © 2017 TribalScale. All rights reserved.
//

import HomeKit
import UIKit

let brightnessTableViewCellNibName = "BrightnessTableViewCell"

class BrightnessTableViewCell: UITableViewCell {

    private var characteristic: HMCharacteristic! {
        
        didSet {
            
            activityIndicator.startAnimating()
            brightnessValueLabel.text = nil
            
            characteristic.readValue(completionHandler: { error in
                
                self.activityIndicator.stopAnimating()

                guard error == nil else {
                    
                    return
                }
                
                self.brightnessValueLabel.text = (self.characteristic.value as AnyObject).description + "%"
                self.brightnessSlider.setValue(self.characteristic.value as! Float, animated: false)

            })
            
        }
        
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var brightnessValueLabel: UILabel!

    @IBOutlet weak var brightnessSlider: UISlider!
    
    @IBAction func brightnessValueChanged(_ sender: UISlider) {
        
        activityIndicator.stopAnimating()
        brightnessValueLabel.text = String(describing: Int(sender.value)) + "%"
        
    }
    
    @IBAction func brightnessUpdated(_ sender: UISlider) {
        
        activityIndicator.startAnimating()
        brightnessValueLabel.text = nil
        
        characteristic.writeValue(Int(sender.value), completionHandler: { error in
            
            self.activityIndicator.stopAnimating()
            
            guard error == nil else {
                
                return
                
            }
            
            self.brightnessValueLabel.text = (self.characteristic.value as AnyObject).description + "%"
            self.brightnessSlider.setValue(self.characteristic.value as! Float, animated: true)
            
        })
        
    }
    
}

extension BrightnessTableViewCell {
    
    func configure(with characteristic: HMCharacteristic!) {
        
        self.characteristic = characteristic
                
    }
    
}
