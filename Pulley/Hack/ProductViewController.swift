//
//  ProductViewController.swift
//  PulleyDemo
//
//  Created by Carmel Neta on 28/10/2019.
//  Copyright © 2019 52inc. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {

    @IBOutlet weak var canvasImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setImage(_ image: UIImage) {
        canvasImage.image = image
    }
}
