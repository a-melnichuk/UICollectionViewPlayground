//
//  CollectionItem.swift
//  UIPlayground
//
//  Created by Alex Melnichuk on 11/4/17.
//  Copyright © 2017 Alex Melnichuk. All rights reserved.
//

import Foundation

class CollectionItem {
    
    var index: Int
    
    init(index: Int) {
        self.index = index
    }
    
    convenience init() {
        self.init(index: 0)
    }
    
}
