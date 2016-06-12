//
//  TaggableField.swift
//  Taggable
//
//  Created by ATSUSHI on 2016/06/11.
//  Copyright © 2016年 ATSUSHI. All rights reserved.
//

import Foundation
import UIKit

class TaggableField: UITextField {

    func rawText() -> String {
        return super.text!
    }
    
    override func addGestureRecognizer(gestureRecognizer: UIGestureRecognizer) {
        gestureRecognizer.enabled = false
        super.addGestureRecognizer(gestureRecognizer)
    }

}
