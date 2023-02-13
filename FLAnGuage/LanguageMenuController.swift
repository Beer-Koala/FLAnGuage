//
//  LanguageMenuController.swift
//  FLAnGuage
//
//  Created by Beer Koala on 13.02.2023.
//

import Cocoa

class LanguageMenuController: NSObject, NSMenuDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let menu = NSMenu()
    let flagImageUSA = NSImage(named: "usa")
    let flagImageUkraine = NSImage(named: "ukraine")
    let currentLanguageIdentifier = NSLocale.preferredLanguages.first!

    override init() {
        super.init()

        self.updateCurrentInputSource()
        menu.delegate = self
        statusItem.menu = menu
        updateMenuItems()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(inputSourceChanged),
            name: LanguageManager.changeLanguageNotificationName,
            object: nil)

        CFNotificationCenterAddObserver(
            CFNotificationCenterGetDistributedCenter(),
            nil,
            { (_, _, _, _, _) in
                NotificationCenter.default.post(name: LanguageManager.changeLanguageNotificationName, object: nil)
            },
            LanguageManager.changeLanguageNotificationName as CFString,
            nil,
            .deliverImmediately
        )
    }

    @objc func inputSourceChanged() {
        self.updateCurrentInputSource()
    }

    func updateCurrentInputSource() {
        if let button = statusItem.button {
            //button.image = flagImage

            let currentInputSource = LanguageManager.currentLanguage

            button.title = LanguageManager.name(for: currentInputSource)
            button.action = #selector(LanguageMenuController.statusBarButtonClicked(sender:))
        }
    }

    func updateMenuItems() {
        menu.removeAllItems()
        let availableLanguages = LanguageManager.availableLanguages
        for inputSource in availableLanguages {
            let inputSourceName = LanguageManager.id(for: inputSource)//name

            let menuItem = NSMenuItem(
                title: inputSourceName,
                action: #selector(LanguageMenuController.menuItemSelected(sender:)),
                keyEquivalent: ""
            )
            menuItem.target = self
            menu.addItem(menuItem)
        }
    }

    @objc func statusBarButtonClicked(sender: NSStatusItem) {
        updateMenuItems()
        statusItem.button?.performClick(nil)
    }

    @objc func menuItemSelected(sender: NSMenuItem) {
        if let selectedInputSource = LanguageManager.availableLanguages.first(where: {
            LanguageManager.name(for: $0) == sender.title
        }) {
            LanguageManager.set(selectedInputSource)
            if let button = statusItem.button {
                button.title = LanguageManager.name(for: selectedInputSource)
            }
        }
    }

    func menuWillOpen(_ menu: NSMenu) {
        updateMenuItems()
    }
}
