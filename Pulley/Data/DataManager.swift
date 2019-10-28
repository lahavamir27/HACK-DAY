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
    let folderName = "TestImages"
    private var cachePeople:[ImageRep] = []
    private var cachePet:[ImageRep] = []
    private var cacheCountry:[ImageRep] = []
    private var cacheObject:[ImageRep] = []
    var subData:    [ImageRep] = []
    var photos:     [ImageRep]  = []
    var allImages:  [FinalImage] = []
    
    
    init() {
        let url = Bundle.main.url(forResource: "document", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        
        
        let decodedPhotos = try! JSONDecoder().decode(FinalImages.self, from: data)
        allImages = decodedPhotos.images
        print(decodedPhotos)
        
    }
    
    func updateRoot(_ category:Category) {
        state.selectedRoot = category
        subData = getSubs(category)
 
    }
    
    func updateSelectdSubs(_ subs:[Int]) {
        
    
    }
    
    func selectPhotos(_ photo:[Int]) {
        
        
        
    }
    
    
    private func imageURL(imageName: String) -> URL? {
        let imagePath = Bundle.main.resourcePath! + "/\(folderName)"
        return URL(fileURLWithPath:  imagePath + "/" + imageName)
    }
    
    private func getImage(for key:String) -> UIImage? {
        if let imageURL = imageURL(imageName: key) {
            return UIImage(contentsOfFile: imageURL.path)
        }
        return nil
    }
    
    private func getSubs(_ category:Category) -> [ImageRep] {
        switch  category{
        case .people:
            return peopleImages()
        case .pets:
            return petsImages()
        case .loction:
            return locationsImages()
        case .objects:
            return objectImages()
        }
    }
    
    
    func petsImages() -> [ImageRep] {
        
        var images:[ImageRep] = []
        // dont repeat yourself
        for value in allImages {
            if value.petType.contains("cat") {
                if let image = getImage(for: value.imageName) {
                    let imageRep = ImageRep(label: "cat", image: image)
                    images.append(imageRep)
                    break
                }
            }
        }
        
        // dont repeat yourself
        for value in allImages {
            if value.petType.contains("dog") {
                if let image = getImage(for: value.imageName) {
                    let imageRep = ImageRep(label: "dog", image: image)
                    images.append(imageRep)
                    break
                }
            }
        }
        cachePet = images
        return images
    }
    
    func locationsImages() -> [ImageRep] {
        
        var setOfLoctionString = Set<String>()
        var setOfLoction = Set<ImageRep>()
        allImages.forEach { (image) in
            guard !setOfLoctionString.contains(image.location), !image.location.isEmpty else{
                return
            }
            if let imageForRep = getImage(for: image.imageName) {
                setOfLoctionString.insert(image.location)
                let rep = ImageRep(label: image.location, image: imageForRep)
                setOfLoction.insert(rep)
            }
        }
        
        let locations = Array(setOfLoction).sorted(by: sortMe)
        cacheCountry = locations
        return locations
        
    }
    
    func objectImages() -> [ImageRep] {
        
        var setOfObject = Set<ImageRep>()
        var setOfCategories = Set<String>()
        allImages.forEach { (image) in
            image.categories.forEach { (category) in
                
                guard !setOfCategories.contains(category) else {
                    return
                }
                if let imageForRep = getImage(for: image.imageName) {
                    setOfCategories.insert(category)
                    let rep = ImageRep(label: category, image: imageForRep)
                    setOfObject.insert(rep)
                }
            }
        }
    
        let objects = Array(setOfObject).sorted(by: sortMe)
        cacheObject = objects
        return objects
        
    }
    
    func sortMe(a:ImageRep, b:ImageRep) -> Bool {
        a.label < b.label
    }
    
    func peopleImages() -> [ImageRep]
    {
        var setOfPeople = Set<FinalFace>()
        allImages.forEach { (image) in
            image.people.forEach { (face) in
                let faceT = FinalFace(label: face.label, corpRect: face.cropRect, imageName: image.imageName)
                setOfPeople.insert(faceT)
            }
        }
        
        let peoples = Array(setOfPeople).sorted { (imageA, imageB) -> Bool in
            return imageA.label < imageB.label
        }.compactMap { (image) -> ImageRep? in
            let images =  getImage(for: image.imageName ?? "")
            let rect = CGRect(x: image.cropRect.origin.x * 2, y: image.cropRect.origin.y * 2, width: image.cropRect.size.width * 2, height: image.cropRect.size.height * 2)
            if let cgImage = images?.cgImage?.cropping(to: rect) {
                return ImageRep(label: "", image: UIImage(cgImage: cgImage))
            }else {
                return nil
            }
        }
        
        cachePeople = peoples
        return peoples
    }
        
}
struct FinalImages:Codable {
    let images:[FinalImage]
}
struct FinalImage:Codable {
    let imageName:String
    let petType:[String]
    let categories:[String]
    let people:[FinalFace]
    let location:String
}
struct ImageRep: Hashable {
    let label:String
    let image:UIImage
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(label)
    }
}
struct FinalFace:Codable, Equatable, Hashable{
    let label:String
    let cropRect:CGRect
    let imageName:String?
    
    init(label:String, corpRect:CGRect, imageName:String?) {
        self.label = label
        self.cropRect = corpRect
        self.imageName = imageName
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(label)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.label == rhs.label
    }
}
