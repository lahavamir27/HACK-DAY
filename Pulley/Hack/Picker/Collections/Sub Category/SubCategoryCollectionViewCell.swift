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
            return UIColor(displayP3Red: 0, green: 118/255, blue: 234/255, alpha: 1).cgColor
        case .unselected:
            return UIColor.lightGray.cgColor
        }
    }
}

class SubCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var selectedOverlay: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 29
        selectedOverlay.layer.cornerRadius = 35
        selectedOverlay.backgroundColor = .clear
        selectedOverlay.isHidden = false
    }

    
    override var isSelected: Bool {
        didSet {
            selectedOverlay.layer.borderColor = SelectionColor.bySelection(isSelected).cgColor
            selectedOverlay.layer.borderWidth = isSelected ? 3.5 : 1.0
            let scale = CGFloat(isSelected ? 1.00 : 1.0)
            
            UIView.animate(withDuration: 0.2) {
                self.imageView.transform = .init(scaleX: scale, y: scale)
                self.selectedOverlay.transform = .init(scaleX: scale, y: scale)
            }
        }
    }
}
