//
//  Touchy.swift
//  Touchy
//
//  Created by Paweł Dudek on 09/05/2017.
//  Copyright © 2017 Pawel Dudek. All rights reserved.
//

import Foundation
import UIKit

public protocol TextInsertable: AnyObject {

    var text: String? { get set }
}

public protocol Accessible {

    var accessibilityLabel: String? { get set }
}

public protocol Titleable: AnyObject {

    var title: String? { get }
}

public protocol Placeholderable: AnyObject {

    var placeholder: String? { get }
}

public protocol Tappable: AnyObject {

    func specSimulateTap(with event: UIControl.Event)
}

public extension Tappable {

    func specSimulateTap() {
        specSimulateTap(with: .touchUpInside)
    }
}

public extension UIView {

    func specEnter(text: String, intoElementWith placeholder: String) {
        guard let placeholderable: (Placeholderable & TextInsertable) = specFindElement(eval: {
            $0.placeholder == placeholder
        }) else {
            return
        }

        placeholderable.text = text
    }

    func specTapElement(with title: String, event: UIControl.Event = .touchUpInside) {
        guard let titleable: (Titleable & Tappable) = specFindElement(eval: {
            return $0.title == title
        }) else {
            return
        }

        titleable.specSimulateTap(with: event)
    }

    func specTapAccessibilityElement(with label: String, event: UIControl.Event = .touchUpInside) {
        guard let accessible: (Accessible & Tappable) = specFindElement(eval: {
            return $0.accessibilityLabel == label
        }) else {
            return
        }

        accessible.specSimulateTap(with: event)
    }

    func specEnter(text: String, intoAccessibilityElementWith accessibilityLabel: String) {
        guard let placeholderable: (Accessible & TextInsertable) = specFindElement(eval: {
            $0.accessibilityLabel == accessibilityLabel
        }) else {
            return
        }

        placeholderable.text = text
    }

    func specTapTableViewCell(with title: String) {
        guard let view: UITableView = specFindElement(eval: { _ in
            return true
        }) else {
            return
        }

        guard let cell: UITableViewCell = specFindElement(
            eval: { $0.textLabel?.text == title },
            in: view.visibleCells
        ) else {
            return
        }

        if let indexPath = view.indexPath(for: cell) {
            view.delegate?.tableView!(view, didSelectRowAt: indexPath)
        }
    }

    func specTapCollectionViewCell(with title: String) {
        guard let view: UICollectionView = specFindElement() else {
            return
        }

        guard let cell: UICollectionViewCell & Titleable = specFindElement(
            eval: { $0.title == title },
            in: view.visibleCells
        ) else {
            return
        }

        if let indexPath = view.indexPath(for: cell) {
            view.delegate?.collectionView!(view, didSelectItemAt: indexPath)
        }
    }
}

extension UIButton: Titleable {

    public var title: String? {
        var possibleTitles = [currentTitle, titleLabel?.text]
        if #available(iOS 15.0, *) {
            possibleTitles.append(configuration?.title)
        }
        return possibleTitles.compactMap { $0 }.first
    }
}

extension UITextField: Placeholderable, TextInsertable {

}

extension UIControl: Tappable {

    public func specSimulateTap(with event: UIControl.Event) {
        guard isEnabled else {
            return
        }
        let objectTargets = allTargets.map({ $0 as NSObject })

        for target in objectTargets {
            let obtainedActions = actions(forTarget: target, forControlEvent: event) ?? []

            for action in obtainedActions {
                let selector = NSSelectorFromString(action)
                target.perform(selector, with: self)
            }
        }
    }
}

extension UIBarButtonItem: Tappable {

    public func specSimulateTap(with event: UIControl.Event) {
        guard let target = target, let action = action else {
            return
        }

        _ = target.perform(action, with: self)
    }
}

extension UIView: Accessible {

}
