//
//  MBAdminPushSettings.swift
//  MBAdminSwift
//
//  Created by Lorenzo Oliveto on 24/11/20.
//  Copyright © 2020 Mumble S.r.l (https://mumbleideas.it). All rights reserved.
//

import UIKit
import MBNetworkingSwift

/// This object is used to setup push notifications when creating or updating a section
public class MBAdminPushSettings: NSObject {
    /// If a notification should be sent
    let wantsPush: Bool!
    /// An optional body for the push notification
    let pushBody: String?
    
    /// Initializes the push notificatification settings
    /// - Parameters:
    ///   - wantsPush: If a notification should be sent
    ///   - pushBody: An optional body for the push notification
    public init(wantsPush: Bool!,
                pushBody: String? = nil) {
        self.wantsPush = wantsPush
        self.pushBody = pushBody
    }
    
    /// Converts this object to a multipart form
    internal func toForm() -> [MBMultipartForm] {
        guard wantsPush else {
            return []
        }
        var forms = [MBMultipartForm]()
        forms.append(MBMultipartForm(name: "wants_push",
                                     data: "true".data(using: .utf8) ?? Data()))
        if let pushBody = pushBody {
            forms.append(MBMultipartForm(name: "push_body",
                                         data: pushBody.data(using: .utf8) ?? Data()))

        }
        return forms
    }
}
