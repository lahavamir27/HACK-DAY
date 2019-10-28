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
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let draw = segue.destination as? DrawViewController {
            draw.delegate = self
        }
    }
}

extension MainViewController: PhotosCollectionDelegateProtocol {
    func didSelectImage(_ image: UIImage) {
        print("Selected an image")
    }
    
    func didRemoveImage(_ image: UIImage) {
        print("Remove an image")
    }
}

extension MainViewController: RootCategoryColectionProtocol {
    func didSelect(rootCategory: Any) {
        print("Root category")
    }
}

extension MainViewController: SubCategoryColectionProtocol {
    func didSelect(subCategory: Any) {
        print("Sub Category")
    }
}
