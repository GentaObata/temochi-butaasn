//
//  ResultView.swift
//  temochi-butasan
//
//  Created by tilda on 2021/05/05.
//

import UIKit

class ResultView: UIView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var targetPointLabel: UILabel!
    @IBOutlet private weak var playTimeLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        let nib = UINib(nibName: "ResultView", bundle: nil)
        guard let customView = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        customView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        customView.layer.cornerRadius = 10
        self.layer.cornerRadius = 10
        
    }
    
    private func calculationPlayTime(startDate: Date, finishDate: Date) -> String {
        let diff = Int(finishDate.timeIntervalSince(startDate))
        let hour = diff / 3600
        let minute = (diff / 60) % 60
        let seconds = diff % 60
        return String(format:"%d時間%d分%d秒", hour, minute, seconds)
    }
    
    func updateLabel(stage: Stage) {
        self.titleLabel.text = "ステージ\(stage.stageNumber)クリア！"
        self.targetPointLabel.text = String(stage.targetCount)
        if let startDate = stage.startDate, let finishDate = stage.finishDate {
            self.playTimeLabel.text = calculationPlayTime(startDate: startDate, finishDate: finishDate)
        } else {
            self.playTimeLabel.text = "計測不能"
        }
    }

}
