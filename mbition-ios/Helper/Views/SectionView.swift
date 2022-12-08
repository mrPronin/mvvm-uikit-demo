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
    }
    
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        
        backgroundColor = .background
        
        backgroundView.layer.cornerRadius = 8
        backgroundView.clipsToBounds = true
        backgroundView.add(into: self)
            .leading()
            .trailing()
            .top(8)
            .bottom(8)
            .done()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
