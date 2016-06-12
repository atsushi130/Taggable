//
//  ViewController.swift
//  Taggable
//
//  Created by ATSUSHI on 2016/06/11.
//  Copyright © 2016年 ATSUSHI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var taggableView: TaggableView!
    var taggables = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        self.taggableView = TaggableView(frame: CGRectMake(5.0, 270.0, self.view.frame.width, self.view.frame.height - 270.0), delegate: self, dataSource: self)
        self.taggableView.taggableField.placeholder = "new tag"
        self.taggableView.reloadData()
        self.taggableView.taggableField.becomeFirstResponder()
        
        self.view.addSubview(self.taggableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning( )
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: TaggableViewDelegate {
    
    func taggableMarginInTAggableView(tagableView: TaggableView) -> CGFloat {
        return 5
    }
    
    func taggableView(taggableView: TaggableView, didReturnWithText text: String) {
        self.taggables.append(text)
        self.taggableView.reloadData()
    }
    
    func taggableView(taggableView: TaggableView, didRemoveTaggableAtIndex index: Int) {
        self.taggables.removeAtIndex(index)
        self.taggableView.reloadData()
    }
   
    func taggableViewShouldEndEditing(taggableView: TaggableView) -> Bool {
        return false
    }
}

private let NibNamed = "Taggable"

extension ViewController: TaggableViewDataSource {
    
    func numberOfTaggableInTaggableView(taggableView: TaggableView) -> Int {
        return self.taggables.count
    }
    
    func taggableView(taggableView: TaggableView, taggableForRowAtIndex indexPath: NSIndexPath) -> Taggable {
        let taggable = NSBundle.mainBundle().loadNibNamed(NibNamed, owner: self, options: nil)[0] as! Taggable
        
        taggable.label.text    = self.taggables[indexPath.row]
        taggable.removeHandler = {
            if let index = self.taggableView.indexIfTaggableView(taggable) {
                self.taggables.removeAtIndex(index)
                self.taggableView.reloadData()
            }
        }
        
        return taggable
    }
}

