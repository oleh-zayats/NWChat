//
//  StoryboardLoadable.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/10/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

protocol StoryboardLoadable: NSObjectProtocol {
    associatedtype ViewController
    static var storyboardName: String { get }
    static func load() -> ViewController
}

extension StoryboardLoadable where Self: UIViewController {
    static var storyboardName: String {
        return String(describing: self)
    }
    static func loadFromSB() -> Self {
        let bundle: Bundle = .main
        let isLoadable = bundle.path(forResource: storyboardName, ofType: "storyboardc") != nil
        assert(isLoadable, "Can't load storyboard")
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        return storyboard.instantiateInitialViewController() as! Self
    }
}

extension UIViewController: StoryboardLoadable {}
