//
//  CanvasView.swift
//  PulleyDemo
//
//  Created by Carmel Neta on 29/10/2019.
//  Copyright © 2019 52inc. All rights reserved.
//

import UIKit

class CanvasView: UIView {
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }

    func setImages(_ images: [UIImage]) {
        let views = self.getUserImages()
        views.enumerated().forEach { (index, view) in
            guard index < images.count else { return }
            view.image = images[index]
        }
    }
    
    func getUserImages() -> [UIImageView] {
        []
    }

}

class PetCanvas: CanvasView {
    @IBOutlet weak var userImage: UIImageView!
     
    override func getUserImages() -> [UIImageView] {
        [userImage]
    }
}

class LoveCanvas: CanvasView {
    @IBOutlet weak var userImage1: UIImageView!
    
    @IBOutlet weak var userImage2: UIImageView!
    
    override func getUserImages() -> [UIImageView] {
        [userImage1, userImage2]
    }
}

class FamilyCanvas: CanvasView {
    
    @IBOutlet var userImage1: UIImageView!
    @IBOutlet var userImage2: UIImageView!
    @IBOutlet var userImage3: UIImageView!
    
    override func getUserImages() -> [UIImageView] {
        [userImage1, userImage2, userImage3]
    }
}
