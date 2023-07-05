//
//  InputSource.swift
//  FLAnGuage
//
//  Created by Beer Koala on 30.05.2023.
//

import InputMethodKit

import Foundation

struct InputSource {
    var inputSource: TISInputSource

    var id: String {
        let inputSourceName = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID)
        return String.unsafeBitCast(from: inputSourceName)
    }

    var localizedName: String {
        let inputSourceID = TISGetInputSourceProperty(inputSource, kTISPropertyLocalizedName)
        return String.unsafeBitCast(from: inputSourceID)
    }

    var language: String {
        let inputSourceLanguage = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceLanguages)
        return String.unsafeBitCastArray(from: inputSourceLanguage).first ?? ""
    }

    // The possible values are specified by property value constants
    //  kTISCategoryKeyboardInputSource, kTISCategoryPaletteInputSource, kTISCategoryInkInputSource
    var category: String {
        let inputSourceLanguage = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceCategory)
        return String.unsafeBitCastArray(from: inputSourceLanguage).first ?? ""
    }

//    var image: NSImage? {
//        switch self.language {
//        case "en": return NSImage(named: "usa")
//        case "uk": return NSImage(named: "ukraine")
//        default: return nil
//        }
//    }

    var flagName: String? {

        if let storedTitle = UserDefaultStorage.inputSourceTitles[self.id] {
            return storedTitle
        }

        switch self.language {
        case "uk": return "🇺🇦"
        case "fr": return "🇫🇷"
        case "en":
            if self.id == "com.apple.CharacterPaletteIM" {
                return "😜"
            }
            return "🇬🇧"
        case "ar": return "🇦🇪"
        case "cs": return "🇨🇿"
        case "da": return "🇩🇰"
        case "de": return "🇩🇪"
        case "el": return "🇬🇷"
        case "es": return "🇪🇸"
        case "fi": return "🇫🇮"
        case "he": return "🇮🇱"
        case "hi", "bn", "ta": return "🇮🇳"
        case "it": return "🇮🇹"
        case "jp", "ja": return "🇯🇵"
        case "ko": return "🇰🇷"
        case "nl": return "🇧🇪"
        case "hu": return "🇭🇺"
        case "id": return "🇮🇩"
        case "no": return "🇳🇴"
        case "pl": return "🇵🇱"
        case "pt": return "🇵🇹"
        case "ro": return "🇷🇴"
        case "ru": return "🇷🇺"
        case "sk": return "🇸🇰"
        case "sv": return "🇸🇪"
        case "th": return "🇹🇭"
        case "tr": return "🇹🇷"
        case "zh": return "🇨🇳"
        default: return nil
        }
    }

    var statusBarName: String {
        if let name = self.flagName {
            return name
        } else {
            return "\(self.language)"
        }
    }

    var menuName: String {
        let statusBarName = self.statusBarName
        if statusBarName.count == 1 {
            return "\(self.flagName ?? "") \(self.localizedName)"
        }
        return statusBarName
    }

}

private extension String {
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

private extension Array where Element == InputSource {
    func appendEmoji() -> [InputSource] {
        if let emojiKeyboard = TISInputSource.emojiKeyboard() {
            return self + [emojiKeyboard]
        }
        return self
    }
}

extension TISInputSource {

    private static let filterKeyboardIS = [
        kTISPropertyInputSourceCategory: kTISCategoryKeyboardInputSource
    ] as CFDictionary

    func inputSource() -> InputSource {
        return InputSource(inputSource: self)
    }

    static func allKeyboardInputSources(_ allInstalled: Bool) -> [InputSource] {

        let allKeyboards = (
            TISCreateInputSourceList(filterKeyboardIS, allInstalled).takeRetainedValue() as? [TISInputSource] ?? []
        )
            .map {
                $0.inputSource()
            }
            .appendEmoji()

        return allKeyboards
            .filter {
                $0.id != "com.apple.PressAndHold"
            }
    }

    static func emojiKeyboard() -> InputSource? {
        let filterEmoji = [kTISPropertyInputSourceID: "com.apple.CharacterPaletteIM"] as CFDictionary

        return (TISCreateInputSourceList(filterEmoji, false).takeRetainedValue() as? [TISInputSource] ?? [])
            .first?
            .inputSource()
    }
}
