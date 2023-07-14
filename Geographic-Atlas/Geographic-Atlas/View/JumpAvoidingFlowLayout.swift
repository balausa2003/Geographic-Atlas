//
//  JumpAvoidingFlowLayout.swift
//  Geographic-Atlas
//
//  Created by Балауса Косжанова on 16.05.2023.
//

import UIKit

class JumpAvoidingFlowLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
           guard let collectionView = collectionView else {
               return proposedContentOffset
           }


           let targetX: CGFloat = {
               let totalWidth = collectionViewContentSize.width + collectionView.contentInset.right + collectionView.contentInset.left
               
               if totalWidth > collectionView.bounds.size.width {
                   return proposedContentOffset.x
               }

               return 0
           }()

           let targetY: CGFloat = {
               let totalHeight = collectionViewContentSize.height + collectionView.contentInset.bottom + collectionView.contentInset.top
               
               if totalHeight > collectionView.bounds.size.height {
                   return proposedContentOffset.y
               }
               
               return 0
           }()

           return CGPoint(x: targetX, y: targetY)
       }

   }
