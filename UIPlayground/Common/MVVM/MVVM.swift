//
//  MVVM.swift
//  UIPlayground
//
//  Created by Alex Melnichuk on 10/28/17.
//  Copyright © 2017 Alex Melnichuk. All rights reserved.
//

import Foundation
import UIKit

protocol BaseView : class {
}

class BaseViewModel<T: BaseView> {
    
    weak var view: T?
    
    init(_ view: T) {
        self.view = view
    }
    
    func onUI(callback: (T) -> Void) {
        guard let view = self.view else {
            return
        }
        callback(view)
    }
    
}
