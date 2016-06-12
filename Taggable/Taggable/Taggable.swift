//
//  Taggable.swift
//  Taggable
//
//  Created by ATSUSHI on 2016/06/11.
//  Copyright © 2016年 ATSUSHI. All rights reserved.
//

import Foundation
import UIKit

class Taggable: UIView {
    
    @IBOutlet var label: UILabel!
    var removeHandler = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func remove(sender: UIButton) {
        self.removeHandler()
    }
}