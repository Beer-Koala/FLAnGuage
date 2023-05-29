//
//  LanguageMenuController.swift
//  FLAnGuage
//
//  Created by Beer Koala on 13.02.2023.
//

import Cocoa
import AppKit
import InputMethodKit

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

        // Void pointer to `self`:
        let observer = UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque())

        let changeLanguageCallback: CFNotificationCallback = { (_, observer, _, _, _) in
            if let observer = observer {
                // Extract pointer to `self` from void pointer:
                let mySelf = Unmanaged<LanguageMenuController>.fromOpaque(observer).takeUnretainedValue()
                // Call instance method:
                mySelf.inputSourceChanged()
            }
        }

        CFNotificationCenterAddObserver(
            CFNotificationCenterGetDistributedCenter(),
            observer,
            changeLanguageCallback,
            kTISNotifySelectedKeyboardInputSourceChanged,
            nil,
            .deliverImmediately
        )
    }

    func inputSourceChanged() {
        self.updateCurrentInputSource()
    }

    func updateCurrentInputSource() {
        if let button = statusItem.button {
            let currentInputSource = LanguageManager.currentLanguage
            //            button.image = currentInputSource.image
            //            button.imageScaling = .scaleProportionallyUpOrDown
            button.title = currentInputSource.statusBarName
        }
    }

    func updateMenuItemTitle() {
        self.menu.removeAllItems()
        let availableLanguages = LanguageManager.availableLanguages
        for inputSource in availableLanguages {
            let inputSourceName = inputSource.menuName

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
