//
//  MBUploadableMultipleElement.swift
//  MBAdmin
//
//  Created by Lorenzo Oliveto on 23/07/2020.
//  Copyright © 2020 Mumble S.r.l (https://mumbleideas.it). All rights reserved.
//

import UIKit
import MBNetworkingSwift

/// An uploadable element representing a multiple element.
public class MBUploadableMultipleElement: MBUplodableElement {
    /// The locale of the element. This is needed to construct the parameter name.
    public var localeIdentifier: String
    
    /// The name/key of the element.
    public var elementName: String
    
    /// The values selected.
    public let values: [String]

    /// Initializes a multiple element with the name, the locale and values selected.
    /// - Parameters:
    ///   - elementName: The name/key of the element.
    ///   - localeIdentifier: The locale of the element.
    ///   - values: The values selected for this element.
    init(elementName: String, localeIdentifier: String, values: [String]) {
        self.localeIdentifier = localeIdentifier
        self.elementName = elementName
        self.values = values
    }
    
    fileprivate func parameterName(forIndex index: Int) -> String {
        return String(format: "%@[%ld]", parameterName, index)
    }

    /// Converts the element to an array of MBMultipartForm representing it.
    /// - Returns: An optional array of MBMultipartForm objects.
    public func toForm() -> [MBMultipartForm]? {
        var multipartElements: [MBMultipartForm]?
        if values.count != 0 {
            multipartElements = []
            self.values.enumerated().forEach { (index, value) in
                if let data = String(value).data(using: .utf8) {
                    multipartElements?.append(MBMultipartForm(name: parameterName(forIndex: index), data: data))
                }
            }
        }
        return multipartElements
    }

}
