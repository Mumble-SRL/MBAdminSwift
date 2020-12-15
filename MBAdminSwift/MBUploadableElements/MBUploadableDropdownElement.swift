//
//  MBUploadableDropdownElement.swift
//  MBAdminSwift
//
//  Created by Lorenzo Oliveto on 18/11/20.
//  Copyright © 2020 Mumble S.r.l (https://mumbleideas.it). All rights reserved.
//

import UIKit
import MBNetworkingSwift

/// An uploadable element representing a dropdown element.
public class MBUploadableDropdownElement: MBUplodableElement {
    /// The locale of the element. This is needed to construct the parameter name.
    public var localeIdentifier: String
    
    /// The name/key of the element.
    public var elementName: String
    
    /// The value selected.
    public let value: String

    /// Initializes a dropdown element with the name, the locale and value selected.
    /// - Parameters:
    ///   - elementName: The name/key of the element.
    ///   - localeIdentifier: The locale of the element.
    ///   - value: The value selected for this element.
    init(elementName: String, localeIdentifier: String, value: String) {
        self.localeIdentifier = localeIdentifier
        self.elementName = elementName
        self.value = value
    }
    
    /// Converts the element to an array of MBMultipartForm representing it.
    /// - Returns: An optional array of MBMultipartForm objects.
    public func toForm() -> [MBMultipartForm]? {
        guard let data = value.data(using: .utf8) else { return nil }
        return [MBMultipartForm(name: parameterName, data: data)]
    }

}
