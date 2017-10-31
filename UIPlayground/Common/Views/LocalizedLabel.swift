//
//  LocalizedLabel.swift
//  UIPlayground
//
//  Created by Alex Melnichuk on 10/28/17.
//  Copyright © 2017 Alex Melnichuk. All rights reserved.
//

import UIKit

@IBDesignable
class LocalizedLabel: UILabel {
    
    @IBInspectable var localizedKey: String = "" {
        didSet {
            text = localizedKey.isBlank ? "ERROR: no localized key is set" : localizedKey.localized
        }
    }
    
}
