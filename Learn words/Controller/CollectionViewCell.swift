//
//  CollectionViewCell.swift
//  Learn words
//
//  Created by MacBook on 15.02.2020.
//  Copyright © 2020 MacPro. All rights reserved.
//
public enum answerImage {

    case goodAnswer
    case defaultAnswer
    case waitingAnswer
    
    var image: UIImage {
        switch self {
        case .goodAnswer : return  #imageLiteral(resourceName: "good-answer-png")
        case .defaultAnswer : return  #imageLiteral(resourceName: "default-answer-png")
        case .waitingAnswer : return  #imageLiteral(resourceName: "waiting-answer-png")
        }
    }
}

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    func animateCell() {
           let flash = CABasicAnimation(keyPath: "opacity")
           flash.duration = 0.8
           flash.fromValue = 1
           flash.toValue = 0.3
           flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
           flash.autoreverses = true
           flash.repeatCount = 3
           
           layer.add(flash, forKey: nil)
       }
}
