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

    }
    
    override var isSelected: Bool {
        didSet {
            selectedOverlay.isHidden = !isSelected
        }
    }
}
