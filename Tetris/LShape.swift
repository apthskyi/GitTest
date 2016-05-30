//
//  LShape.swift
//  Tetris
//
//  Created by Liu, Trent on 5/30/16.
//  Copyright © 2016 Liu, Trent. All rights reserved.
//

import UIKit

class LShape: BaseShape
{
    var currentState: Int
    override init(inout points: [[RectangleState]])
    {
        self.currentState = Int(arc4random_uniform(4));
        super.init(points: &points)
        switch currentState
        {
            case 0:
                self.movingPoints.append((0, 4));
                break;
            case 1:
                fallthrough
            case 2:
                self.movingPoints.append((1, 4));
                break;
            case 3:
                self.movingPoints.append((1, 5));
                break;
            default:
                break;
        }
        self.movingPoints.appendContentsOf(self.getOtherPoints(self.movingPoints[0], state: self.currentState))
        for p in self.movingPoints
        {
            points[p.line][p.column] = .Moving
        }
    }
    
    func getOtherPoints(centerPoints:(line: Int, column: Int), state: Int) -> [(line: Int, column: Int)]
    {
        var otherPoints = [(line: Int, column: Int)]()
        let c = centerPoints.column;
        let l = centerPoints.line;
        switch state
        {
            case 0:
                otherPoints.append((l, c + 1));
                otherPoints.append((l, c - 1));
                otherPoints.append((l + 1, c - 1));
                break;
            case 1:
                otherPoints.append((l + 1, c));
                otherPoints.append((l - 1, c));
                otherPoints.append((l + 1, c + 1));
                break;
            case 2:
                otherPoints.append((l, c + 1));
                otherPoints.append((l, c - 1));
                otherPoints.append((l - 1, c + 1));
                break;
            case 3:
                otherPoints.append((l + 1, c));
                otherPoints.append((l - 1, c));
                otherPoints.append((l - 1, c - 1));
                break;
            default:
                break;
        }
        return otherPoints;
    }
    
    override func rotate(inout points: [[RectangleState]])
    {
        if !self.canRotate(points)
        {
            return;
        }
        for p in self.movingPoints
        {
            points[p.line][p.column] = .Empty
        }
        self.currentState = self.getTargetState();
        let subRange =  1 ... 3;
        self.movingPoints.replaceRange(subRange, with: self.getOtherPoints(self.movingPoints[0], state: self.currentState));
        for p in self.movingPoints
        {
            points[p.line][p.column] = .Moving;
        }
    }
    
    override func canRotate(points: [[RectangleState]]) -> Bool
    {
        let targetState = self.getTargetState();
        let targetPoints = self.getOtherPoints(self.movingPoints[0], state: targetState);
        for p in targetPoints
        {
            if p.line < 0 ||
                p.column > ColumnsCount - 1 ||
                p.column < 0 ||
                p.line > LinesCount - 1
            {
                return false;
            }
            if points[p.line][p.column] != .Empty
            {
                return false;
            }
        }
        return true
    }
    
    func getTargetState() -> Int
    {
        if currentState == 3
        {
            return 0;
        }
        else
        {
            return currentState + 1;
        }
    }
}
