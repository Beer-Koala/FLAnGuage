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
        return (TISCreateInputSourceList(nil, false).takeRetainedValue() as? [TISInputSource] ?? [])
            .map {
                $0.inputSource()
            }
            .filter {
                $0.id != "com.apple.PressAndHold"
            }
    }

    static var allLanguages: [InputSource] {
        return (TISCreateInputSourceList(nil, true).takeRetainedValue() as? [TISInputSource] ?? [])
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

//    var image: NSImage? {
//        switch self.language {
//        case "en": return NSImage(named: "usa")
//        case "uk": return NSImage(named: "ukraine")
//        default: return nil
//        }
//    }

    var flagName: String? {
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
        return  "\(self.flagName ?? "") \(self.name)"//
    }

}

extension TISInputSource {

    func inputSource() -> InputSource {
        return InputSource(inputSource: self)
    }
}
