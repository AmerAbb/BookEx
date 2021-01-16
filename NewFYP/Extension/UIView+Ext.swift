//
//  UIView+Ext.swift
//  NewFYP
//
//  Created by Amer Abboud on 1/10/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
