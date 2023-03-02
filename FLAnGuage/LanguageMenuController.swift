//
//  LanguageMenuController.swift
//  FLAnGuage
//
//  Created by Beer Koala on 13.02.2023.
//

import Cocoa
import AppKit

class LanguageMenuController: NSObject, NSMenuDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = NSMenu()
    let currentLanguageIdentifier = NSLocale.preferredLanguages.first!

    override init() {
        super.init()

        self.updateCurrentInputSource()
        self.menu.delegate = self
        statusItem.menu = self.menu
        statusItem.button?.action = #selector(LanguageMenuController.statusBarButtonClicked(sender:))
        self.updateMenuItemTitle()

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
            let currentInputSource = LanguageManager.currentLanguage
            //            button.image = currentInputSource.image
            //            button.imageScaling = .scaleProportionallyUpOrDown
            button.title = currentInputSource.shortName
        }
    }

    func updateMenuItemTitle() {
        self.menu.removeAllItems()
        let availableLanguages = LanguageManager.availableLanguages
        for inputSource in availableLanguages {
            let inputSourceName = inputSource.name

            let menuItem = NSMenuItem(
                title: inputSourceName,
                action: #selector(LanguageMenuController.menuItemSelected(sender:)),
                keyEquivalent: ""
            )
            menuItem.target = self
            menuItem.representedObject = inputSource
            self.menu.addItem(menuItem)
        }

        self.addPreferences()
        self.addQuit()
    }

    func addPreferences() {
        self.menu.addItem(NSMenuItem.separator())
        let quitMenuItem = NSMenuItem(title: "Open Keyborad Settings...",
                                      action: #selector(LanguageMenuController.keyboardSettings(sender:)),
                                      keyEquivalent: "")
        quitMenuItem.target = self
        self.menu.addItem(quitMenuItem)
    }

    func addQuit() {
        self.menu.addItem(NSMenuItem.separator())
        let quitMenuItem = NSMenuItem(title: "Quit",
                                      action: #selector(LanguageMenuController.quitApp(sender:)),
                                      keyEquivalent: "")
        quitMenuItem.target = self
        self.menu.addItem(quitMenuItem)
    }

    @objc func statusBarButtonClicked(sender: NSStatusItem) {
        self.updateMenuItemTitle()
        self.statusItem.button?.performClick(nil)
    }

    @objc func menuItemSelected(sender: NSMenuItem) {

        if let selectedInputSource = sender.representedObject as? InputSource {
            LanguageManager.set(selectedInputSource)
            self.updateCurrentInputSource()
        }
    }

    @objc func quitApp(sender: NSStatusItem) {
        NSApplication.shared.terminate(sender)
    }

    @objc func keyboardSettings(sender: NSStatusItem) {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.keyboard") {
            NSWorkspace.shared.open(url)
        }
    }

}
