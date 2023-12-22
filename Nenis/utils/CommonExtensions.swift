//
//  CommonExtensions.swift
//  Nenis
//
//  Created by Caio Ferreira on 30/11/23.
//

import Foundation

func delay(with seconds: Double = 1.0, closure: @escaping (() -> Void)) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { // Change `2.0` to the desired number of seconds.
       closure()
    }
}

extension String {
    func addTimeInterval() -> String {
        let longDate = Date.now.timeIntervalSince1970
        return self + String(describing: longDate)
    }
    
    func removingBlankSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}
