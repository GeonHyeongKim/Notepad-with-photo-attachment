//
//  ExtUIView.swift
//  Notepad
//
//  Created by gunhyeong on 2020/02/20.
//  Copyright © 2020 geonhyeong. All rights reserved.
//

import UIKit

extension UIView {

    func takeScreenshot() -> UIImage {

        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
    
    func addConstraintsFitParentView(_ selectedView: UIView) {
        selectedView.translatesAutoresizingMaskIntoConstraints = false

        let views = ["subview" : selectedView]
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[subview]|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                metrics: nil,
                views: views
            )
        )
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[subview]|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                metrics: nil,
                views: views
            )
        )
    }
}
