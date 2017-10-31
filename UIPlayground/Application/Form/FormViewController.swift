//
//  FormViewController.swift
//  UIPlayground
//
//  Created by Alex Melnichuk on 10/26/17.
//  Copyright © 2017 Alex Melnichuk. All rights reserved.
//

import UIKit
import os.log
import ReactiveKit
import Bond

@IBDesignable
class FormViewController: UIViewController, UITextFieldDelegate, BaseView {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    var viewModel: FormViewModel!
    var signal: SafeSignal<Bool>!
    // MARK: UITextFieldDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        
        signal = emailTextField.textViewDidEndEditing
        signal.observeNext { o in
            os_log("Test")
        }
        viewModel = FormViewModel(self)
        viewModel.email.bidirectionalBind(to: emailTextField.reactive.text)
        viewModel.email.observeNext { self.emailLabel.text = $0 }.dispose(in: bag)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch (textField) {
        case emailTextField:
            nameTextField.becomeFirstResponder()
            break
        case nameTextField:
            nameTextField.resignFirstResponder()
            break
        default:
            break
        }
        return true
    }
}
