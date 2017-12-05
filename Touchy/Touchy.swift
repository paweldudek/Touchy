//
//  Touchy.swift
//  Touchy
//
//  Created by Paweł Dudek on 09/05/2017.
//  Copyright © 2017 Pawel Dudek. All rights reserved.
//

import Foundation
import UIKit

public protocol TextInsertable: class {
    
    var text: String? { get set }
}

public protocol Titleable: class {
    
    var title: String? { get }
}

public protocol Placeholderable: class {
    
    var placeholder: String? { get }
}

public protocol Tappable: class {
    
    func specSimulateTap(with event: UIControlEvents)
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
    
    func specTapElement(with title: String) {
        guard let titleable: (Titleable & Tappable) = specFindElement(eval: {
            return $0.title == title
        }) else {
            return
        }
        
        titleable.specSimulateTap()
    }
}

extension UIButton: Titleable {
    
    public var title: String? {
        return titleLabel?.text
    }
}

extension UITextField: Placeholderable, TextInsertable {
    
    
}

extension UIControl: Tappable {

    public func specSimulateTap(with event: UIControlEvents) {
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
    
    public func specSimulateTap(with event: UIControlEvents) {
        guard let target = target, let action = action else {
            return
        }
        
        _ = target.perform(action, with: self)
    }
}
