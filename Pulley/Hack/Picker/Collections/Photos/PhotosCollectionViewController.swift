//
//  PhotosCollectionViewController.swift
//  PulleyDemo
//
//  Created by Carmel Neta on 28/10/2019.
//  Copyright © 2019 52inc. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PhotoCell"

protocol PhotosCollectionDelegateProtocol: AnyObject {
    func imagesDidChange(_ indexes: [Int], images: [ImageRep])
}

class PhotosCollectionViewController: UICollectionViewController {

    weak var delegate: PhotosCollectionDelegateProtocol?
    weak var dataManager: DataManger?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.allowsMultipleSelection = true
    }
 
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataManager?.photos.count ?? 0
    }
    
    private func photo(for indexPath: IndexPath) -> ImageRep? {
        return dataManager?.photos[indexPath.item]
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let imageRep = self.photo(for: indexPath) else {
            cell.imageView.image = nil
            cell.isSelected = false
            return cell
        }
        
        cell.isSelected = dataManager?.state.selectedPhotos.contains(indexPath.item) ?? false
        cell.imageView.image = imageRep.image
        return cell
    }

    // MARK: UICollectionViewDelegate

    private var selectIndex: [Int] {
        guard let selected = self.collectionView.indexPathsForSelectedItems else { return [] }
        return selected.compactMap({ $0.item })
    }
    
    private var selectedImages: [ImageRep] {
        guard let selected = self.collectionView.indexPathsForSelectedItems else { return [] }
        return selected.compactMap({ self.photo(for: $0) })
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.imagesDidChange(selectIndex, images: selectedImages)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.delegate?.imagesDidChange(selectIndex, images: selectedImages)
        
    }
    /*
     Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width / 3.0
        return CGSize(width: size, height: size)
    }

}
