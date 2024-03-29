//
//  DrawViewController.swift
//  PulleyDemo
//
//  Created by Carmel Neta on 28/10/2019.
//  Copyright © 2019 52inc. All rights reserved.
//

import UIKit
import Pulley

protocol RootCategoryColectionProtocol: AnyObject {
    func didSelect(rootCategory: Category)
}

protocol SubCategoryColectionProtocol: AnyObject {
    func didSelect(subCategory: [Int])
}

protocol DrawPhotoSelectionProtocol: AnyObject {
    func didSelect(images: [ImageRep])
}

class DrawViewController: UIViewController {

    weak var delegate: DrawPhotoSelectionProtocol?
    var photosCollection: PhotosCollectionViewController?
    var rootCollection: RootCollectionViewController?
    var subCollection: SubCategoryCollectionViewController?
    
    //  Constraints
    @IBOutlet weak var rootCategoryHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var subCollectionHeightConstraint: NSLayoutConstraint!
    
    var product: Prodcut?
    let dataManager = DataManger.shared()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dataManager.updateRoot(.people)
        if let product = self.product, product == .pets {
            dataManager.updateRoot(.pets)
            dataManager.updateSelectdSubs([0])
            dataManager.state.selectedSubs = []
        }
    }

    func drawerDidChange(position: PulleyPosition) {
        switch position {
        case .open:
            self.rootCategoryHeightConstraint.constant = 124
            self.subCollectionHeightConstraint.constant = 115
        default:
            
            self.rootCategoryHeightConstraint.constant = 0
            self.subCollectionHeightConstraint.constant = 0
        }
        
        self.view.layoutIfNeeded()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let photosCollection = segue.destination as? PhotosCollectionViewController {
            if self.photosCollection == nil { self.photosCollection = photosCollection }
            photosCollection.delegate = self
            photosCollection.dataManager = dataManager
        } else if let rootCollection = segue.destination as? RootCollectionViewController {
            if self.rootCollection == nil { self.rootCollection = rootCollection }
            rootCollection.delegate = self
            rootCollection.dataManager = dataManager
        } else if let subCollection = segue.destination as? SubCategoryCollectionViewController {
            if self.subCollection == nil { self.subCollection = subCollection }
            subCollection.delegate = self
            subCollection.dataManager = dataManager
        }
    }
}

extension DrawViewController: PhotosCollectionDelegateProtocol {
    func imagesDidChange(_ indexes: [Int], images: [ImageRep]) {
        self.dataManager.selectPhotos(indexes)
        self.delegate?.didSelect(images: images)
    }
}

extension DrawViewController: RootCategoryColectionProtocol {
    func didSelect(rootCategory: Category) {
        self.dataManager.updateRoot(rootCategory)
        self.subCollection?.update()
        self.photosCollection?.collectionView.reloadData()
    }
}

extension DrawViewController: SubCategoryColectionProtocol {
    func didSelect(subCategory: [Int]) {
        self.dataManager.updateSelectdSubs(subCategory)
        self.photosCollection?.collectionView.reloadData()
    }
}


