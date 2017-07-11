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
    
    func specSimulateTap()
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
            $0.title == title
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

    public func specSimulateTap() {
        print("\(allTargets)")
        
        let firstTarget = allTargets.first! as NSObject
        
        let obtainedActions = actions(forTarget: firstTarget, forControlEvent: .touchUpInside)
        print("\(String(describing: obtainedActions))")
        
        sendActions(for: .touchUpInside)
    }
}

extension UIBarButtonItem: Tappable {
    
    public func specSimulateTap() {
        guard let target = target, let action = action else {
            return
        }
        
        _ = target.perform(action, with: self)
    }
}
