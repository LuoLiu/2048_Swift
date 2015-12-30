//
//  ViewController.swift
//  2048
//
//  Created by LuoLiu on 15/12/28.
//  Copyright © 2015年 fenrir_cd08. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startGameTapped(sender: AnyObject) {
        let game = NumberGameViewController(tileNumber: 4, winningScore: 2048)
        self.presentViewController(game, animated: true, completion: nil)
    }

}

