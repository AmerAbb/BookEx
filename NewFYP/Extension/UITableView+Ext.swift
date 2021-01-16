//
//  UITableView+Ext.swift
//  NewFYP
//
//  Created by Amer Abboud on 1/11/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit

extension UITableView {
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
