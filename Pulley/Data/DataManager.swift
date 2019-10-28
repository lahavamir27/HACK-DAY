//
//  DataManager.swift
//  PulleyDemo
//
//  Created by Carmel Neta on 28/10/2019.
//  Copyright © 2019 52inc. All rights reserved.
//

import UIKit

enum Category: CaseIterable {
    case people
    case pets
    case loction
    case objects
    
    var thumbName: String {
        switch self {
        case .people: return "people"
        case .pets: return "pets"
        case .loction: return "loction"
        case .objects: return "objects"
        }
    }
    
    var label: String {
        switch self {
           case .people: return "People"
           case .pets: return "Pets"
           case .loction: return "Loction"
           case .objects: return "Objects"
           }
    }
}

struct ImageRep {
    let label:String
    let image:UIImage
}

struct MockImages {
    static let img1 = ImageRep(label: "mock1", image: UIImage(named: "mockPhoto1.jpg")!)
    static let img2 = ImageRep(label: "mock2", image: UIImage(named: "mockPhoto2.jpg")!)
}

class ManagerState {
    var selectedRoot:Category = .people {
        didSet {
            selectedSubs = [0]
            selectedPhotos.removeAll()
        }
    }
    var selectedSubs:[Int] = [0]
    var selectedPhotos:Set<Int> = [1]
}

class DataManger {
    var state = ManagerState()
    var subData: [ImageRep] = [
        MockImages.img1,
        MockImages.img2,
        MockImages.img1,
        MockImages.img2,
        MockImages.img1
    ]
    
    var photos: [ImageRep] = [
        MockImages.img1,
        MockImages.img2,
        MockImages.img1,
        MockImages.img1,
        MockImages.img2,
        MockImages.img1,
        MockImages.img1,
        MockImages.img2,
        MockImages.img2
    ]
    
    func updateRoot(_ category:Category) {
    }
    
    func updateSelectdSubs(_ subs:[Int]) {
    }
    
    func updateSelectPhotos(_ photo:[Int]) {
    }
}

