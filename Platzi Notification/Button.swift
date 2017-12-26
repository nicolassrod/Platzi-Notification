//
//  Button.swift
//  Platzi Notification
//
//  Created by Nicolás Rodríguez on 22/12/17.
//  Copyright © 2017 Nicolás Rodríguez. All rights reserved.
//

import UIKit

@IBDesignable
class Button: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = cornerRadius > 0
        }
    }
}
