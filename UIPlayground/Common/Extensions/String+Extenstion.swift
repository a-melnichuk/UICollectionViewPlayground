//
//  String+Extenstion.swift
//  UIPlayground
//
//  Created by Alex Melnichuk on 10/28/17.
//  Copyright © 2017 Alex Melnichuk. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        get {
            return NSLocalizedString(self, comment: "")
        }
    }
    
    var isBlank: Bool {
        get {
            return isEmpty || trim().isEmpty
        }
    }
    
    func trim() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
