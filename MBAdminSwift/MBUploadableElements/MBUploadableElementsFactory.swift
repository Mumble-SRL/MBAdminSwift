//
//  MBUploadableElementsFactory.swift
//  MBurgerSwift
//
//  Created by Alessandro Viviani on 02/10/2019.
//  Copyright © 2019 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import Foundation
import UIKit

/// Used to create MBUploadableElement without specifiyng the locale for every item.
/// The locale is initialized with the factory and passed to all the objects. You can also change the locale and use the same instance of a MBUploadableElementsFactory to create objects with a different locale.
public struct MBUploadableElementsFactory {
    
    /// The locale identifier passed to every objects created.
    var localeIdentifier: String
    
    /// Initializes a factory with the locale identifier.
    /// - Parameters:
    ///   - localeIdentifier: The locale identifier.
    public init(localeIdentifier: String) {
        self.localeIdentifier = localeIdentifier
    }
    
    /// Creates a text element.
    /// - Parameters:
    ///   - name: The name of the element.
    ///   - text: The text.
    /// - Returns: A MBUploadableTextElement.
    public func createTextElement(name: String, text: String) -> MBUploadableTextElement {
        return MBUploadableTextElement(elementName: name, localeIdentifier: localeIdentifier, text: text)
    }
    
    /// Creates an images element with a single image.
    /// - Parameters:
    ///   - name: The name of the element.
    ///   - image: The image of the element.
    ///   - compressionQuality: The compression quality of the image (from 0 to 1), default is 1.
    /// - Returns: A MBUploadableImagesElement.
    public func createImageElement(name: String, image: UIImage, compressionQuality: CGFloat = 1) -> MBUploadableImagesElement {
           return MBUploadableImagesElement(elementName: name, localeIdentifier: localeIdentifier, images: [image], compressionQuality: compressionQuality)
    }
    
    /// Creates images element with an array of images.
    /// - Parameters:
    ///   - name: The name of the element.
    ///   - images: The images of the element.
    ///   - compressionQuality: The compression quality of the image (from 0 to 1), default is 1.
    /// - Returns: A MBUploadableImagesElement.
    public func createImagesElement(name: String, images: [UIImage], compressionQuality: CGFloat = 1) -> MBUploadableImagesElement {
        return MBUploadableImagesElement(elementName: name, localeIdentifier: localeIdentifier, images: images, compressionQuality: compressionQuality)
    }
        
    /// Creates a file element with a single file.
    /// - Parameters:
    ///   - name: The name of the element.
    ///   - file: The file of the element.
    /// - Returns: A MBUploadableFilesElement.
    public func createFileElement(name: String, file: URL) -> MBUploadableFilesElement {
        return MBUploadableFilesElement(elementName: name, localeIdentifier: localeIdentifier, fileUrls: [file])
    }
    
    /// Creates a file element with an array of files.
    /// - Parameters:
    ///   - name: The name of the element.
    ///   - files: The files of the element.
    /// - Returns: A MBUploadableFilesElement.
    public func createFilesElement(name: String, files: [URL]) -> MBUploadableFilesElement {
        return MBUploadableFilesElement(elementName: name, localeIdentifier: localeIdentifier, fileUrls: files)
    }
    
    /// Creates a media element with a single media.
    /// - Parameters:
    ///   - name: The name of the element.
    ///   - mediaUuid: The UUID of the MBurger media.
    /// - Returns: A MBUploadableMediaElement.
    public func createMediaElement(name: String, mediaUuid: UUID) -> MBUploadableMediaElement {
        return MBUploadableMediaElement(elementName: name, localeIdentifier: localeIdentifier, mediaUuids: [mediaUuid])
    }
    
    /// Creates a file element with an array of media.
    /// - Parameters:
    ///   - name: The name of the element.
    ///   - mediaUuids: The uuids of the media.
    /// - Returns: A MBUploadableMediaElement.
    public func createMediaElement(name: String, mediaUuids: [UUID]) -> MBUploadableMediaElement {
        return MBUploadableMediaElement(elementName: name, localeIdentifier: localeIdentifier, mediaUuids: mediaUuids)
    }

    /// Creates a checkbox element with a bool value.
    /// - Parameters:
    ///   - name: The name of the element.
    ///   - value: The value of the element.
    /// - Returns: A MBUploadableCheckboxElement.
    public func createCheckboxElement(name: String, value: Bool) -> MBUploadableCheckboxElement {
        return MBUploadableCheckboxElement(elementName: name, localeIdentifier: localeIdentifier, value: value)
    }

    /// Creates a relation element with the data for the relation.
    /// - Parameters:
    ///   - name: The name of the element.
    ///   - blockId: The id of the block for the relation.
    ///   - sectionId: The id of the section for the relation.
    /// - Returns: A MBUploadableRelationElement.
    public func createRelationElement(name: String,
                                      blockId: Int,
                                      sectionId: Int) -> MBUploadableRelationElement {
        return createRelationElement(name: name,
                                     blockId: blockId,
                                     sectionIds: [sectionId])
    }
    
    /// Creates a relation element with the data for the relation.
    /// - Parameters:
    ///   - name: The name of the element.
    ///   - blockId: The id of the block for the relation.
    ///   - sectionIds: The ids of the sections for the relation.
    /// - Returns: A MBUploadableRelationElement.
    public func createRelationElement(name: String,
                                      blockId: Int,
                                      sectionIds: [Int]) -> MBUploadableRelationElement {
        return MBUploadableRelationElement(elementName: name, localeIdentifier: localeIdentifier, sectionIds: sectionIds)
    }

    /// Creates a dropdown element with a selected value.
    /// - Parameters:
    ///   - name: The name of the element.
    ///   - value: The value of the element.
    /// - Returns: A MBUploadableDropdownElement.
    public func createDropdownElement(name: String, value: String) -> MBUploadableDropdownElement {
        return MBUploadableDropdownElement(elementName: name, localeIdentifier: localeIdentifier, value: value)
    }

    /// Creates a multiple element with an array of selected values.
    /// - Parameters:
    ///   - name: The name of the element.
    ///   - values: The values of the element.
    /// - Returns: A MBUploadableMultipleElement.
    public func createMultipleElement(name: String, values: [String]) -> MBUploadableMultipleElement {
        return MBUploadableMultipleElement(elementName: name, localeIdentifier: localeIdentifier, values: values)
    }

    /// Creates a color element with a color.
    /// - Parameters:
    ///   - name: The name of the element.
    ///   - color: The color of the element.
    /// - Returns: A MBUploadableMultipleElement.
    public func createColorElement(name: String, color: UIColor) -> MBUploadableColorElement {
        return MBUploadableColorElement(elementName: name, localeIdentifier: localeIdentifier, color: color)
    }

    /// Creates a slug element.
    /// - Parameters:
    ///   - slug: The value of the slug.
    /// - Returns: A MBUploadableTextElement representing the slug.
    public func createSlugElement(slug: String) -> MBUploadableTextElement {
        return MBUploadableTextElement(elementName: "mburger_slug", localeIdentifier: localeIdentifier, text: slug)
    }

}
