//
//  StoreViewController.swift
//  PulleyDemo
//
//  Created by Carmel Neta on 28/10/2019.
//  Copyright © 2019 52inc. All rights reserved.
//

import UIKit

private let reuseIdentifier = "RootCell"

class ProductCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

enum Prodcut: CaseIterable {
    case pets
    case family
    case love
    
    var imageName: String {
        switch self {
        case .pets: return "petProduct"
        case .love: return "loveProduct"
        case .family: return "familyProduct"
        }
    }
     
    var title: String {
        switch self {
             case .pets: return "Pets"
             case .love: return "Love"
             case .family: return "Family"
             }
    }
    
    func getView() -> CanvasView {
        switch self {
        case .pets:
        let localView: PetCanvas = UIView.fromNib()
        return localView
        case .love:
            let localView: LoveCanvas = UIView.fromNib()
            return localView
        case .family:
            let localView: FamilyCanvas = UIView.fromNib()
            return localView
        }
    }
}

class StoreViewController: UICollectionViewController {
    override func viewDidLoad() {
        self.title = "Products"
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showProduct",
            let main = segue.destination as? MainViewController,
            let product = sender as? Prodcut
            {
            main.product = product
        }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Prodcut.allCases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ProductCell else {
                  return UICollectionViewCell()
              }
        let product = Prodcut.allCases[indexPath.item]
        let image = UIImage(named: product.imageName)
        cell.imageView.image = image
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = Prodcut.allCases[indexPath.item]
        self.performSegue(withIdentifier: "showProduct", sender: product)
    }
}
extension StoreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size.width / 2
        return CGSize(width: size, height: 250)
    }
}
