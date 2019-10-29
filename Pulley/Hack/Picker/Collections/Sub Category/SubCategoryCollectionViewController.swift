//
//  RootCollectionViewController.swift
//  PulleyDemo
//
//  Created by Carmel Neta on 28/10/2019.
//  Copyright © 2019 52inc. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SubCategoryCollectionViewController: UICollectionViewController {

    weak var delegate: SubCategoryColectionProtocol?
    weak var dataManager: DataManger?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        
        self.collectionView.register(UINib(nibName: "SubCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        if let dataManager = self.dataManager {
            self.collectionView.allowsMultipleSelection = dataManager.state.selectedRoot == .people
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    //  MARK: Public API
    func update() {
        guard let dataManager = self.dataManager else { return }
        
        self.collectionView.allowsMultipleSelection = dataManager.state.selectedRoot == .people
        
        self.collectionView.reloadData()
        
        dataManager.state.selectedSubs.forEach { (index) in
            let indexPath = IndexPath(item: index, section: 0)
            self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        }
    }

    //  MARK: Private API
    func notify() {
        let items: [Int] = collectionView.indexPathsForSelectedItems?.map({$0.item}) ?? []
        self.delegate?.didSelect(subCategory: items)
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataManager?.subData.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SubCategoryCollectionViewCell,
             let dataManager = self.dataManager
        else {
            return UICollectionViewCell()
        }
        
        let item = dataManager.subData[indexPath.item]
        let selected = dataManager.state.selectedSubs
        
        cell.imageView.image = item.image
        cell.label.text = item.label
        cell.isSelected = selected.contains(indexPath.item)
        cell.label.isHidden = dataManager.state.selectedRoot == .people
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        notify()
    }

    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard self.collectionView.allowsMultipleSelection else {
            return
        }
        notify()
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
         if collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false {
               collectionView.deselectItem(at: indexPath, animated: true)
               return false
           }
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

extension SubCategoryCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 85, height: 105)
    }
}
