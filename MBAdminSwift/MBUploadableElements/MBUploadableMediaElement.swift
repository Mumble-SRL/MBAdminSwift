//
//  MBUploadableMediaElement.swift
//  MBAdminSwift
//
//  Created by Lorenzo Oliveto on 12/01/21.
//

import Foundation
import MBNetworkingSwift

/// An uploadable element representing some MBurger media.
public struct MBUploadableMediaElement: MBUplodableElement {
    
    /// The locale of the element. This is needed to construct the parameter name.
    public var localeIdentifier: String
    
    /// The name/key of the element.
    public var elementName: String
    
    /// The array of uuid of the MBurger media.
    public let mediaUuids: [UUID]
        
    /// Initializes a text element with the name, the locale and the uuid of media.
    /// - Parameters:
    ///   - elementName: The name/key of the element.
    ///   - localeIdentifier: The locale of the element.
    ///   - mediaUuids: The uuid of media.
    init(elementName: String, localeIdentifier: String, mediaUuids: [UUID]) {
        self.elementName = elementName
        self.localeIdentifier = localeIdentifier
        self.mediaUuids = mediaUuids
    }
    
    /// Converts the element to an array of MBMultipartForm representing it.
    /// - Returns: An optional array of MBMultipartForm objects.
    public func toForm() -> [MBMultipartForm]? {
        var multipartElements: [MBMultipartForm]?
        if mediaUuids.count != 0 {
            multipartElements = []
            do {
                let mediaUuidStrings = mediaUuids.map({ $0.uuidString.lowercased() })
                let serializedData = try JSONSerialization.data(withJSONObject: mediaUuidStrings, options: [])
                multipartElements?.append(MBMultipartForm(name: parameterName, data: serializedData))
            } catch {
            
            }
        }
        return multipartElements
    }
}
