//
//  TaggableView.swift
//  Taggable
//
//  Created by ATSUSHI on 2016/06/11.
//  Copyright © 2016年 ATSUSHI. All rights reserved.
//

import Foundation
import UIKit

private let TaggableHeight: CGFloat       = 30.0
private let TaggableHeightMargin: CGFloat = 5.0
private let TaggableWidthMargin: CGFloat  = 2.5
private let TaggableFieldHeight: CGFloat  = TaggableHeight
private let TaggableMaxWidth: CGFloat     = 170.0
private let Empty = "\u{200B}"

protocol TaggableViewDelegate {
    func taggableMarginInTAggableView(tagableView: TaggableView) -> CGFloat
    func taggableFieldDidBeginEditing(taggableView: TaggableView)
    func taggableViewShouldEndEditing(taggableView: TaggableView) -> Bool
    func taggableViewDidEndEditing(taggableView: TaggableView) -> Bool
    func taggableView(taggableView: TaggableView, didRemoveTaggableAtIndex index: Int)
    func taggableView(taggableView: TaggableView, didTextChanged text: String)
    func taggableView(taggableView: TaggableView, didReturnWithText text: String)
}

extension TaggableViewDelegate {
    func taggableViewDidEndEditing(taggableView: TaggableView) -> Bool { return true }
    func taggableFieldDidBeginEditing(taggableView: TaggableView) { }
    func taggableView(taggableView: TaggableView, didTextChanged text: String) { }
}

protocol TaggableViewDataSource {
    func numberOfTaggableInTaggableView(taggableView: TaggableView) -> Int
    func taggableView(taggableView: TaggableView, taggableForRowAtIndex indexPath: NSIndexPath) -> Taggable
}

class TaggableView: UIControl {
    
    var taggableField = TaggableField()
    var taggableViews = [UIView]()
    var dataSource: TaggableViewDataSource! = nil
    var delegate: TaggableViewDelegate!     = nil
    var tempTextFieldText = "\u{200B}"
    
    init(frame: CGRect, delegate: TaggableViewDelegate, dataSource: TaggableViewDataSource) {
        super.init(frame: frame)
        self.delegate   = delegate
        self.dataSource = dataSource
        
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.clipsToBounds = true
        self.addTarget(self, action: #selector(TaggableView.focusOnTaggableField), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.taggableField.borderStyle     = UITextBorderStyle.None
        self.taggableField.backgroundColor = UIColor.clearColor()
        self.taggableField.delegate        = self
        self.taggableField.addTarget(self, action: #selector(TaggableView.textFieldDidChange(_:)), forControlEvents: UIControlEvents.AllEditingEvents)
        
        self.reloadData()
    }
    
    func focusOnTaggableField() -> Bool {
        self.taggableField.becomeFirstResponder()
        return true
    }

    func reloadData() {
        
        self.taggableViews.forEach({
            $0.removeFromSuperview()
        })
        
        self.taggableViews = [TaggableField]()
        let count          = self.dataSource.numberOfTaggableInTaggableView(self)

        if count != 0 {
            var origin = CGPointZero
            [Int](0...count-1).forEach({
                let taggable = self.dataSource.taggableView(self, taggableForRowAtIndex: NSIndexPath(forRow: $0, inSection: 0))
                let size     = taggable.label.sizeThatFits(CGSizeMake(1000, TaggableHeight))
                if origin.x + taggable.frame.width > UIScreen.mainScreen().bounds.size.width {
                    origin.x = 0.0
                    origin.y += TaggableHeight + TaggableHeightMargin
                }
                
                let width      = min(TaggableMaxWidth, size.width + 37)
                taggable.frame = CGRectMake(origin.x, origin.y, width, TaggableHeight)
                origin.x += taggable.frame.width + TaggableWidthMargin
                taggable.autoresizingMask = UIViewAutoresizing.None
                
                self.addSubview(taggable)
                self.taggableViews.append(taggable)
            })
        }
        
        self.taggableViews.append(self.taggableField)
        self.taggableField.frame = CGRectMake(0.0, 0.0, UIScreen.mainScreen().bounds.size.width, TaggableFieldHeight)
        
        if self.taggableViews.count - 1 > 0 {
            let taggable = self.taggableViews[count-1]
            let x        = taggable.frame.origin.x + taggable.frame.width + TaggableWidthMargin
            let taggableFieldWidth = UIScreen.mainScreen().bounds.size.width - x
            
            if x < UIScreen.mainScreen().bounds.size.width {
                self.taggableField.frame = CGRectMake(x, taggable.frame.origin.y, taggableFieldWidth, TaggableFieldHeight)
            } else {
                let height = TaggableHeight + TaggableHeightMargin
                self.taggableField.frame = CGRectMake(0.0, taggable.frame.origin.y + height, taggableFieldWidth, TaggableFieldHeight)
            }
        }
        
        self.addSubview(self.taggableField)
        self.invalidateIntrinsicContentSize()
        self.taggableField.text = Empty
    }
    
    func numberOfTaggable() -> Int {
        return self.taggableViews.count - 1
    }
    
    func indexIfTaggableView(view: UIView) -> Int? {
        var index: Int? = nil
        self.taggableViews.filter({ (element: UIView) -> Bool in
            return element is Taggable ? true : false
        }).enumerate().forEach({
            if $0.element == view {
                index = $0.index
                return
            }
        })
        
        return index
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.invalidateIntrinsicContentSize()
    }

}

extension TaggableView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.tempTextFieldText = textField.text!
        self.delegate.taggableFieldDidBeginEditing(self)
    }

    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return self.delegate.taggableViewShouldEndEditing(self)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.delegate.taggableViewDidEndEditing(self)
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldDidChange(taggableField: UITextField) {
        
        if self.taggableField.text! == "" {
            if self.taggableViews.count - 2 >= 0 {
                let removeIndex = self.taggableViews.count - 2
                self.taggableViews[removeIndex].removeFromSuperview()
                self.taggableViews.removeAtIndex(removeIndex)
                self.taggableField.text = Empty
                self.delegate.taggableView(self, didRemoveTaggableAtIndex: removeIndex)
            }
        }
       
        self.invalidateIntrinsicContentSize()
        self.delegate.taggableView(self, didTextChanged: self.taggableField.text!)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.delegate.taggableView(self, didReturnWithText: self.taggableField.text!)
        return true
    }

}