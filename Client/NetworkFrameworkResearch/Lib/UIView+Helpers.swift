//
//  CGRect+Helpers.swift
//  NetworkFrameworkResearch
//
//  Created by Oleh Zayats on 11/10/18.
//  Copyright © 2018 Oleh Zayats. All rights reserved.
//

import UIKit

extension UIView {
    var centerPoint: CGPoint {
        return CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
    }
    
    var width: CGFloat {
        return bounds.size.width
    }
    
    var height: CGFloat {
        return bounds.size.height
    }
    
    var halfWidth: CGFloat {
        return bounds.size.width / 2.0
    }
    
    var halfHeight: CGFloat {
        return bounds.size.height / 2.0
    }
}
