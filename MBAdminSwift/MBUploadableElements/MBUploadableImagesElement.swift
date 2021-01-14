//
//  MBUploadableImagesElement.swift
//  MBurgerSwift
//
//  Created by Alessandro Viviani on 02/10/2019.
//  Copyright © 2019 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import Foundation
import UIKit
import MBNetworkingSwift

/// An uploadable element representing some images.
public struct MBUploadableImagesElement: MBUplodableElement {
    
    /// The locale of the element. This is needed to construct the parameter name.
    public var localeIdentifier: String
    
    /// The name/key of the element.
    public var elementName: String
    
    /// The array of images.
    public let images: [UIImage]
    
    /// The compression quality used to encode the image in jpg.
    public let compressionQuality: CGFloat
        
    /// Utility class used to save images in the caches directory
    private let imagesUtilities = MBAdminImagesUtilities()
    
    /// Initializes an images element with the name, the locale and the images.
    /// - Parameters:
    ///   - elementName: The name/key of the element.
    ///   - localeIdentifier: The locale of the element.
    ///   - images: The text of the element.
    ///   - compressionQuality: The compression quality of the image (from 0 to 1), default is 1.
    init(elementName: String, localeIdentifier: String, images: [UIImage], compressionQuality: CGFloat = 1.0) {
        self.elementName = elementName
        self.localeIdentifier = localeIdentifier
        self.images = images
        self.compressionQuality = compressionQuality
        
        imagesUtilities.createDirectory(atPath: imagesUtilities.directoryURL)
        
        self.images.enumerated().forEach { (index, image) in
            let filePath = imagesUtilities.fileURL(forIndex: index)
            imagesUtilities.write(atPath: filePath, data: image.jpegData(compressionQuality: compressionQuality))
        }
    }
    
    /// Converts the element to an array of MBMultipartForm representing it.
    /// - Returns: An optional array of MBMultipartForm objects.
    public func toForm() -> [MBMultipartForm]? {
        var multipartElements: [MBMultipartForm]?
        if images.count != 0 {
            multipartElements = []
            self.images.enumerated().forEach { (index, _) in
                let filePath = imagesUtilities.fileURL(forIndex: index)
                multipartElements?.append(MBMultipartForm(name: parameterName(forIndex: index), url: filePath, mimeType: "image/jpeg"))
            }
        }
        return multipartElements
    }
    
    private func parameterName(forIndex index: Int) -> String {
        return String(format: "%@[%ld]", parameterName, index)
    }
}

internal extension FileManager {
    func documentsDir() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
    
    func cachesDir() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
}

internal extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let nsstring = self as NSString
        return nsstring.appendingPathComponent(path)
    }
}
