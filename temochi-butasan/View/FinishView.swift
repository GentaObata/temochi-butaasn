//
//  FinishView.swift
//  temochi-butasan
//
//  Created by tilda on 2021/05/04.
//

import UIKit

class FinishView: UIView {
    
    private var finishImage: UIImageView!

    init() {
        self.finishImage = UIImageView(image: UIImage(named: "sokomade")?.resizeImage(width: UIScreen.main.bounds.size.width / 4))
        self.finishImage.alpha = 0
        
        super.init(frame: UIScreen.main.bounds)
        
        self.finishImage.center = self.center
        self.addSubview(self.finishImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        UIView.animate(withDuration: 1.0, delay: 0.0 ,usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, animations: {
            self.finishImage.bounds.size.height += 150
            self.finishImage.bounds.size.width += 150
            self.finishImage.alpha = 1
        }, completion: { _ in
        })
    }
}
