//
//  MBUploadableColorElement.swift
//  MBAdmin
//
//  Created by Lorenzo Oliveto on 21/07/2020.
//  Copyright © 2020 Mumble S.r.l (https://mumbleideas.it). All rights reserved.
//

import UIKit
import MBNetworkingSwift

/// An uploadable element representing a color.
public struct MBUploadableColorElement: MBUplodableElementProtocol {
    /// The locale of the element. This is needed to construct the parameter name.
    public var localeIdentifier: String
    
    /// The name/key of the element.
    public var elementName: String
    
    /// The text of the element.
    public let color: UIColor

    /// Initializes a color element with the name, the locale and a color.
    /// - Parameters:
    ///   - elementName: The name/key of the element.
    ///   - localeIdentifier: The locale of the element.
    ///   - color: The color of the element.
    init(elementName: String, localeIdentifier: String, color: UIColor) {
        self.localeIdentifier = localeIdentifier
        self.elementName = elementName
        self.color = color
    }
    
    /// Converts the element to an array of MBMultipartForm representing it.
    /// - Returns: An optional array of MBMultipartForm objects.
    public func toForm() -> [MBMultipartForm]? {
        let hexString = hexSrtingForColor()
        guard let data = hexString.data(using: .utf8) else { return nil }
        return [MBMultipartForm(name: parameterName, data: data)]
    }

    private func hexSrtingForColor() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let rgb: Int = (Int)(red*255)<<16 | (Int)(green*255)<<8 | (Int)(blue*255)<<0
        
        return String(format:"#%06x", rgb)
    }

}
