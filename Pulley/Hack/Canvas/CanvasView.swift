//
//  CanvasView.swift
//  PulleyDemo
//
//  Created by Carmel Neta on 29/10/2019.
//  Copyright © 2019 52inc. All rights reserved.
//

import UIKit

class CanvasView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
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
    
    @IBOutlet var height: NSLayoutConstraint!
    @IBOutlet var canvasImage: UIImageView!
    
    override func setImages(_ images: [UIImage]) {
        super.setImages(images)
        //height.constant = canvasImage.frame.size.height
        self.userImage.frame = canvasImage.frame
    }
    
    override func getUserImages() -> [UIImageView] {
        [userImage]
    }
}
