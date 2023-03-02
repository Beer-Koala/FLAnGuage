//
//  LanguageManager.swift
//  FLAnGuage
//
//  Created by Beer Koala on 09.02.2023.
//

import InputMethodKit

struct LanguageManager {

    static var currentLanguage: InputSource {
        return TISCopyCurrentKeyboardInputSource().takeRetainedValue().inputSource()
    }

    static var availableLanguages: [InputSource] {
        return (TISCreateInputSourceList(nil, false).takeRetainedValue() as? Array<TISInputSource> ?? [])
            .map {
                $0.inputSource()
            }
    }

    static var allLanguages: [InputSource] {
        return (TISCreateInputSourceList(nil, true).takeRetainedValue() as? Array<TISInputSource> ?? [])
            .map {
                $0.inputSource()
            }
    }

    static func set(_ inputSource: InputSource) {
        TISSelectInputSource(inputSource.inputSource)
    }

    static let changeLanguageNotificationName: NSNotification.Name = NSNotification.Name(rawValue: kTISNotifySelectedKeyboardInputSourceChanged as String)
}

extension String {
    static func unsafeBitCast(from inputSourceProperty: UnsafeMutableRawPointer?) -> String {
        if let inputSourceProperty = inputSourceProperty {
            return Swift.unsafeBitCast(inputSourceProperty, to: CFString.self) as String
        } else {
            return String.empty
        }
    }

    static func unsafeBitCastArray(from inputSourceProperty: UnsafeMutableRawPointer?) -> [String] {
        if let inputSourceProperty = inputSourceProperty {
            return Swift.unsafeBitCast(inputSourceProperty, to: CFArray.self) as? [String] ?? []
        } else {
            return []
        }
    }
}


struct InputSource {
    var inputSource: TISInputSource

    var id: String {
        let inputSourceName = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID)
        return String.unsafeBitCast(from: inputSourceName)
    }
    var name: String {
        let inputSourceID = TISGetInputSourceProperty(inputSource, kTISPropertyLocalizedName)
        return String.unsafeBitCast(from: inputSourceID)
    }

    var language: String {
        let inputSourceLanguage = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceLanguages)
        return String.unsafeBitCastArray(from: inputSourceLanguage).first ?? ""
    }

    var image: NSImage? {
        switch self.language {
        case "en": return NSImage(named: "usa")
        case "uk": return NSImage(named: "ukraine")
        default: return nil
        }
    }

    var shortName: String {
        switch self.language {
        case "en": return "🇺🇸"
        case "uk": return "🇺🇦"
        default: return "\(self.id) - \(self.name) - \(self.language)"
        }
    }
}

extension TISInputSource {

    func inputSource() -> InputSource {
        return InputSource(inputSource: self)
    }
}
