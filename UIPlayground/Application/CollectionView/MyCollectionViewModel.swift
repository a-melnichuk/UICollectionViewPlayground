//
//  MyCollectionViewModel.swift
//  UIPlayground
//
//  Created by Alex Melnichuk on 11/4/17.
//  Copyright © 2017 Alex Melnichuk. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond

class MyCollectionViewModel: BaseViewModel<MyCollectionViewController> {
    var list = MutableObservableArray<CollectionItem>()
    
    override init(_ view: MyCollectionViewController) {
        super.init(view)
        for i in 0..<14 {
            let item = CollectionItem(index: i)
            list.append(item)
        }
    }
    
}
