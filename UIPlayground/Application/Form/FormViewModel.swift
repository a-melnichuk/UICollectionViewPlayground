//
//  FormViewModel.swift
//  UIPlayground
//
//  Created by Alex Melnichuk on 10/26/17.
//  Copyright © 2017 Alex Melnichuk. All rights reserved.
//

import Foundation
import Bond
import os.log

class FormViewModel : BaseViewModel<FormViewController> {

    let email = Observable<String?>("")
    let name = Observable<String?>("")
    
    override init(_ view: FormViewController) {
        super.init(view)
        //email.observeNext { os_log("Email changed: %@", $0) }
    }
    
    func test() {
        
    }
    
}
