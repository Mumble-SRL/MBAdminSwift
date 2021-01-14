//
//  MBAdmin.swift
//  MBurgerSwift
//
//  Created by Alessandro Viviani on 02/10/2019.
//  Copyright © 2019 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import Foundation
import MBNetworkingSwift
import MBurgerSwift

/// Manages the calls to the MBurger admin APIs.
public struct MBAdmin {
    // MARK: - Sections
    
    /// Add a section to the block with the specified id.
    /// - Parameters:
    ///   - blockId: The `id` of the block
    ///   - elements: An `Array` of the elements to upload. They must conform to MBUplodableElementProtocol
    ///   - visibilitySettings: This property will tell MBurger the visibility settings for the section
    ///   - pushSettings: This property will tell MBurger if it should send a push notification when the section is published
    ///   - success: A block that will be called when the request ends successfully. This block has no return value and takes one argument.
    ///   - sectionId: The `id` of the created section.
    ///   - failure: A block that will be called when the request ends incorrectly. This block has no return value and takes one argument.
    ///   - error: The error describing the error that occurred.
    public static func addSectionToBlock(withBlockId blockId: Int,
                                         elements: [MBUplodableElement],
                                         visibilitySettings: MBAdminVisibilitySettings? = nil,
                                         pushSettings: MBAdminPushSettings? = nil,
                                         success: @escaping(_ sectionId: Int) -> Void,
                                         failure: @escaping(_ error: Error) -> Void) {
        var multipartForms = [MBMultipartForm]()
        
        if let visibilitySettings = visibilitySettings {
            multipartForms.append(contentsOf: visibilitySettings.toForm())
        }
        if let pushSettings = pushSettings {
           multipartForms.append(contentsOf: pushSettings.toForm())
        }

        for element in elements {
            if let formElement = element.toForm() {
                formElement.forEach({ multipartForms.append($0) })
            }
        }
                
        let apiName = String(format: "blocks/%ld/sections", blockId)
        MBApiManager.upload(withToken: MBManager.shared.apiToken,
                            locale: MBManager.shared.localeString,
                            apiName: apiName,
                            method: .post,
                            multipartParameters: multipartForms,
                            development: MBManager.shared.development) { (response) in
                                switch response {
                                case .success(_, let data):
                                    guard let data = data else {
                                        failure(MBError.customError(reason: "Can't find response"))
                                        return
                                    }
                                    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                                        failure(MBError.customError(reason: "Can't decode response"))
                                        return
                                    }
                                    guard let jsonDictionary = json as? [String: Any],
                                          let body = jsonDictionary["body"] as? [String: Any],
                                          let sectionId = body["id"] as? Int else {
                                        failure(MBError.customError(reason: "Can't find section id"))
                                        return
                                    }
                                    success(sectionId)
                                case .error(let error):
                                    failure(error)
                                }
        }
    }
    
    /// Edit the section with the specified id.
    /// - Parameters:
    ///   - id: The `id` of the section.
    ///   - elements: An `Array` of the elements to upload. They must conform to MBUplodableElementProtocol.
    ///   - visibilitySettings: This property will tell MBurger the visibility settings for the section
    ///   - pushSettings: This property will tell MBurger if it should send a push notification when the section is published
    ///   - success: A block that will be called when the request ends successfully. This block has no return value and takes no argument.
    ///   - failure: A block that will be called when the request ends incorrectly. This block has no return value and takes one argument.
    ///   - error: The error describing the error that occurred.
    public static func editSection(withSectionId id: Int,
                                   elements: [MBUplodableElement],
                                   visibilitySettings: MBAdminVisibilitySettings? = nil,
                                   pushSettings: MBAdminPushSettings? = nil,
                                   success: @escaping() -> Void,
                                   failure: @escaping(_ error: Error) -> Void) {
        var multipartForms = [MBMultipartForm]()
        
        if let visibilitySettings = visibilitySettings {
            multipartForms.append(contentsOf: visibilitySettings.toForm())
        }
        if let pushSettings = pushSettings {
           multipartForms.append(contentsOf: pushSettings.toForm())
        }

        for element in elements {
            if let formElements = element.toForm() {
                formElements.forEach({ multipartForms.append($0) })
            }
        }
        
        let apiName = String(format: "sections/%ld/update", id)
        MBApiManager.upload(withToken: MBManager.shared.apiToken,
                            locale: MBManager.shared.localeString,
                            apiName: apiName,
                            method: .post,
                            multipartParameters: multipartForms,
                            development: MBManager.shared.development) { (response) in
                                switch response {
                                case .success:
                                    success()
                                case .error(let error):
                                    print(error.localizedDescription)
                                    failure(error)
                                }
        }
    }
    
    /// Remove the section with the specified id.
    /// - Parameters:
    ///   - id: The `id` of the section.
    ///   - success: A block that will be called when the request ends successfully. This block has no return value and takes no argument.
    ///   - failure: A block that will be called when the request ends incorrectly. This block has no return value and takes one argument.
    ///   - error: The error describing the error that occurred.
    public static func deleteSection(withSectionId id: Int,
                                     success: @escaping() -> Void,
                                     failure: @escaping(_ error: Error) -> Void) {
        let apiName = String(format: "sections/%ld/", id)
        MBApiManager.request(withToken: MBManager.shared.apiToken,
                             locale: MBManager.shared.localeString,
                             apiName: apiName,
                             method: .delete,
                             success: { (_) in
                                success()
        }, failure: { error in
            failure(error)
        })
    }
    
    // MARK: - Media
        
    /// Uploads an image to the media center of MBurger.
    /// - Parameters:
    ///   - image: The `image` that will be uploaded.
    ///   - name: On optional name for the image.
    ///   - compressionQuality: The compression quality of the image, image data will be saved in jpg. If you want to send the image without compression use `MBAdmin.uploadMedia(...)`
    ///   - success: A block that will be called when the request ends successfully. This block has no return value and takes no argument.
    ///   - media: The media created in the media center of MBurger.
    ///   - failure: A block that will be called when the request ends incorrectly. This block has no return value and takes one argument.
    ///   - error: The error describing the error that occurred.
    public static func uploadMediaImage(image: UIImage,
                                        name: String? = nil,
                                        compressionQuality: CGFloat = 1.0,
                                        success: @escaping(_ media: MBMedia) -> Void,
                                        failure: @escaping(_ error: Error) -> Void) {
        var imagesNames: [String]?
        if let name = name {
            imagesNames = [name]
        }
        self.uploadMediaImages(images: [image],
                               names: imagesNames,
                               success: { media in
                                  guard let firstMedia = media.first else {
                                      failure(MBError.customError(reason: "Can't find media"))
                                      return
                                  }
                                  success(firstMedia)
                               },
                               failure: failure)
    }

    /// Uploads an array of images to the media center of MBurger.
    /// - Parameters:
    ///   - images: The `images` that will be uploaded.
    ///   - names: On optional array of names for the images, if it's null they will be called Image_0, Image_1, etc.
    ///   - compressionQuality: The compression quality of the images, images data will be saved in jpg. If you want to send the image without compression use `MBAdmin.uploadMedia(...)`
    ///   - success: A block that will be called when the request ends successfully. This block has no return value and takes no argument.
    ///   - media: The media created in the media center of MBurger.
    ///   - failure: A block that will be called when the request ends incorrectly. This block has no return value and takes one argument.
    ///   - error: The error describing the error that occurred.
    public static func uploadMediaImages(images: [UIImage],
                                         names: [String]? = nil,
                                         compressionQuality: CGFloat = 1.0,
                                         success: @escaping(_ media: [MBMedia]) -> Void,
                                         failure: @escaping(_ error: Error) -> Void) {
        var multipartParameters = [MBMultipartForm]()
        let imagesUtilities = MBAdminImagesUtilities()
        imagesUtilities.createDirectory(atPath: imagesUtilities.directoryURL)
        for (index, image) in images.enumerated() {
            var imageName: String?
            if let names = names,
               index < names.count {
                imageName = names[index]
            }
            var fileUrl = imagesUtilities.fileURL(forIndex: index)
            if let imageName = imageName {
                fileUrl = imagesUtilities.directoryURL.appendingPathComponent(imageName + ".jpg")
            }
            imagesUtilities.write(atPath: fileUrl, data: image.jpegData(compressionQuality: compressionQuality))
            let parameterName = String(format: "media[%d]", index)
            multipartParameters.append(MBMultipartForm(name: parameterName, url: fileUrl, mimeType: "image/jpeg"))
        }
        uploadMedia(multipartParameters: multipartParameters,
                    success: success,
                    failure: failure)
    }

    /// Uploads a media to the media center of MBurger.
    /// - Parameters:
    ///   - media: The url of the `media` that will be uploaded.
    ///   - success: A block that will be called when the request ends successfully. This block has no return value and takes no argument.
    ///   - media: The media created in the media center of MBurger.
    ///   - failure: A block that will be called when the request ends incorrectly. This block has no return value and takes one argument.
    ///   - error: The error describing the error that occurred.
    public static func uploadMedia(media: URL,
                                   success: @escaping(_ media: MBMedia) -> Void,
                                   failure: @escaping(_ error: Error) -> Void) {
        self.uploadMedia(media: [media],
                         success: { media in
                            guard let firstMedia = media.first else {
                                failure(MBError.customError(reason: "Can't find media"))
                                return
                            }
                            success(firstMedia)
                         },
                         failure: failure)
    }

    /// Uploads an array of media to the media center of MBurger.
    /// - Parameters:
    ///   - media: The urls of the `media` that will be uploaded.
    ///   - success: A block that will be called when the request ends successfully. This block has no return value and takes no argument.
    ///   - media: The media created in the media center of MBurger.
    ///   - failure: A block that will be called when the request ends incorrectly. This block has no return value and takes one argument.
    ///   - error: The error describing the error that occurred.
    public static func uploadMedia(media: [URL],
                                   success: @escaping(_ media: [MBMedia]) -> Void,
                                   failure: @escaping(_ error: Error) -> Void) {
        var multipartParameters = [MBMultipartForm]()
        for (index, mediaUrl) in media.enumerated() {
            let parameterName = String(format: "media[%d]", index)
            multipartParameters.append(MBMultipartForm(name: parameterName, url: mediaUrl))
        }
        uploadMedia(multipartParameters: multipartParameters,
                    success: success,
                    failure: failure)
    }

    /// Uploads an array of media to the media center of MBurger, giving the multipart parameter.
    /// It's used by the other function, calls the API and returns the data
    /// - Parameters:
    ///   - multipartParameters: The multipart parameters sent to the API.
    ///   - success: A block that will be called when the request ends successfully. This block has no return value and takes no argument.
    ///   - media: The media created in the media center of MBurger.
    ///   - failure: A block that will be called when the request ends incorrectly. This block has no return value and takes one argument.
    ///   - error: The error describing the error that occurred.
    private static func uploadMedia(multipartParameters: [MBMultipartForm],
                                    success: @escaping(_ media: [MBMedia]) -> Void,
                                    failure: @escaping(_ error: Error) -> Void) {
        let apiName = "media"
        MBApiManager.upload(withToken: MBManager.shared.apiToken,
                            locale: MBManager.shared.localeString,
                            apiName: apiName,
                            method: .post,
                            multipartParameters: multipartParameters,
                            development: MBManager.shared.development) { (response) in
                                switch response {
                                case .success(_, let data):
                                    guard let data = data else {
                                        failure(MBError.customError(reason: "Can't find response"))
                                        return
                                    }
                                    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                                        failure(MBError.customError(reason: "Can't decode response"))
                                        return
                                    }
                                    guard let jsonDictionary = json as? [String: Any],
                                          let body = jsonDictionary["body"] as? [[String: Any]] else {
                                        failure(MBError.customError(reason: "Can't find section id"))
                                        return
                                    }
                                    let media = body.map({ MBMedia(dictionary: $0) })
                                    success(media)
                                case .error(let error):
                                    failure(error)
                                }
        }
    }
    
    /// Remove the media (image or file) with the specified id.
    /// - Parameters:
    ///   - id: The `id` of the media.
    ///   - success: A block that will be called when the request ends successfully. This block has no return value and takes no argument.
    ///   - failure: A block that will be called when the request ends incorrectly. This block has no return value and takes one argument.
    ///   - error: The error describing the error that occurred.
    public static func deleteMedia(withMediaId id: Int,
                                   success: @escaping() -> Void,
                                   failure: @escaping(_ error: Error) -> Void) {
        let apiName = String(format: "media/%ld/", id)
        MBApiManager.request(withToken: MBManager.shared.apiToken,
                             locale: MBManager.shared.localeString,
                             apiName: apiName,
                             method: .delete,
                             success: { _ in
                                success()
        }, failure: { error in
            failure(error)
        })
    }

}
