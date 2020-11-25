//
//  MBAdminVisibilitySettings.swift
//  MBAdminSwift
//
//  Created by Lorenzo Oliveto on 24/11/20.
//  Copyright © 2020 Mumble S.r.l (https://mumbleideas.it). All rights reserved.
//

import UIKit
import MBNetworkingSwift

/// The possible visibility values for a section.
public enum MBAdminVisibility: String {
    /// The section is published in draft.
    case draft
    /// The section is published as visible.
    case visible
    /// The section is published as scheduled.
    case scheduled
}

/// This object is used to visibility of a section when creating or updating it.
public class MBAdminVisibilitySettings: NSObject {
    /// The visibility of the section.
    let visibility: MBAdminVisibility!
    
    /// If the visibiity is scheduled, the date the section will be published, for other visibilities it's ignored.
    let availableAt: Date?
    
    /// Initializes the visibility settings
    /// - Parameters:
    ///   - visibility: The visibility of the section.
    ///   - availableAt: If the visibiity is scheduled, the date the section will be published, for other visibilities it's ignored.
    public init(visibility: MBAdminVisibility!,
                availableAt: Date? = nil) {
        self.visibility = visibility
        self.availableAt = availableAt
    }
    
    /// Creates and initializes a `MBAdminVisibilitySettings` with the visible option
    public static func visible() -> MBAdminVisibilitySettings {
        return MBAdminVisibilitySettings(visibility: .visible)
    }
    
    /// Creates and initializes a `MBAdminVisibilitySettings` with the draft option
    public static func draft() -> MBAdminVisibilitySettings {
        return MBAdminVisibilitySettings(visibility: .draft)
    }

    /// Creates and initializes a `MBAdminVisibilitySettings` with the scheduled option
    /// - Parameters:
    ///   - availableAt: The availability date of the section
    public static func scheduled(availableAt: Date) -> MBAdminVisibilitySettings {
        return MBAdminVisibilitySettings(visibility: .scheduled,
                                         availableAt: availableAt)
    }

    /// Converts this object to a multipart form
    internal func toForm() -> [MBMultipartForm] {
        var forms = [MBMultipartForm]()
        forms.append(MBMultipartForm(name: "visibility",
                                     data: visibility.rawValue.data(using: .utf8) ?? Data()))
        if visibility == .scheduled {
            let date = availableAt ?? Date()
            forms.append(MBMultipartForm(name: "available_at",
                                         data: String(date.timeIntervalSince1970).data(using: .utf8) ?? Data()))

        }
        return forms
    }

}
