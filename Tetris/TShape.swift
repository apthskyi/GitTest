//
//  TShape.swift
//  Tetris
//
//  Created by Liu, Trent on 5/27/16.
//  Copyright © 2016 Liu, Trent. All rights reserved.
//

import UIKit

class TShape: BaseShape
{
    var currentState: Int
    
    override init(inout points: [[RectangleState]])
    {
        self.currentState = Int(arc4random_uniform(4));
        super.init(points: &points);
        if currentState == 0
        {
            self.movingPoints.append((0, 4));
        }
        else
        {
            self.movingPoints.append((1, 4));
        }
        self.movingPoints.appendContentsOf((self.getOtherPoints(self.movingPoints[0])));
        for p in self.movingPoints
        {
            points[p.line][p.column] = .Moving
        }
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
        switch currentState
        {
            case 0:
                currentState = 1
            case 1:
                currentState = 2
            case 2:
                currentState = 3
            case 3:
                currentState = 0
            default:
                break;
        }
        let subRange =  1 ... 3;
        self.movingPoints.replaceRange(subRange, with: self.getOtherPoints(self.movingPoints[0]));
        for p in self.movingPoints
        {
            points[p.line][p.column] = .Moving;
        }
    }
    
    override func canRotate(points: [[RectangleState]]) -> Bool
    {
        switch currentState
        {
            case 0:
                if self.movingPoints[0].line - 1 < 0
                {
                    return false;
                }
                break;
            case 1:
                if self.movingPoints[0].column - 1 < 0
                {
                    return false;
                }
                break;
            case 2:
                if self.movingPoints[0].line + 1 > LinesCount - 1
                {
                    return false;
                }
                break;
            case 3:
                if self.movingPoints[0].column + 1 > ColumnsCount - 1
                {
                    return false;
                }
                break;
            default:
                break;
        }
        return true
    }
    
    func getOtherPoints(centerPoints:(line: Int, column: Int)) -> [(line: Int, column: Int)]
    {
        var otherPoints = [(line: Int, column: Int)]()
        let x = centerPoints.column;
        let y = centerPoints.line;
        switch currentState
        {
            case 0:
                otherPoints.append((y, x + 1));
                otherPoints.append((y, x - 1));
                otherPoints.append((y + 1, x));
                break;
            case 1:
                otherPoints.append((y + 1, x));
                otherPoints.append((y - 1, x));
                otherPoints.append((y, x + 1));
                break;
            case 2:
                otherPoints.append((y, x + 1));
                otherPoints.append((y, x - 1));
                otherPoints.append((y - 1, x));
                break;
            case 3:
                otherPoints.append((y + 1, x));
                otherPoints.append((y - 1, x));
                otherPoints.append((y, x - 1));
                break;
            default:
                break;
        }
        return otherPoints;
    }
}
