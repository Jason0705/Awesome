//
//  Fonts.swift
//  Awesome
//
//  Created by Ondrej Rafaj on 14/10/2017.
//

import Foundation
import CoreGraphics
import CoreText


public extension Awesome {
    
    public enum Font: String, AwesomeFont {
        case brand = "fa-brands-400"
        case regular = "fa-regular-400"
        case solid = "fa-solid-900"
        
        public var file: String {
            return rawValue
        }
        
        public var name: String {
            switch self {
            case .brand:
                return "Font Awesome 5 Brands"
            case .regular, .solid:
                return "Font Awesome 5 Free"
            }
        }
        
        public var memberName: String {
            switch self {
            case .brand:
                return "FontAwesome5BrandsRegular"
            case .regular:
                return "FontAwesome5FreeRegular"
            case .solid:
                return "FontAwesome5FreeSolid"
            }
        }
    }
    
}

public extension AwesomePro {

    public enum Font: String, AwesomeFont {
        case brand = "fa-brands-400"
        case regular = "fa-regular-400"
        case solid = "fa-solid-900"
        case light = "fa-light-300"

        public var file: String {
            return rawValue
        }

        public var name: String {
            switch self {
                case .brand:
                    return "Font Awesome 5 Brands"
                case .regular, .solid, .light:
                    return "Font Awesome 5 Pro"
            }
        }

        public var memberName: String {
            switch self {
                case .brand:
                    return "FontAwesome5ProBrands"
                case .regular:
                    return "FontAwesome5ProRegular"
                case .solid:
                    return "FontAwesome5ProSolid"
                case .light:
                    return "FontAwesome5ProLight"
            }
        }
    }

    static func loadFonts(from bundle: Bundle) {
        let fonts: [Font] = [.brand, .regular, .solid, .light]

        for font in fonts {
            Fonts.load(type: font, from: bundle)
        }
    }

}

class Fonts {

    static func load(type: AwesomeFont, from bundle: Bundle? = nil) {
        guard !Font.fontNames(forFamilyName: type.name).contains(type.memberName) else {
            return
        }

        #if os(iOS) || os(watchOS) || os(tvOS)
        let fontBundle: Bundle!
        if bundle == nil {
            fontBundle = Bundle(for: Fonts.self)
        } else {
            fontBundle = bundle
        }

        var fontURL: URL!
        let identifier = fontBundle.bundleIdentifier

        if identifier?.hasPrefix("org.cocoapods") == true {
            fontURL = fontBundle.url(forResource: type.file, withExtension: "ttf", subdirectory: "Awesome.bundle")
        } else {
            print(identifier)
            print(type.file)
            fontURL = fontBundle.url(forResource: type.file, withExtension: "ttf")
        }

        print(fontURL)

        let data = try! Data(contentsOf: fontURL as URL)
        let provider = CGDataProvider(data: data as CFData)
        let font = CGFont(provider!)

        var error: Unmanaged<CFError>?

        if CTFontManagerRegisterGraphicsFont(font!, &error) == false {
            let errorDescription: CFString = CFErrorCopyDescription(error!.takeUnretainedValue())
            let nsError = error!.takeUnretainedValue() as AnyObject as! NSError
            NSException(name: NSExceptionName.internalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError]).raise()
        }
        #elseif os(OSX)
        
        #endif
        
    }
    
}
