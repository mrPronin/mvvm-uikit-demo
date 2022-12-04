//
//  UserList+Cell.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import UIKit

extension UserList {
    class Cell: UITableViewCell {
        // MARK: - Public
        class var identifier: String { return String.className(self) }
        
        func configure(with model: UserList.Model) {
            userLoginId.text = model.login
        }
        
        // ignore the default handling
        override open func setSelected(_ selected: Bool, animated: Bool) {}
        
        // MARK: - Init
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupOnLoad()
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // MARK: - Private
        let userLoginId = UILabel().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textColor = UIColor.UserList.textColor
            $0.font = .systemFont(ofSize: 17)
        }
    }
}

// MARK: - Private
extension UserList.Cell {
    private func setupOnLoad() {
        contentView.backgroundColor = .background
        
        // userLoginId
        userLoginId.add(into: contentView)
            .leading(16)
            .trailing(16)
            .top(11)
            .bottom(11)
            .done()
    }
}
