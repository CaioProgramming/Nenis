//
//  TextFieldExtension.swift
//  Nenis
//
//  Created by Caio Ferreira on 21/09/23.
//

import Foundation
import UIKit

extension UITextField {
    
    func validText() -> String? {
        if(self.text?.isEmpty ?? true ) {
            return nil
        } else {
            return self.text
        }
    }
}
