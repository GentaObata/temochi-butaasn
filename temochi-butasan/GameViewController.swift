//
//  GameViewController.swift
//  temochi-butasan
//
//  Created by tilda on 2021/04/25.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    private var scene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .resizeFill
                self.scene = scene as? GameScene
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        // sageAeraはこのタイミングからしか取得できないため、ここでGameSceneのnodeの位置を調整する
        self.scene.ajustNodePositionBySafeArea(edgeInsets: self.view!.safeAreaInsets)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
