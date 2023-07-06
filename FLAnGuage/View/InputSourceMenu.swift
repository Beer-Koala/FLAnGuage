//
//  LanguageMenuController.swift
//  FLAnGuage
//
//  Created by Beer Koala on 13.02.2023.
//

import Cocoa
import AppKit

class InputSourceMenu: NSObject {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = NSMenu()
    let currentLanguageIdentifier = NSLocale.preferredLanguages.first!

    var statusBarItem: NSStatusItem!
        var statusBarMenu: NSMenu!

    private lazy var appSettingsWindowController: NSWindowController? = {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateController(withIdentifier: "SettingsWindowController") as? NSWindowController
    }()

    override init() {
        super.init()

        self.updateCurrentInputSource()
        statusItem.button?.target = self
        statusItem.button?.action = #selector(self.statusBarButtonClicked(sender:))
        statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(inputSourceChanged),
            name: LanguageManager.changeLanguageNotificationName,
            object: nil)
    }

    @objc func inputSourceChanged() {
        self.updateCurrentInputSource()
    }

    func updateCurrentInputSource() {
        if let button = statusItem.button {
            let currentInputSource = LanguageManager.shared.currentLanguage
            //            button.image = currentInputSource.image
            //            button.imageScaling = .scaleProportionallyUpOrDown
            button.title = currentInputSource.statusBarName
        }
    }

    func updateMenuItems() {
        self.menu.removeAllItems()
        let availableLanguages = LanguageManager.shared.availableLanguages
        for inputSource in availableLanguages {
            let inputSourceName = inputSource.menuName

            let menuItem = NSMenuItem(
                title: inputSourceName,
                action: #selector(InputSourceMenu.menuItemSelected(sender:)),
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
        let appSettingsMenuItem = NSMenuItem(title: "Open App Settings...",
                                      action: #selector(InputSourceMenu.appSettings(sender:)),
                                      keyEquivalent: "")
        appSettingsMenuItem.target = self
        self.menu.addItem(appSettingsMenuItem)

        self.menu.addItem(NSMenuItem.separator())
        let keyboardSettingsMenuItem = NSMenuItem(title: "Open Keyborad Settings...",
                                      action: #selector(InputSourceMenu.keyboardSettings(sender:)),
                                      keyEquivalent: "")
        keyboardSettingsMenuItem.target = self
        self.menu.addItem(keyboardSettingsMenuItem)
    }

    func addQuit() {
        self.menu.addItem(NSMenuItem.separator())
        let quitMenuItem = NSMenuItem(title: "Quit",
                                      action: #selector(InputSourceMenu.quitApp(sender:)),
                                      keyEquivalent: "")
        quitMenuItem.target = self
        self.menu.addItem(quitMenuItem)
    }

    @objc func statusBarButtonClicked(sender: NSStatusItem) {
        self.updateMenuItems()
        statusItem.menu = self.menu
        self.statusItem.button?.performClick(nil)
        statusItem.menu = nil
    }

    @objc func menuItemSelected(sender: NSMenuItem) {

        if let selectedInputSource = sender.representedObject as? InputSource {
            LanguageManager.shared.set(selectedInputSource)
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

    @objc func appSettings(sender: NSStatusItem) {
        self.appSettingsWindowController?.showWindow(self)
        NSApp.activate(ignoringOtherApps: true)
    }

}
