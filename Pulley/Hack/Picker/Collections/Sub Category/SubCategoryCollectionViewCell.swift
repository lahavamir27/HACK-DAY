//
//  CategoryCollectionViewCell.swift
//  PulleyDemo
//
//  Created by Carmel Neta on 28/10/2019.
//  Copyright © 2019 52inc. All rights reserved.
//

import UIKit

enum SelectionColor {
    case selected
    case unselected
    
    static func bySelection(_ isSelected: Bool) -> SelectionColor {
        isSelected ? .selected : .unselected
    }
    
    var cgColor: CGColor {
        switch self {
        case .selected:
            return UIColor(red: 23.0/255.0, green: 105.0/255.0, blue: 208.0/255.0, alpha: 1).cgColor
        case .unselected:
            return UIColor.gray.cgColor
        }
    }
}

class SubCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectedOverlay: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 30
        selectedOverlay.layer.cornerRadius = 33
        selectedOverlay.backgroundColor = .clear
        selectedOverlay.layer.borderWidth = 2.0
        selectedOverlay.isHidden = false
    }

    
    override var isSelected: Bool {
        didSet {
            selectedOverlay.layer.borderColor = SelectionColor.bySelection(isSelected).cgColor
        }
    }
}
