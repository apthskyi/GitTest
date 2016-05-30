//
//  ShapeFactory.swift
//  Tetris
//
//  Created by Liu, Trent on 5/26/16.
//  Copyright © 2016 Liu, Trent. All rights reserved.
//

import UIKit

class ShapeFactory: NSObject
{
    static func createShape(inout points: [[RectangleState]]) -> BaseShape
    {
        let shape = TetrisShape(rawValue: Int(arc4random()) % 7);
        switch shape!
        {
        case .O:
            return OShape(points: &points);
        case .L:
            return LShape(points: &points);
        case .J:
            return JShape(points: &points);
        case .I:
            return IShape(points: &points);
        case .T:
            return TShape(points: &points);
        case .S:
            return SShape(points: &points);
        case .Z:
            return ZShape(points: &points);
        }
    }
}
