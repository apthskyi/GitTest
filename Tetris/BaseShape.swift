//
//  BaseShape.swift
//  Tetris
//
//  Created by Liu, Trent on 5/25/16.
//  Copyright © 2016 Liu, Trent. All rights reserved.
//

import UIKit

class BaseShape: NSObject
{
    var movingPoints: [(line: Int, column: Int)];
    var loopDelegate: LoopDelegate?
    
    init(inout points: [[RectangleState]])
    {
        movingPoints = [(line: Int, column: Int)]();
    }
    
    func down(inout points: [[RectangleState]])
    {
        if !self.canDown(points)
        {
            self.freeze(&points)
            return;
        }
        for p in self.movingPoints
        {
            points[p.line][p.column] = .Empty
        }
        for i in 0 ... self.movingPoints.count - 1
        {
            let point = self.movingPoints[i];
            self.movingPoints[i] = (line: point.line + 1, column: point.column);
        }
        for p in self.movingPoints
        {
            points[p.line][p.column] = .Moving
        }
    }
    
    func canDown(points: [[RectangleState]]) -> Bool
    {
        for p in self.movingPoints
        {
            if p.line + 1 > points.count - 1
            {
                return false
            }
            else if points[p.line + 1][p.column] == .Valid
            {
                return false
            }
        }
        return true
    }
    
    func left(inout points: [[RectangleState]])
    {
        if !self.canLeft(points)
        {
            return
        }
        for p in self.movingPoints
        {
            points[p.line][p.column] = .Empty
        }
        for i in 0 ... self.movingPoints.count - 1
        {
            let point = self.movingPoints[i];
            self.movingPoints[i] = (line: point.line, column: point.column - 1);
        }
        for p in self.movingPoints
        {
            points[p.line][p.column] = .Moving
        }
    }
    
    func right(inout points: [[RectangleState]])
    {
        if !self.canRight(points)
        {
            return
        }
        for p in self.movingPoints
        {
            points[p.line][p.column] = .Empty
        }
        for i in 0 ... self.movingPoints.count - 1
        {
            let point = self.movingPoints[i];
            self.movingPoints[i] = (line: point.line, column: point.column + 1);
        }
        for p in self.movingPoints
        {
            points[p.line][p.column] = .Moving
        }
    }
    
    func rotate(inout points: [[RectangleState]]) {}
    
    func canRotate(points: [[RectangleState]]) -> Bool
    {
        return true
    }
    
    func canLeft(points: [[RectangleState]]) -> Bool
    {
        for p in self.movingPoints
        {
            if p.column - 1 < 0
            {
                return false
            }
            else if points[p.line][p.column - 1] == .Valid
            {
                return false
            }
        }
        return true
    }
    
    func canRight(points: [[RectangleState]]) -> Bool
    {
        for p in self.movingPoints
        {
            if p.column + 1 > ColumnsCount - 1
            {
                return false
            }
            else if points[p.line][p.column + 1] == .Valid
            {
                return false
            }
        }
        return true
    }
    
    func freeze(inout points: [[RectangleState]])
    {
        for p in self.movingPoints
        {
            points[p.line][p.column] = .Valid
            if p.line == 0
            {
                self.loopDelegate?.gameOver();
                return;
            }
        }
        var needRemoveLines = [Int]();
        for p in self.movingPoints
        {
            let line = points[p.line];
            if needRemoveLine(line) && !needRemoveLines.contains(p.line)
            {
                needRemoveLines.append(p.line);
            }
        }
        if needRemoveLines.count > 0
        {
            self.removeLine(needRemoveLines, points: &points);
        }
        self.loopDelegate?.generate();
    }
    
    func needRemoveLine(line: [RectangleState]) -> Bool
    {
        for state in line
        {
            if state != .Valid
            {
                return false;
            }
        }
        return true
    }
    
    func removeLine(lines: [Int], inout points: [[RectangleState]])
    {
        let sortedLines = lines.sort { (a, b) -> Bool in return a > b }
        var count = 0;
        for line in sortedLines
        {
            points.removeAtIndex(line);
            count += 1;
        }
        for _ in 0 ... count - 1
        {
            let newLine = [RectangleState](count: ColumnsCount, repeatedValue: .Empty);
            points.insert(newLine, atIndex: 0);
        }
    }
}
