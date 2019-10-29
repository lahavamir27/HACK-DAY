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
    var selectedPhotos:[Int] = [1]
}

class DataManger {

    private static var sharedDataManger: DataManger = {
        let sharedDataManger = DataManger()
        
        // Configuration
        // ...
        
        return sharedDataManger
    }()
    
    class func shared() -> DataManger {
        return sharedDataManger
    }
    
    var state = ManagerState()
    let folderName = "Carmel"

    private var cachePeople:[ImageRep] = []
    private var cachePet:[ImageRep] = []
    private var cacheCountry:[ImageRep] = []
    private var cacheObject:[ImageRep] = []

    var subData:    [ImageRep] = []
    var photos:     [ImageRep]  = []
    var allImages:  [FinalImage] = []
    var realImages: [String:UIImage] = [:]
    
    
    func startUp() {
        let url = Bundle.main.url(forResource: "document", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        
        
        let decodedPhotos = try! JSONDecoder().decode(FinalImages.self, from: data)
        allImages = decodedPhotos.images
        updateRoot(.objects)
        updateRoot(.pets)
        updateRoot(.people)
        
    }
    
    func updateRoot(_ category:Category) {
        state.selectedRoot = category
        subData = getSubs(category)
        updateSelectdSubs([])
    }
    
    func updateSelectdSubs(_ subs:[Int]) {
        let label:[String] = subs.map { (key) in
            return subData[key].label
        }
        state.selectedSubs = subs
        state.selectedPhotos = []
        let labelSet = Set(label)
        switch state.selectedRoot {
        case .people:
            if label.count == 1{
                let images = allImages.filter { (image) -> Bool in
                    var isInclude:Bool = false
                    for face in image.people {
                        if face.label == label.first! {
                            isInclude = true
                        }
                    }
                    return isInclude
                }
                photos = getRepImage(images: images)

            }else {
                let images = allImages.filter { (image) -> Bool in
                    var facesSet = Set<String>()
                    image.people.forEach { (face) in
                        facesSet.insert(face.label)
                    }
                    if labelSet.isSubset(of: facesSet) {
                        return true
                    }else {
                        return false
                    }
                }
                
                photos = getRepImage(images: images)

            }
        case .pets:
            let images = allImages.filter { (image) -> Bool in
                guard !label.isEmpty else { return false }
                return image.petType.contains(label.first!)
            }
            photos = getRepImage(images: images)

        case .loction:
            let images = allImages.filter { (image) -> Bool in
                guard !label.isEmpty else { return false }
                return image.location == label.first!
            }
            photos = getRepImage(images: images)
        case .objects:
            let images = allImages.filter { (image) -> Bool in
                guard !label.isEmpty else { return false }
                
                let newLabel = label.first!.replacingOccurrences(of: " ", with: "_").lowercased()
                return image.categories.contains(newLabel)
             }
             photos = getRepImage(images: images)
        }
    }
    
    
    func getRepImage(images:[FinalImage]) -> [ImageRep] {
        return images.compactMap { (image) -> ImageRep? in
            if realImages[image.imageName] != nil {
                return ImageRep(label: "", image: realImages[image.imageName]!)
            }
            if let imageView = getSmall(for: image.imageName) {
               realImages[image.imageName] = imageView
               return ImageRep(label: "", image: imageView)
            }else {
                return nil
            }
        }
    }
    
    func selectPhotos(_ photo:[Int]) {
        state.selectedPhotos = photo
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
    
    private func getSmall(for key:String) -> UIImage? {
        
        if let imageURL = imageURL(imageName: key) {
              return downsample(imageAt: imageURL, to: CGSize(width: 90, height: 90))
        }else{
            return nil
        }        
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
        if !cachePet.isEmpty {
            return cachePet
        }
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
        
        if !cacheCountry.isEmpty {
            return cacheCountry
        }
        
        var setOfLoctionString = Set<String>()
        var setOfLoction = Set<ImageRep>()
        allImages.forEach { (image) in
            guard !setOfLoctionString.contains(image.location), !image.location.isEmpty else{
                return
            }
            if let imageForRep = getSmall(for: image.imageName) {
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
        
        if !cacheObject.isEmpty {
            return cacheObject
        }
        var setOfObject = Set<ImageRep>()
        var setOfCategories = Set<String>()
        var count:[String:Int] = [:]
        allImages.forEach { (image) in
            image.categories.forEach { (category) in
                if count[category] == nil {
                    count[category] = 1
                }else {
                    count[category]! += 1
                }
                guard !setOfCategories.contains(category) else {
                    return
                }
                if let imageForRep = getSmall(for: image.imageName) {
                    setOfCategories.insert(category)
                    let cat = category.firstCapitalized
                    let r = cat.replacingOccurrences(of: "_", with: " ")
                    let rep = ImageRep(label: r, image: imageForRep)
                    setOfObject.insert(rep)
                }
            }
        }
        print(count)

        var objects = Array(setOfObject).sorted { (a, b) -> Bool in
            if let countA = count[a.label.replacingOccurrences(of: " ", with: "_").lowercased()], let countB = count[b.label.replacingOccurrences(of: " ", with: "_").lowercased()] {
                return countA > countB
            }
            return a.label < b.label
        }
        
        objects.removeAll { (image) -> Bool in
            if let countT = count[image.label.replacingOccurrences(of: " ", with: "_").lowercased()] {
                if countT < 2 {
                    return true
                }
                if image.label == "People" || image.label == "Adult" {
                    return true
                }
            }
            return false
        }
        cacheObject = objects
        return objects
        
    }
    
    func sortMe(a:ImageRep, b:ImageRep) -> Bool {
        a.label < b.label
    }
    
    
    func peopleImages() -> [ImageRep]
    {
        
        if !cachePeople.isEmpty {
            return cachePeople
        }
        var count:[String:Int] = [:]

        var setOfPeople = Set<FinalFace>()
        allImages.forEach { (image) in
            image.people.forEach { (face) in
                if count[face.label] == nil {
                    count[face.label] = 1
                }else {
                    count[face.label]! += 1
                }
                let faceT = FinalFace(label: face.label, corpRect: face.cropRect, imageName: image.imageName)
                if face.cropRect.origin.x < 0 || face.cropRect.origin.y < 0 || face.cropRect.size.width > 70{
                }else{
                    setOfPeople.insert(faceT)
                }
            }
        }
        
        
        
        let r = Array(setOfPeople).compactMap( { (image) -> ImageRep? in
            let images =  getImage(for: image.imageName ?? "")
            let scale = UIScreen.main.scale
            let rect = CGRect(x: image.cropRect.origin.x * scale, y: image.cropRect.origin.y * scale , width: image.cropRect.size.width * scale, height: image.cropRect.size.height * scale)
            
            if image.label == "1" {
                return  ImageRep(label: image.label, image: getImage(for: "lyly")!)
            }
            if image.label == "19" {
                return  ImageRep(label: image.label, image: getImage(for: "anton")!)
            }
            if image.label == "2" {
                return  ImageRep(label: image.label, image: getImage(for: "carmel")!)
            }
            
            if let cgImage = images?.cgImage?.cropping(to: rect) {
                return ImageRep(label: image.label, image: UIImage(cgImage: cgImage))
            }else {
                return nil
            }
        })
        
        let p = r.sorted { (a, b) -> Bool in
            if let countA = count[a.label], let countB = count[b.label] {
                return countA > countB
            }
            return a.label < b.label
        }
        
        cachePeople = p
        return cachePeople
    }
    
    func downsample(imageAt imageURL: URL, to pointSize: CGSize) -> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else { return nil }
        
        let maxDimensionInPixels = Swift.max(pointSize.width, pointSize.height) *  UIScreen.main.scale
        let downsampleOptions =  [kCGImageSourceCreateThumbnailFromImageAlways: true,
                                  kCGImageSourceShouldCacheImmediately: true,
                                  kCGImageSourceCreateThumbnailWithTransform: true,
                                  kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
        let downsampledImage =   CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)!
        let image = UIImage(cgImage: downsampledImage)
        return image
        
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


extension StringProtocol {
    var firstUppercased: String {
        return prefix(1).uppercased()  + dropFirst()
    }
    var firstCapitalized: String {
        return prefix(1).capitalized + dropFirst()
    }
}
