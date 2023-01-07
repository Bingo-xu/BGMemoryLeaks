//
//  BGLeaksSwiftVC.swift
//  BGMemoryLeaks_Example
//
//  Created by Bingo on 2022/12/13.
//  Copyright © 2022 bingoxu. All rights reserved.
//

import UIKit

typealias methodCompletionBlock = ()->Void

class BGLeaksSwiftVC: UIViewController {
    
    var didClickBlock:methodCompletionBlock?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.didClickBlock = {
            self.navigationController?.popViewController(animated: true)
        }
        view.backgroundColor = UIColor.white
        let btn = UIButton(frame: CGRect(x: 20, y: 100, width: 50, height: 50))
        btn.backgroundColor = UIColor.yellow
        btn.addTarget(self, action: #selector(backAction), for: UIControlEvents.touchUpInside)
        self.view.addSubview(btn)
    }
    
    @objc func backAction() {
        guard let didClickBlock = self.didClickBlock else { return}
        didClickBlock();
    }

}
