////
////  HandlingAnswers.swift
////  Learn words
////
////  Created by MacBook on 18.02.2020.
////  Copyright © 2020 MacPro. All rights reserved.
////
//
//import Foundation
//
//class HandlingAnswers {
//    private func trueAnswer(_ cell: CollectionViewCell, _ indexPath: indexPath){
//        DispatchQueue.main.async {
//            if (cell)
//            if (CollectionViewCell.cellSelected == false) {
//                cell.ImageView.image = answerImage.goodAnswer.image
//                CollectionViewCell.cellSelected = true
//                self.collectionView.isUserInteractionEnabled = false
//            }
//        }
//    }
//    
//    private func playWaitningSund(){
//        self.playSound("waiting-answer")
//        self.player?.play()
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
//            self.player?.stop()
//        })
//         
//    }
//}
