//
//  MainView.swift
//  Tetris
//
//  Created by Liu, Trent on 5/25/16.
//  Copyright © 2016 Liu, Trent. All rights reserved.
//

import UIKit

class MainView: UIView
{
    var cellWidthHeight: CGFloat = 0.0
    var currentContext: CGContextRef?
    var image: UIImage?
    
    func ComputeAndDraw()
    {
        self.cellWidthHeight = self.frame.width / CGFloat(ColumnsCount)
        UIGraphicsBeginImageContext(self.bounds.size);
        self.currentContext = UIGraphicsGetCurrentContext();
        self.contextDrawRect(UIColor.whiteColor(), rect: self.bounds);
        
        CGContextBeginPath(currentContext);
        for i in 0 ... ColumnsCount
        {
            let x = CGFloat(i) * self.cellWidthHeight;
            CGContextMoveToPoint(currentContext, x, 0)
            CGContextAddLineToPoint(currentContext, x, self.bounds.size.height)
        }
        for i in 0 ... LinesCount
        {
            let y = CGFloat(i) * self.cellWidthHeight;
            CGContextMoveToPoint(currentContext, 0, y);
            CGContextAddLineToPoint(currentContext, self.bounds.size.width, y);
        }
        CGContextClosePath(currentContext);
        CGContextSetStrokeColorWithColor(currentContext, UIColor.blackColor().CGColor);
        CGContextSetLineWidth(currentContext, 1.0);
        CGContextStrokePath(currentContext);
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        self.setNeedsDisplay();
    }
    
    func drawWithPoints(points: [[RectangleState]])
    {
        for l in 0 ..< LinesCount
        {
            for c in 0 ..< ColumnsCount
            {
                let state = points[l][c];
                let rect = CGRectMake(
                    CGFloat(c) * cellWidthHeight + 1,
                    CGFloat(l) * cellWidthHeight + 1,
                    cellWidthHeight - 2,
                    cellWidthHeight - 2);
                self.contextDrawRect(UIColor.whiteColor(), rect: rect);
                switch state
                {
                    case .Empty:
                        self.contextDrawRect(UIColor.whiteColor(), rect: rect);
                    case .Valid:
                        self.contextDrawRect(UIColor.blackColor(), rect: rect);
                    case .Moving:
                        self.contextDrawRect(UIColor.darkGrayColor(), rect: rect);
                }
            }
        }
        image = UIGraphicsGetImageFromCurrentImageContext()
        self.setNeedsDisplay()
    }
    
    func contextDrawRect(color: UIColor, rect: CGRect)
    {
        CGContextSetFillColorWithColor(currentContext, color.CGColor);
        CGContextFillRect(currentContext, rect);
    }
    
    override func drawRect(rect: CGRect)
    {
        guard self.image != nil else
        {
            super.drawRect(rect);
            return;
        }
        image!.drawAtPoint(CGPointZero)
    }
}
