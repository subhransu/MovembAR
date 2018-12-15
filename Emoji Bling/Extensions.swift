//
//  Extensions.swift
//  MovembAR
//
//  Created by nitin muthyala on 15/12/18.
//  Copyright © 2018 Subhransu Behera. All rights reserved.
//

import UIKit

extension UIView {
    
    func addBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
}
