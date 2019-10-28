//
//  AssetGridCollectionViewLayout.swift
//  PulleyDemo
//
//  Created by Carmel Neta on 28/10/2019.
//  Copyright © 2019 52inc. All rights reserved.
//

import UIKit
 
class AssetGridCollectionViewLayout: UICollectionViewFlowLayout {
    
    
    var itemsPerRowPortrait:Int
    var itemsPerRowLandscape:Int
    
    
    
    init(itemsPerRowPortrait:Int = 4, itemsPerRowLandscape:Int = 7) {
        self.itemsPerRowPortrait = itemsPerRowPortrait
        self.itemsPerRowLandscape = itemsPerRowLandscape
        super.init()

        minimumLineSpacing = 1
        minimumInteritemSpacing = 1
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.itemsPerRowPortrait = 4
        self.itemsPerRowLandscape = 7
        super.init()

        minimumLineSpacing = 1
        minimumInteritemSpacing = 1
    }
    
    var isPortrait: Bool {
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .portrait:
            return true
            
        case .faceUp, .faceDown, .portraitUpsideDown:
            // Check the interface orientation
            let interfaceOrientation = UIApplication.shared.statusBarOrientation
            switch interfaceOrientation{
            case .portrait:
                return true
            default:
                return false
            }
        default:
            return false
        }
    }
    
    override var itemSize: CGSize
        {
        set {}
        get{
            let pedding:CGFloat = 1.0
            var row:CGFloat!
            var numOfColumns: CGFloat {
                
                
                if isPortrait { return CGFloat(itemsPerRowPortrait) } else {return CGFloat(itemsPerRowLandscape)}
                
                
            }
            let itemWidth = ((self.collectionView!.frame.width - (numOfColumns - 1) * pedding) / numOfColumns)
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }
}
