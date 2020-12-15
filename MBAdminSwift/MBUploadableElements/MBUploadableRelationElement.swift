//
//  MBUploadableRelationElement.swift
//  MBAdmin
//
//  Created by Lorenzo Oliveto on 21/07/2020.
//  Copyright © 2020 Mumble S.r.l (https://mumbleideas.it). All rights reserved.
//

import UIKit
import MBNetworkingSwift

/// An uploadable element representing a relation between sections.
public struct MBUploadableRelationElement: MBUplodableElement {
    /// The locale of the element. This is needed to construct the parameter name.
    public var localeIdentifier: String
    
    /// The name/key of the element.
    public var elementName: String
    
    /// The ids of the sections of the element.
    public let sectionIds: [Int]

    /// Initializes a relation element with the name, the locale and section ids.
    /// - Parameters:
    ///   - elementName: The name/key of the element.
    ///   - localeIdentifier: The locale of the element.
    ///   - sectionIds: The ids of the sections of the element.
    init(elementName: String, localeIdentifier: String, sectionIds: [Int]) {
        self.localeIdentifier = localeIdentifier
        self.elementName = elementName
        self.sectionIds = sectionIds
    }
    
    fileprivate func parameterName(forIndex index: Int) -> String {
        return String(format: "%@[%ld]", elementName, index)
    }

    /// Converts the element to an array of MBMultipartForm representing it.
    /// - Returns: An optional array of MBMultipartForm objects.
    public func toForm() -> [MBMultipartForm]? {
        var multipartElements: [MBMultipartForm]?
        if sectionIds.count != 0 {
            multipartElements = []
            for (index, sectionId) in sectionIds.enumerated() {
                guard let data = String(sectionId).data(using: .utf8) else { continue }
                multipartElements?.append(MBMultipartForm(name: parameterName(forIndex: index), data: data))
            }
        }
        return multipartElements
    }

}
