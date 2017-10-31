//
//  ReactiveExtensions.swift
//  UIPlayground
//
//  Created by Alex Melnichuk on 10/28/17.
//  Copyright © 2017 Alex Melnichuk. All rights reserved.
//

import Foundation
import UIKit
import ReactiveKit
import Bond

extension ReactiveExtensions where Base: UITextField {
    public var delegate: ProtocolProxy {
        return base.protocolProxy(for: UITextFieldDelegate.self,
                                  setter: NSSelectorFromString("setDelegate:")
            //NSSelectorFromString("setDelegate:")
        )
    }
}

extension UITextField {
    var textViewDidEndEditing: Signal<Bool, NoError> {
        //reactive.delegate.signa
        return reactive.delegate.signal(
            for: #selector(UITextViewDelegate.textViewDidEndEditing(_:)), dispatch: { (subject: SafePublishSubject<Bool>, _: UITextField, result: Bool) in
                subject.next(true)
        })
    }
    
    var abc: String {
        return "ABC"
    }
    
}

