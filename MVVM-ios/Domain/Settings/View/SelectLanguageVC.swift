//
//  SelectLanguageVC.swift
//  MVVM-ios
//
//  Created by Hovhannes Stepanyan on 11/28/18.
//  Copyright © 2018 Matevos Ghazaryan. All rights reserved.
//

import UIKit

class SelectLanguageVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return LanguageManager.localizedIdentifiers().count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let name = LanguageManager.localizedIdentifiers()[indexPath.section]
        cell.textLabel?.text = name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        LanguageManager.setCurrent(indexPath.section)
        self.navigationController?.popViewController(animated: true)
    }
}
