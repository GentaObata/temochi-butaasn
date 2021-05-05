//
//  FinishView.swift
//  temochi-butasan
//
//  Created by tilda on 2021/05/04.
//

import UIKit

class FinishView: UIView {
    
    let baseSize = UIScreen.main.bounds.size
    
    private var finishImage: UIImageView!
    private var resultView: ResultView!
    private var nextButton: UIButton!
    
    weak var delegate: FinishViewDelegate?

    init() {
        self.resultView = ResultView(frame: CGRect(x: 0, y: 0, width: baseSize.width / 1.2, height: 300))
        self.nextButton = UIButton()
        
        super.init(frame: UIScreen.main.bounds)
        
        self.addSubview(self.resultView)
        self.addSubview(self.nextButton)
        
        self.resultView.center = self.center
        
        self.nextButton.backgroundColor = UIColor(named: "primaryColor")
        self.nextButton.layer.cornerRadius = 32
        self.nextButton.layer.borderWidth = 0
        self.nextButton.setTitle("次のステージに進む", for: .normal)
        self.nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .black)
        self.nextButton.setTitleColor(.white, for: .normal)
        self.nextButton.addTarget(self, action: #selector(self.handleTappedNextButtton), for: .touchUpInside)
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextButton.widthAnchor.constraint(equalTo: self.resultView.widthAnchor).isActive = true
        self.nextButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        self.nextButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -64).isActive = true
        self.nextButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func finishShow(finishStage: Stage) {
        let finishImage = UIImageView(image: UIImage(named: "finish")?.resizeImage(width: baseSize.width / 4))
        finishImage.center = self.center
        finishImage.alpha = 0
        addSubview(finishImage)
        self.resultView.isHidden = true
        self.nextButton.isHidden = true
        UIView.animate(withDuration: 1.0, delay: 0.0 ,usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, animations: {
            finishImage.bounds.size.height += 150
            finishImage.bounds.size.width += 150
            finishImage.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.0, delay: 2.0, animations: {
                finishImage.removeFromSuperview()
                self.resultShow(finishStage: finishStage)
            })
        })
    }
    
    func resultShow(finishStage: Stage) {
        self.resultView.updateLabel(stage: finishStage)
        self.resultView.isHidden = false
        self.nextButton.isHidden = false
    }
    
    @objc private func handleTappedNextButtton() {
        self.delegate?.didTappdNextButton()
    }
}

protocol FinishViewDelegate: class {
    func didTappdNextButton()
}
