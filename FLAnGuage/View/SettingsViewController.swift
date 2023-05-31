//
//  SettingsViewController.swift
//  FLAnGuage
//
//  Created by Beer Koala on 09.02.2023.
//

import Cocoa

class SettingsViewController: NSViewController {

    var inputSources: [InputSource] = []

    @IBOutlet weak var inputSourceLanguages: NSTableView?

    @IBAction func clickDefaultValueButton(_ sender: NSButton) {
        if let row = self.inputSourceLanguages?.row(for: sender) {
            let inputSource = inputSources[row]
            LanguageManager.shared.clearTitle(for: inputSource)

            if let tableView = self.inputSourceLanguages,
               let column = tableView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier("Title")),
               let columnIndex = tableView.tableColumns.firstIndex(of: column),
               let cellView = tableView.view(
                   atColumn: columnIndex,
                   row: row,
                   makeIfNecessary: false
               ) as? NSTableCellView {
                cellView.textField?.stringValue = inputSource.statusBarName
            }
        }
    }

    @IBAction func titleChangedAction(_ sender: NSTextField) {
        if let row = self.inputSourceLanguages?.row(for: sender) {
            let inputSource = inputSources[row]
            LanguageManager.shared.change(title: sender.stringValue, for: inputSource)
        }
    }

    override func viewWillAppear() {
        self.inputSources = LanguageManager.shared.availableLanguages
        self.inputSourceLanguages?.reloadData()
    }
}

extension SettingsViewController: NSTableViewDelegate {

    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {

        if let column = tableView.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier("Title")),
           let columnIndex = tableView.tableColumns.firstIndex(of: column),
           let cellView = tableView.view(atColumn: columnIndex, row: row, makeIfNecessary: false) as? NSTableCellView {
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
            cell.textField?.stringValue = inputSource.localizedName
        } else if (tableColumn?.identifier)!.rawValue == "Title" {
            cell.textField?.stringValue = inputSource.statusBarName
        }

        return cell
    }
}
