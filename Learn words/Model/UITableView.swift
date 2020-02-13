//
//  UITableView.swift
//  Learn words
//
//  Created by MacBook on 26.11.2019.
//  Copyright © 2019 MacPro. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func getAllCell() -> [UITableViewCell] {
        var cells = [UITableViewCell]()
        let sections = self.numberOfSections
        for i in 0..<sections {
            let rows = self.numberOfRows(inSection: i)
            for j in 0..<rows {
                let indexPath = IndexPath.init(row: j, section: i)
                if let cell = self.cellForRow(at: indexPath) {
                    cells += [cell]
                }
            }
        }
        return cells
    }
}
