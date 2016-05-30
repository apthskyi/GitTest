//
//  OShape.swift
//  Tetris
//
//  Created by Liu, Trent on 5/26/16.
//  Copyright © 2016 Liu, Trent. All rights reserved.
//

import UIKit

class OShape: BaseShape
{
    override init(inout points: [[RectangleState]])
    {
        super.init(points: &points);
        self.movingPoints.append((0, 4));
        self.movingPoints.append((1, 4));
        self.movingPoints.append((0, 5));
        self.movingPoints.append((1, 5));
        for p in self.movingPoints
        {
            points[p.line][p.column] = .Moving
        }
    }
}
