//
//  MainViewController.swift
//  PulleyDemo
//
//  Created by Carmel Neta on 28/10/2019.
//  Copyright © 2019 52inc. All rights reserved.
//

import UIKit
import Pulley

class MainViewController: PulleyViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Product"
    }

    var product: Prodcut?
    
    var canvasVC: ProductViewController?
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let draw = segue.destination as? DrawViewController {
            draw.delegate = self
        }
        
        if let canvas = segue.destination as? ProductViewController {
            if self.canvasVC == nil { self.canvasVC = canvas }
        }
    }
}

extension MainViewController: DrawPhotoSelectionProtocol {
    func didSelect(images: [ImageRep]) {
        guard let image = images.first else { return }
        self.canvasVC?.setImage(image.image)
    }
}
