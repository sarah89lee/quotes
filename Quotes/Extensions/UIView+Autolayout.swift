//
//  UIView+Autolayout.swift
//  quotes
//
//  Created by Sarah Lee on 4/11/18.
//  Copyright © 2018 Sarah Lee. All rights reserved.
//

import UIKit

extension UIView {
    
    func pinToAllSidesOfParent() {
        guard let superview = self.superview else {
            return
        }
        
        let top = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutAttribute.top,
            relatedBy: NSLayoutRelation.equal,
            toItem: superview,
            attribute: NSLayoutAttribute.top,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let bottom = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutAttribute.bottom,
            relatedBy: NSLayoutRelation.equal,
            toItem: superview,
            attribute: NSLayoutAttribute.bottom,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let left = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutAttribute.left,
            relatedBy: NSLayoutRelation.equal,
            toItem: superview,
            attribute: NSLayoutAttribute.left,
            multiplier: 1.0,
            constant: 0.0
        )
        
        let right = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutAttribute.right,
            relatedBy: NSLayoutRelation.equal,
            toItem: superview,
            attribute: NSLayoutAttribute.right,
            multiplier: 1.0,
            constant: 0.0
        )
        superview.addConstraint(top)
        superview.addConstraint(bottom)
        superview.addConstraint(left)
        superview.addConstraint(right)
    }
    
    func pin(attribute: NSLayoutAttribute, toView: UIView, withAttribute: NSLayoutAttribute, constant: CGFloat) {
        guard let superview = self.superview else {
            return
        }
        
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: attribute,
            relatedBy: NSLayoutRelation.equal,
            toItem: toView,
            attribute: withAttribute,
            multiplier: 1.0,
            constant: constant
        )
        
        superview.addConstraint(constraint)
    }
    
    func addHeightConstraint(height: CGFloat) {
        guard let superview = self.superview else {
            return
        }
        
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: nil,
            attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1.0,
            constant: height
        )
        
        superview.addConstraint(constraint)
    }
    
    func addWidthConstraint(width: CGFloat) {
        guard let superview = self.superview else {
            return
        }
        
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutAttribute.width,
            relatedBy: NSLayoutRelation.equal,
            toItem: nil,
            attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1.0,
            constant: width
        )
        
        superview.addConstraint(constraint)
    }
    
    func alignAxisToSuperview(axis: NSLayoutAttribute) {
        guard let superview = self.superview else {
            return
        }
        
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: axis,
            relatedBy: NSLayoutRelation.equal,
            toItem: superview,
            attribute: axis,
            multiplier: 1.0,
            constant: 0
        )
        
        superview.addConstraint(constraint)
    }
}
