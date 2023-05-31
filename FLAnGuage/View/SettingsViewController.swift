//
//  SettingsViewController.swift
//  FLAnGuage
//
//  Created by Beer Koala on 09.02.2023.
//

import Cocoa

class SettingsViewController: NSViewController {

    let inputSources: [InputSource] = LanguageManager.shared.availableLanguages

    @IBOutlet weak var inputSourceLanguages: NSScrollView?

    @IBAction func clickDefaultValueButton(_ sender: NSButton) {
        // here need to set default value of input source title
    }
    @IBAction func titleChangedAction(_ sender: NSTextField) {
        // here need to save new value of input source title
    }
}

extension SettingsViewController: NSTableViewDelegate {

    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        if let cellView = tableView.view(atColumn: 1, row: row, makeIfNecessary: false) as? NSTableCellView {
            // change the text of the text field as you wish
            cellView.textField?.becomeFirstResponder()
        }

        return true
    }
}

extension SettingsViewController: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        self.inputSources.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        let inputSource = self.inputSources[row]

        guard let cell = tableView.makeView(
            withIdentifier: tableColumn!.identifier,
            owner: self
        ) as? NSTableCellView else { return nil }

        if (tableColumn?.identifier)!.rawValue == "InputSource" {
            cell.textField?.stringValue = inputSource.name
        } else if (tableColumn?.identifier)!.rawValue == "Title" {
            cell.textField?.stringValue = inputSource.statusBarName
        }

        return cell
    }
}
