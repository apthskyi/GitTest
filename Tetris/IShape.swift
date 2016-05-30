//
//  IShape.swift
//  Tetris
//
//  Created by Liu, Trent on 5/25/16.
//  Copyright © 2016 Liu, Trent. All rights reserved.
//

import UIKit

class IShape: BaseShape
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
                self.movingPoints.append((0, 5));
                self.movingPoints.append((0, 6));
            default:
                self.movingPoints.append((0, ColumnsCount/2 - 1));
                self.movingPoints.append((1, ColumnsCount/2 - 1));
                self.movingPoints.append((2, ColumnsCount/2 - 1));
                self.movingPoints.append((3, ColumnsCount/2 - 1));
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
        let point_2 = self.movingPoints[1];
        if currentState == 0
        {
            for i in 0 ..< self.movingPoints.count
            {
                self.movingPoints[i] = (point_2.line - 1 + i, point_2.column);
                let p = self.movingPoints[i];
                points[p.line][p.column] = .Moving
            }
            currentState = 1
        }
        else
        {
            for i in 0 ..< self.movingPoints.count
            {
                self.movingPoints[i] = (point_2.line, point_2.column - 1 + i);
                let p = self.movingPoints[i];
                points[p.line][p.column] = .Moving
            }
            currentState = 0
        }
    }
    
    override func canRotate(points: [[RectangleState]]) -> Bool
    {
        let point_2 = self.movingPoints[1];
        if currentState == 0
        {
            if point_2.line - 1 < 0 || point_2.line + 2 > LinesCount - 1
            {
                return false;
            }
            else if points[point_2.line - 1][point_2.column] != .Empty ||
                    points[point_2.line + 1][point_2.column] != .Empty ||
                    points[point_2.line + 2][point_2.column] != .Empty
            {
                return false
            }
        }
        else
        {
            if point_2.column - 1 < 0 || point_2.column + 2 > ColumnsCount - 1
            {
                return false;
            }
            else if points[point_2.line][point_2.column - 1] != .Empty ||
                    points[point_2.line][point_2.column + 1] != .Empty ||
                    points[point_2.line][point_2.column + 2] != .Empty
            {
                return false
            }
        }
        return true;
    }
}
