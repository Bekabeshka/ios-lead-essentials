//
//  UIView+Contrainer.swift
//  EssentialFeediOS
//
//  Created by bekabeshka on 02.01.2024.
//  Copyright © 2024 Essential Developer. All rights reserved.
//

import UIKit

extension UIView {
    public func makeContainer() -> UIView {
        let container = UIView()
        container.backgroundColor = .clear
        container.addSubview(self)

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: container.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            topAnchor.constraint(equalTo: container.topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        return container
    }
}
