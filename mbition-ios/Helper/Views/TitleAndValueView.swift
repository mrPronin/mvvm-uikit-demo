//
//  TitleAndValueView.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 07.12.22.
//

import UIKit

class TitleAndValueView: UIView {
    // MARK: - UI
    let contentStackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    let title = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = UIColor.UserList.headerTitle
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
    }
    
    let value = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 14, weight: .thin)
        $0.textColor = UIColor.UserList.textColor
        $0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 0
    }
    
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        
        layer.cornerRadius = 8
        clipsToBounds = true

        contentStackView.add(into: self)
            .leading(8)
            .trailing(8)
            .top(8)
            .bottom(8)
            .done()
        
        contentStackView.addArrangedSubview(self.title)
        contentStackView.addArrangedSubview(self.value)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
