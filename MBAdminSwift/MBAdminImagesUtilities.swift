//
//  MBAdmin.swift
//  MBurgerSwift
//
//  Created by Alessandro Viviani on 02/10/2019.
//  Copyright © 2019 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import Foundation

internal class MBAdminImagesUtilities {
    /// The folder in which the images are saved.
    private var imageFolderPath: String = {
        let path = String(format: "mbadmin_images_%f", Date().timeIntervalSince1970)
        return path
    }()
    
    /// The URL of the directory.
    internal var directoryURL: URL {
        let cachesFilePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
        let folderPath = URL(fileURLWithPath: cachesFilePath ?? "").appendingPathComponent(imageFolderPath)
        return folderPath
    }

    internal func createDirectory(atPath path: URL) {
        do {
            try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    internal func write(atPath path: URL, data: Data?) {
        do {
            try data?.write(to: path, options: .atomic)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    internal func fileURL(forIndex index: Int,
                          name: String? = nil) -> URL {
        return directoryURL.appendingPathComponent(fileName(forIndex: index))
    }
    
    internal func fileName(forIndex index: Int) -> String {
        return String(format: "Images_%d.jpg", index)
    }
}
