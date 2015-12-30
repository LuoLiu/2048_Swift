//
//  OtherModels.swift
//  2048
//
//  Created by LuoLiu on 15/12/28.
//  Copyright © 2015年 fenrir_cd08. All rights reserved.
//

import UIKit

enum MoveDirection {
    case Up, Down, Left, Right
}

struct MoveCommand {
    let direction: MoveDirection
    let completion: (Bool) -> ()
}

enum MoveOrder {
    case SingleMoveOrder(soure: Int, destination: Int, value: Int, wasMerge: Bool)
    case DoubleMoveOrder(firstSource: Int, secondSource: Int, destination: Int, value: Int)
}

enum TileObject {
    case Empty
    case Tile(Int)
}

enum ActionToken {
    case NoAction(source: Int, value: Int)
    case Move(source: Int, value: Int)
    case SingleCombine(source: Int, value: Int)
    case DoubleCombine(source: Int, second: Int, value: Int)
    
    func getValue() -> Int {
        switch self {
        case let .NoAction(_, v): return v
        case let .Move(_, v): return v
        case let .SingleCombine(_, v): return v
        case let .DoubleCombine(_, _, v): return v
        }
    }
    
    func getSource() -> Int {
        switch self {
        case let .NoAction(s, _): return s
        case let .Move(s, _): return s
        case let .SingleCombine(s, _): return s
        case let .DoubleCombine(s, _, _): return s
        }
    }
}

struct SquareGameboard<T> {
    let tileNumber: Int
    var boardArray: [T]
    
    init(tileNumber t: Int, initialValue: T) {
        tileNumber = t
        boardArray = [T](count: t*t, repeatedValue: initialValue)
    }
    
    subscript(row: Int, col: Int) -> T {
        get {
            assert(row >= 0 && row < tileNumber)
            assert(col >= 0 && col < tileNumber)
            return boardArray[row*tileNumber + col]
        }
        set {
            assert(row >= 0 && row < tileNumber)
            assert(col >= 0 && col < tileNumber)
            boardArray[row*tileNumber + col] = newValue
        }
    }
    
    mutating func setAll(item: T) {
        for i in 0..<tileNumber {
            for j in 0..<tileNumber {
                self[i, j] = item
            }
        }
    }
}
