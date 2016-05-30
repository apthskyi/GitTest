//
//  ZShape.swift
//  Tetris
//
//  Created by Liu, Trent on 5/26/16.
//  Copyright © 2016 Liu, Trent. All rights reserved.
//

import UIKit

class ZShape: BaseShape
{
    var currentState: Int;
    override init(inout points: [[RectangleState]])
    {
        self.currentState = Int(arc4random_uniform(2));
        super.init(points: &points);
        switch self.currentState
        {
            case 0:
                self.movingPoints.append((0, 3));
                self.movingPoints.append((0, 4));
                self.movingPoints.append((1, 4));
                self.movingPoints.append((1, 5));
            default:
                self.movingPoints.append((0, 5));
                self.movingPoints.append((1, 5));
                self.movingPoints.append((1, 4));
                self.movingPoints.append((2, 4));
        }
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
        let point_3 = self.movingPoints[2];
        if currentState == 0
        {
            currentState = 1
            self.movingPoints[0] = (point_3.line - 1, point_3.column + 1);
            self.movingPoints[1] = (point_3.line, point_3.column + 1);
            self.movingPoints[3] = (point_3.line + 1, point_3.column);
        }
        else
        {
            currentState = 0
            self.movingPoints[0] = (point_3.line - 1, point_3.column - 1);
            self.movingPoints[1] = (point_3.line - 1, point_3.column);
            self.movingPoints[3] = (point_3.line, point_3.column + 1);
        }
        for p in self.movingPoints
        {
            points[p.line][p.column] = .Moving;
        }
    }
    
    override func canRotate(points: [[RectangleState]]) -> Bool
    {
        let point_3 = self.movingPoints[2];
        if currentState == 0
        {
            if point_3.line - 1 < 0 || point_3.line + 1 > LinesCount - 1
            {
                return false;
            }
            else if points[point_3.line - 1][point_3.column + 1] != .Empty ||
                    points[point_3.line + 1][point_3.column] != .Empty
            
            {
                return false
            }
        }
        else
        {
            if point_3.column - 1 < 0
            {
                return false;
            }
            else if points[point_3.line - 1][point_3.column] != .Empty ||
                points[point_3.line - 1][point_3.column - 1] != .Empty
                
            {
                return false
            }
        }
        return true;
    }
}
