//
//  SettingsViewController.swift
//  FLAnGuage
//
//  Created by Beer Koala on 09.02.2023.
//

import Cocoa

class SettingsViewController: NSViewController {

    @IBOutlet weak var inputSourceLanguages: NSScrollView?

}

extension SettingsViewController: NSTableViewDelegate {

}

extension SettingsViewController: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {
        LanguageManager.shared.allLanguages.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        let inputSource = LanguageManager.shared.allLanguages[row]

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
