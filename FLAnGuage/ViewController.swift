//
//  ViewController.swift
//  FLAnGuage
//
//  Created by Beer Koala on 09.02.2023.
//

import Cocoa

class ViewController: NSViewController {

    var languageMenu: LanguageMenuController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.languageMenu = LanguageMenuController()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

class LanguageMenuController: NSObject, NSMenuDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let menu = NSMenu()
    let flagImageUSA = NSImage(named: "usa")
    let flagImageUkraine = NSImage(named: "ukraine")
    let currentLanguageIdentifier = NSLocale.preferredLanguages.first!

    override init() {
        super.init()
        if let button = statusItem.button {
            //button.image = flagImage

            let currentInputSource = LanguageManager.currentLanguage

            button.title = LanguageManager.name(for: currentInputSource)
            button.action = #selector(LanguageMenuController.statusBarButtonClicked(sender:))
        }

        menu.delegate = self
        statusItem.menu = menu
        updateMenuItems()
    }

    func updateMenuItems() {
        menu.removeAllItems()
        let availableLanguages = LanguageManager.availableLanguages
        for inputSource in availableLanguages {
            let inputSourceName = LanguageManager.name(for: inputSource)

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
