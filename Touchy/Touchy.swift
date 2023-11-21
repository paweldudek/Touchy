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

    func specChangeTextFieldValue(with textFieldAccessibilityIdentifier: String, to text: String) {
        let textField: UITextField? = specFindElement { view in
            return view.accessibilityIdentifier == textFieldAccessibilityIdentifier
        }
        textField?.text = text
        textField?.specSimulateTap(with: .editingChanged)
    }

    func specTapButton(with title: String, inCollectionViewCellWithTitle cellTitle: String) {
        let cell: (UICollectionViewCell & Titleable)? = specFindElement { view in
            return view.title == cellTitle
        }
        cell?.specTapElement(with: title)
    }

    func specTapTextViewLink(titled linkTitle: String) {
        let textView: UITextView? = specFindElement { view in
            return view.text?.contains(linkTitle) ?? false
        }

        if let textView = textView,
            let text = textView.text,
            let linkValue = textView.attributedText.attribute(
                .link, at: NSString(string: text).range(of: linkTitle).lowerBound, effectiveRange: nil
            ) as? String,
            let url = URL(string: linkValue) {
            let linkRange = NSString(string: text).range(of: linkTitle)
            _ = textView.delegate?.textView?(
                textView,
                shouldInteractWith: url,
                in: linkRange,
                interaction: .invokeDefaultAction
            )
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
        enumerateEventHandlers { action, tuple, enumerationEvent, b in
            action?.specTriggerAction()
            if let tuple = tuple, let target = tuple.0 as? NSObject, enumerationEvent.contains(event) {
                target.perform(tuple.1, with: self)
            }
        }
    }
}

extension UIBarButtonItem: Tappable {
    public func specSimulateTap(with event: UIControl.Event) {
        guard let target = target, let action = action else {
            if let control = customView as? UIControl {
                control.specSimulateTap(with: event)
                
            }
            return
        }

        _ = target.perform(action, with: self)
    }
}

extension UIView: Accessible {

}

extension UIAction {
    func specTriggerAction() {
        let performWithSender = NSSelectorFromString("_performActionWithSender:")
        let performWithTarget = NSSelectorFromString("_performWithTarget:")
        if responds(to: performWithSender) {
            perform(performWithSender, with: self)
        } else if responds(to: performWithTarget) {
            perform(performWithTarget, with: self)
        }
    }
}
