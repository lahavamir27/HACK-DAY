//
//  DrawViewController.swift
//  PulleyDemo
//
//  Created by Carmel Neta on 28/10/2019.
//  Copyright © 2019 52inc. All rights reserved.
//

import UIKit

protocol RootCategoryColectionProtocol: AnyObject {
    func didSelect(rootCategory: Any)
}

protocol SubCategoryColectionProtocol: AnyObject {
    func didSelect(subCategory: Any)
}

typealias drawDelegate = PhotosCollectionDelegateProtocol & RootCategoryColectionProtocol & SubCategoryColectionProtocol

class DrawViewController: UIViewController {

    weak var delegate: drawDelegate?
    var photosCollection: PhotosCollectionViewController?
    var rootCollection: RootCollectionViewController?
    var subCollection: SubCategoryCollectionViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let photosCollection = segue.destination as? PhotosCollectionViewController {
            if self.photosCollection == nil { self.photosCollection = photosCollection }
            photosCollection.delegate = delegate
            
        } else if let rootCollection = segue.destination as? RootCollectionViewController {
            if self.rootCollection == nil { self.rootCollection = rootCollection }
            rootCollection.delegate = self
        } else if let subCollection = segue.destination as? SubCategoryCollectionViewController {
            if self.subCollection == nil { self.subCollection = subCollection }
            subCollection.delegate = self
        }
    }
}


extension DrawViewController: RootCategoryColectionProtocol {
    func didSelect(rootCategory: Any) {
        self.delegate?.didSelect(rootCategory: rootCategory)
        
        self.subCollection?.collectionView.reloadData()
    }
}

extension DrawViewController: SubCategoryColectionProtocol {
    func didSelect(subCategory: Any) {
        self.delegate?.didSelect(subCategory: subCategory)
        
        self.photosCollection?.collectionView.reloadData()
    }
}


