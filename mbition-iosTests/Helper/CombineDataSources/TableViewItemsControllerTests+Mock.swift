//
//  TableViewItemsControllerTests+Mock.swift
//  mbition-iosTests
//
//  Created by Pronin Oleksandr on 14.12.22.
//

import XCTest
import UIKit
@testable import mbition_ios

struct Model: Hashable {
    var text: String
}

let dataSet1 = [
    Model(text: "test1"), Model(text: "test2"), Model(text: "test3")
]

let dataSet2 = [
    Section(header: "section header", items: [Model(text: "test model")], footer: "section footer")
]

// Provide fallback data source
class TestDataSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fatalError()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "test header"
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "test footer"
    }
}
