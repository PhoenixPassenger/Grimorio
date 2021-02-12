//
//  UIView+Loading.swift
//  Grimorio
//
//  Created by Rodrigo Silva Ribeiro on 12/02/21.
//  Copyright © 2021 Rodrigo Silva Ribeiro. All rights reserved.
//

import Foundation
import UIKit

extension UIView: LoadingProtocol {
    
    private var indicator: UIActivityIndicatorView {
        if let indicator = subviews.compactMap({ $0 as? UIActivityIndicatorView }).first {
            return indicator
        } else {
            let indicator = UIActivityIndicatorView(style: .large)
            addSubview(indicator)
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            indicator.color = tintColor
            indicator.hidesWhenStopped = true
            return indicator
        }
    }
    
    @objc func setLoading(_ loading: Bool) {
        switch loading {
        case true:
            indicator.startAnimating()
        case false:
            indicator.stopAnimating()
        }
    }
    
}
