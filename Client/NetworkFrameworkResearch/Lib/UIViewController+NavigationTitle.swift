//
//  UIViewController+NavigationTitle.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/10/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

extension UIViewController {
    func setupNavigationTitle(_ title: String) {
        let titleView = makeNavigationTitleLabel(with: title)
        navigationItem.titleView = titleView
    }
    private func makeNavigationTitleLabel(with title: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        label.text = title
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        label.textAlignment = .center
        return label
    }
}
