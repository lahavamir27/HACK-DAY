//
//  RootCategoryCollectionViewCell.swift
//  PulleyDemo
//
//  Created by Carmel Neta on 28/10/2019.
//  Copyright © 2019 52inc. All rights reserved.
//

import UIKit

class RootCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var selectedOverlay: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 10
        selectedOverlay.layer.cornerRadius = 10
        selectedOverlay.layer.borderColor = UIColor(displayP3Red: 0, green: 118/255, blue: 234/255, alpha: 1).cgColor

    }
    
    override var isSelected: Bool {
        didSet {
            selectedOverlay.isHidden = !isSelected
        }
    }
}
