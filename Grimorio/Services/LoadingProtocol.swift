//
//  LoadingProtocol.swift
//  Grimorio
//
//  Created by Rodrigo Silva Ribeiro on 12/02/21.
//  Copyright © 2021 Rodrigo Silva Ribeiro. All rights reserved.
//

import Foundation
import UIKit

fileprivate var key: UInt8 = 42

protocol LoadingProtocol: class {
    func setLoading(_ loading: Bool)
}

extension LoadingProtocol {
    
    private var _indicator: UIActivityIndicatorView? {
        get {
            objc_getAssociatedObject(self, &key) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func setLoading(_ loading: Bool, at target: ReferenceWritableKeyPath<Self, UIView?>) {
        if _indicator == nil {
            _indicator = UIActivityIndicatorView(style: .medium)
        }
        switch loading {
        case true:
            self[keyPath: target] = _indicator
            self._indicator?.startAnimating()
        case false:
            self[keyPath: target] = nil
            self._indicator?.stopAnimating()
        }
    }
    
}
