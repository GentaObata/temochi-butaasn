//
//  PointLabel.swift
//  temochi-butasan
//
//  Created by tilda on 2021/05/02.
//

import SpriteKit

class PointLabel: SKLabelNode {
    
    init(point: Int) {
        super.init()
        self.text = String(point)
        self.fontName = "GeezaPro-Bold"
        self.fontSize = 60
        self.fontColor = UIColor(named: "grayFontColor")
        self.horizontalAlignmentMode = .right
        self.verticalAlignmentMode = .top
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
