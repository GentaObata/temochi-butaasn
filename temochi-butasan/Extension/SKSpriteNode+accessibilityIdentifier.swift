//
//  SKSpriteNode+accessibilityIdentifier.swift
//  temochi-butasan
//
//  Created by tilda on 2021/04/29.
//

import UIKit
import SpriteKit

extension SKSpriteNode: UIAccessibilityIdentification {
    public var accessibilityIdentifier: String? {
        get {
            super.accessibilityLabel
        }
        set(accessibilityIdentifier) {
            super.accessibilityLabel = accessibilityIdentifier
        }
    }
}
