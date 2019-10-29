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
        if let title = self.product?.title {
            self.title = title
        }
        setDrawerPosition(position: .partiallyRevealed, animated: false)
        self.delegate = self
    }

    var product: Prodcut?
    
    var canvasVC: ProductViewController?
    var drawerVC: DrawViewController?
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let draw = segue.destination as? DrawViewController {
            draw.delegate = self
            draw.product = product
            self.drawerVC = draw
        }
        
        if let canvas = segue.destination as? ProductViewController {
            if self.canvasVC == nil { self.canvasVC = canvas }
            
            canvasVC?.product = self.product
        }
    }
    
    override func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        self.drawerVC?.drawerDidChange(position: self.drawerPosition)
    }
}

extension MainViewController: DrawPhotoSelectionProtocol {
    func didSelect(images: [ImageRep]) {
        self.canvasVC?.setImage(images.map({ $0.image }))
    }
}
