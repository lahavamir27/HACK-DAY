//
//  ProductViewController.swift
//  PulleyDemo
//
//  Created by Carmel Neta on 28/10/2019.
//  Copyright © 2019 52inc. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {

    @IBOutlet weak var canvasContainer: UIView!
    var canvasView: CanvasView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let localView: PetCanvas = UIView.fromNib()
        self.view.addSubview(localView)
        self.canvasView = localView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let canvasView = self.canvasView {
            canvasView.frame = self.view.frame
        }
    }
    
    
    func setImage(_ images: [UIImage]) {
//        canvasImage.image = image
        canvasView?.setImages(images)
    }
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
