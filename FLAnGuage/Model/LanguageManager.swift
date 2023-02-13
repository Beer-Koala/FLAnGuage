//
//  LanguageManager.swift
//  FLAnGuage
//
//  Created by Beer Koala on 09.02.2023.
//

import InputMethodKit

struct LanguageManager {

    static var currentLanguage: TISInputSource {
        return TISCopyCurrentKeyboardInputSource().takeRetainedValue()
    }

    static var availableLanguages: [TISInputSource] {
        return TISCreateInputSourceList(nil, false).takeRetainedValue() as? Array<TISInputSource> ?? []
    }

    static var allLanguages: [TISInputSource] {
        return TISCreateInputSourceList(nil, true).takeRetainedValue() as? Array<TISInputSource> ?? []
    }

    static func id(for inputSource: TISInputSource) -> String {
        let inputSourceName = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID)
        return String.unsafeBitCast(from: inputSourceName)
    }

    static func name(for inputSource: TISInputSource) -> String {
        let inputSourceID = TISGetInputSourceProperty(inputSource, kTISPropertyLocalizedName)
        return String.unsafeBitCast(from: inputSourceID)
    }

    static func set(_ iputSource: TISInputSource) {
        TISSelectInputSource(iputSource)
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
}
