//
//  MyCollectionViewCell.swift
//  UIPlayground
//
//  Created by Alex Melnichuk on 11/4/17.
//  Copyright © 2017 Alex Melnichuk. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var numberLabel: UILabel!
    
    var item: CollectionItem! {
        didSet {
            numberLabel.text = String(item.index)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
