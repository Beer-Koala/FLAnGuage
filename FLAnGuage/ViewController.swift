//
//  ViewController.swift
//  FLAnGuage
//
//  Created by Beer Koala on 09.02.2023.
//

import Cocoa
import InputMethodKit

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

//class LanguageMenuController: NSObject, NSMenuDelegate {
//
//    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
//    let menu = NSMenu()
//    let flagImage = NSImage(named: "FlagIcon")
//    let currentLanguageIdentifier = NSLocale.preferredLanguages.first!
//
//    override init() {
//        super.init()
//        if let button = statusItem.button {
//            button.image = flagImage
//            button.action = #selector(LanguageMenuController.statusBarButtonClicked(sender:))
//        }
//
//        menu.delegate = self
//        statusItem.menu = menu
//        updateMenuItems()
//    }
//
//    func updateMenuItems() {
//        TISInputSource
//        menu.removeAllItems()
//        let availableLanguages = NSTextInputContext.allInputContexts.map { $0.selectedKeyboardInputSource?.localizedName }.compactMap { $0 }
//        for language in availableLanguages {
//            let menuItem = NSMenuItem(title: language, action: #selector(LanguageMenuController.menuItemSelected(sender:)), keyEquivalent: "")
//            menuItem.target = self
//            menu.addItem(menuItem)
//        }
//    }
//
//    @objc func statusBarButtonClicked(sender: NSStatusItem) {
//        updateMenuItems()
//        statusItem.popUpMenu(menu)
//    }
//
//    @objc func menuItemSelected(sender: NSMenuItem) {
//        NSTextInputContext.changeCurrentInputMethod(to: sender.title)
//    }
//
//    func menuWillOpen(_ menu: NSMenu) {
//        updateMenuItems()
//    }
//}

//import Cocoa
//import InputMethodKit

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
            TISSelectInputSource(selectedInputSource)
            if let button = statusItem.button {
                button.title = LanguageManager.name(for: selectedInputSource)
            }
        }
    }

    func menuWillOpen(_ menu: NSMenu) {
        updateMenuItems()
    }
}
