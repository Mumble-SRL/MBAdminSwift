<p align="center" >
<img src="https://raw.githubusercontent.com/Mumble-SRL/MBurgerSwift/master/Images/mburger-icon.png" alt="MBurger Logo" title="MBurger Logo">
</p>

![Test Status](https://img.shields.io/badge/documentation-100%25-brightgreen.svg)
![License: MIT](https://img.shields.io/badge/pod-v1.0.1-blue.svg)
[![CocoaPods](https://img.shields.io/badge/License-Apache%202.0-yellow.svg)](LICENSE)


# MBAdmin

In the MBAdmin package you can find the functions to edit the sections of MBurger.
You will have to use a token with write permissions to edit the sections and with delete permission to delete them.

# Installation

## Swift Package Manager

With Xcode 11 you can start using [Swift Package Manager](https://swift.org/package-manager/) to add **MBAdmin** to your project. Follow those simple steps:

* In Xcode go to File > Swift Packages > Add Package Dependency.
* Enter `https://github.com/Mumble-SRL/MBAdminSwift.git` in the "Choose Package Repository" dialog and press Next.
* Specify the version using rule "Up to Next Major" with "1.0.6" as its earliest version and press Next.
* Xcode will try to resolving the version, after this, you can choose the `MBAdminSwift` library and add it to your app target.

## CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa Projects, which automates and simplifies the process of using 3rd-party libraries in your projects. You can install CocoaPods with the following command:

```ruby
$ gem install cocoapods
```

To integrate the MBurgerSwift into your Xcode project using CocoaPods, specify it in your Podfile:

```ruby
platform :ios, '10.0'

target 'TargetName' do
    pod 'MBAdminSwift' '~> 1.0.6'
end
```

## Chartage
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate MBAdmin into your Xcode project using Carthage, specify it in your Cartfile:

```
github "Mumble-SRL/MBAdminSwift"
```

## Manual installation

To install the library manually drag and drop the folder `MBAdminSwift` to your project structure in XCode. 

Note that `MBAdminSwift` has `MBurgerSwift` as a dependency, so you have to install also this library manually.

# Add/Edit a section

You can add a section to a block with the function `addSectionToBlock(withBlockId:elements:success:failure:)`. To call this function you need to create an array of elements confrom to `MBUploadableElementProtocol`. To create it use the `MBUploadableElementsFactory` that is created. A MBUploadableElementsFactory is allocated with a locale identifier and creates object with this locale identifier. All the integrity controls of the server are still present in the APIs, you will find the description of the error in the object passed to the failure block. Below an example code to create a section. 

```swift
let factory = MBUploadableElementsFactory(localeIdentifier: "it")
let elements: [MBUplodableElementProtocol] = [factory.createTextElement(name: "name", text: "text"),
factory.createImageElement(name: "name", image: UIImage(named: "image_name")!)]

MBAdmin.addSectionToBlock(withBlockId: 621, elements: elements, success: { sectionId in

}, failure: { (error) in
            
})         
```

With a `MBUploadableElementsFactory` you can create: 

* an array or a single of image with `MBUploadableImagesElement`
* an array or a single of image with `MBUploadableFilesElement`
* a text with `MBUploadableTextElement`
* a checkbox element with `MBUploadableCheckboxElement`

The edit function is very similar to the add. It will modifiy only the fields passed and the other elements will remain untouched.

# Delete a section

To delete a section with an id:

```swift
MBAdmin.deleteSection(withSectionId: SECTION_ID, success: {

}, failure: { (error) in
      
})

```

# Delete a media

You can delete a media(`MBFile`) using `deleteMedia(withMediaId:success:failure:)` that requires the id of the media to delete. The id of the media is the field id of the `MBFile`.

```swift
MBAdmin.deleteMedia(withMediaId: MEDIA_ID, success: {
            
}, failure: { (error) in
            
})
```

# Documentation

For additional information, you can check out the full [docs](https://github.com/Mumble-SRL/MBAdmin/tree/master/docs).

Since this SDK extends [MBurger](https://github.com/Mumble-SRL/MBurgerSwift), you can check out the full [reference doc](https://github.com/Mumble-SRL/MBurgerSwift/tree/master/docs) of the MBurger SDK.


