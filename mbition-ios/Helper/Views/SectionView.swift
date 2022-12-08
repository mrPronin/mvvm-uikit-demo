//
//  SectionView.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 08.12.22.
//

import UIKit

class SectionView: UIView {
    // MARK: - UI
    let backgroundView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    let contentStackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 0
    }

    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        
        backgroundColor = .background
        
        backgroundView.add(into: self)
            .leading()
            .trailing()
            .top(8)
            .bottom(8)
            .done()
        
        contentStackView.add(into: backgroundView)
            .leading(8)
            .trailing(8)
            .top(8)
            .bottom(8)
            .done()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
