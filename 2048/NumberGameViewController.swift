//
//  NumberGameViewController.swift
//  2048
//
//  Created by LuoLiu on 15/12/28.
//  Copyright © 2015年 fenrir_cd08. All rights reserved.
//

import UIKit

class NumberGameViewController: UIViewController, GameModelProtocol {

    // The number of tiles in every line/row
    var tileNumber: Int
    // The value of the winning tile
    var winningScore: Int
    
    var board: GameboardView?
    var model: GameModel?
    
    var scoreView: ScoreView?
    
    // How much padding to place between the tiles
    let thinPadding: CGFloat = 3.0
    let thickPadding: CGFloat = 6.0
    
    let viewPadding: CGFloat = 10.0
    let verticalViewOffset: CGFloat = 0.0
    
    init(tileNumber t: Int, winningScore w: Int) {
        tileNumber = t > 2 ? t : 2
        winningScore = w > 8 ? w : 8
        super.init(nibName: nil, bundle: nil)
        model = GameModel(tileNumber: tileNumber, winningScore: winningScore, delegate: self)
        view.backgroundColor = UIColor.whiteColor()
        setupSwipeControls()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    func setupSwipeControls() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: Selector("moveCommand:"))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = .Up
        view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("moveCommand:"))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = .Down
        view.addGestureRecognizer(downSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("moveCommand:"))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = .Left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("moveCommand:"))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = .Right
        view.addGestureRecognizer(rightSwipe)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGame()
    }
    
    func setupGame() {
        let vcHeight = view.bounds.size.height
        let vcWidth = view.bounds.size.width
        
        func xPositionToCenterView(v: UIView) -> CGFloat {
            let viewWidth = v.bounds.size.width
            let tentativeX = 0.5*(vcWidth - viewWidth)
            return tentativeX >= 0 ? tentativeX : 0
        }
        
        func yPositionForViewAtPosition(order: Int, views: [UIView]) -> CGFloat {
            assert(views.count > 0)
            assert(order >= 0 && order < views.count)
            
            let totalHeight = CGFloat(views.count - 1)*viewPadding + views.map({ $0.bounds.size.height }).reduce(verticalViewOffset, combine: { $0 + $1 })
            let viewsTop = 0.5*(vcHeight - totalHeight) >= 0 ? 0.5*(vcHeight - totalHeight) : 0
            
            var acc: CGFloat = 0
            for i in 0..<order {
                acc += viewPadding + views[i].bounds.size.height
            }
            return viewsTop + acc
        }
        
        let scoreView = ScoreView(backgroundColor: UIColor.blackColor(), textColor: UIColor.whiteColor(), font: UIFont.systemFontOfSize(24.0), radius: 6)
        scoreView.score = 0
        
        let boardWidth: CGFloat = view.bounds.size.width - 20*2
        let padding: CGFloat = tileNumber > 5 ? thinPadding : thickPadding
        let totalWidth = boardWidth - padding*(CGFloat(tileNumber + 1))
        let width = CGFloat(floorf(CFloat(totalWidth)))/CGFloat(tileNumber)
        let gameboard = GameboardView(tileNumber: tileNumber, tileWidth: width, tilePadding: padding, cornerRadius: 6, backgroundColor: UIColor.blackColor(), foregroundColor: UIColor.lightGrayColor())
        
        let views = [scoreView, gameboard]
        
        var frame = scoreView.frame
        frame.origin.x = xPositionToCenterView(scoreView)
        frame.origin.y = yPositionForViewAtPosition(0, views: views)
        scoreView.frame = frame
        
        frame = gameboard.frame
        frame.origin.x = xPositionToCenterView(gameboard)
        frame.origin.y = yPositionForViewAtPosition(1, views: views)
        gameboard.frame = frame
        
        view.addSubview(gameboard)
        board = gameboard
        view.addSubview(scoreView)
        self.scoreView = scoreView
        
        assert(model != nil)
        let m = model!
        m.insertTileAtRandomLocation(2)
        m.insertTileAtRandomLocation(2)
    }
    
    func reset() {
        assert(board != nil && model != nil)
        let b = board!
        let m = model!
        b.reset()
        m.reset()
        m.insertTileAtRandomLocation(2)
        m.insertTileAtRandomLocation(2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // GameModelProtocol
    func scoreChanged(score: Int) {
        if scoreView == nil {
            return
        }
        let s = scoreView!
        s.scoreChanged(newScore: score)
    }
    
    func moveOneTile(from: (Int, Int), to: (Int, Int), value: Int) {
        assert(board != nil)
        let b = board!
        b.moveOneTile(from, to: to, value: value)
    }
    
    func moveTwoTiles(from: ((Int, Int), (Int, Int)), to: (Int, Int), value: Int) {
        assert(board != nil)
        let b = board!
        b.moveTwoTiles(from, to: to, value: value)
    }

    func insertTile(location: (Int, Int), value: Int) {
        assert(board != nil)
        let b = board!
        b.insertTile(location, value: value)
    }
    
    // Move Commands
    func moveCommand(sender: UISwipeGestureRecognizer!) {
        assert(model != nil)
        
        var direction = MoveDirection.Up
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.Up:
            direction = MoveDirection.Up
        case UISwipeGestureRecognizerDirection.Down:
            direction = MoveDirection.Down
        case UISwipeGestureRecognizerDirection.Left:
            direction = MoveDirection.Left
        case UISwipeGestureRecognizerDirection.Right:
            direction = MoveDirection.Right
        default:
            break
        }
        
        let m = model!
        m.queueMove(direction, completion: { (changed: Bool) -> () in
            if changed {
                self.followUp()
            }
        })
    }
    
    func followUp() {
        assert(model != nil)
        let m = model!
        let (userWon, _) = m.userHasWon()
        if userWon {
            let alertView = UIAlertView()
            alertView.title = "Victory"
            alertView.message = "YOU WON!"
            alertView.addButtonWithTitle("OK")
            alertView.show()
            return
        }
        
        let randomVal = Int(arc4random()%10)
        m.insertTileAtRandomLocation(randomVal == 1 ? 4 : 2)
        
        if m.userHasLost() {
            let alertView = UIAlertView()
            alertView.title = "> <"
            alertView.message = "You lost..."
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
    }
}
