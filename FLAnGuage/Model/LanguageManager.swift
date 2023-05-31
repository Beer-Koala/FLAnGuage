//
//  LanguageManager.swift
//  FLAnGuage
//
//  Created by Beer Koala on 09.02.2023.
//

import InputMethodKit

struct LanguageManager {

    static let shared = LanguageManager()

    static let changeLanguageNotificationName = NSNotification.Name(rawValue: "SelectedKeyboardInputSourceChanged")

    private init() {

        let changeLanguageCallback: CFNotificationCallback = {(_, _, _, _, _) in
            NotificationCenter.default.post(name: LanguageManager.changeLanguageNotificationName, object: nil)
        }

        CFNotificationCenterAddObserver(
            CFNotificationCenterGetDistributedCenter(),
            nil,
            changeLanguageCallback,
            kTISNotifySelectedKeyboardInputSourceChanged,
            nil,
            .deliverImmediately
        )
    }

    var currentLanguage: InputSource {
        return TISCopyCurrentKeyboardInputSource().takeRetainedValue().inputSource()
    }

    var availableLanguages: [InputSource] {
        return (TISCreateInputSourceList(nil, false).takeRetainedValue() as? [TISInputSource] ?? [])
            .map {
                $0.inputSource()
            }
            .filter {
                $0.id != "com.apple.PressAndHold"
            }
    }

    var allLanguages: [InputSource] {
        return (TISCreateInputSourceList(nil, true).takeRetainedValue() as? [TISInputSource] ?? [])
            .map {
                $0.inputSource()
            }
    }

    func set(_ inputSource: InputSource) {
        TISSelectInputSource(inputSource.inputSource)
    }

    func change(title: String, for inputSource: InputSource) {
        UserDefaultStorage.inputSourceTitles[inputSource.language] = title
        NotificationCenter.default.post(Notification(name: LanguageManager.changeLanguageNotificationName))
    }

    func clearTitle(for inputSource: InputSource) {
        UserDefaultStorage.inputSourceTitles.removeValue(forKey: inputSource.language)
        NotificationCenter.default.post(Notification(name: LanguageManager.changeLanguageNotificationName))
    }
}
