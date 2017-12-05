//
//  Touchy.swift
//  Touchy
//
//  Created by Paweł Dudek on 09/05/2017.
//  Copyright © 2017 Pawel Dudek. All rights reserved.
//

internal extension UIView {

    func specFindElement<T>(eval: ((T) -> Bool)) -> T? {
        for itemCandidate in allSubviews() {
            if let item = itemCandidate as? T {
                if eval(item) {
                    return item
                }
            }
        }

        return nil
    }

    func allSubviews() -> [UIView] {
        var allSubviews: [UIView] = []
        allSubviews.append(contentsOf: subviews)
        
        for subview in subviews {
            allSubviews.append(contentsOf: subview.allSubviews())
        }
        
        return allSubviews
    }
}
