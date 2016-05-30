//
//  ViewController.swift
//  Tetris
//
//  Created by Liu, Trent on 5/25/16.
//  Copyright © 2016 Liu, Trent. All rights reserved.
//

import UIKit

enum RectangleState: Int
{
    case Empty
    case Valid
    case Moving
}

enum TetrisShape: Int
{
    case O = 0
    case L = 1
    case J = 2
    case I = 3
    case T = 4
    case S = 5
    case Z = 6
}

let ColumnsCount = 10
let LinesCount = 20
var Speed = 1.0;

protocol LoopDelegate
{
    func generate()
    func gameOver()
}

class ViewController: UIViewController, LoopDelegate
{
    var pointsArray : [[RectangleState]]?
    @IBOutlet weak var mainView: MainView!
    var timer: NSTimer?
    var currentShape: BaseShape?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.refreshPointsArray();
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated);
        self.mainView.ComputeAndDraw();
    }
    
    func refreshPointsArray()
    {
        self.pointsArray = [[RectangleState]]();
        for _ in 0 ..< LinesCount
        {
            let line = [RectangleState](count: ColumnsCount, repeatedValue: .Empty)
            self.pointsArray!.append(line);
        }
    }
    
    @IBAction func startTapped(sender: AnyObject)
    {
        self.generate();
    }
    
    func generate()
    {
        if timer != nil
        {
            timer!.invalidate();
            timer = nil;
        }
        self.currentShape = ShapeFactory.createShape(&self.pointsArray!);
        self.currentShape?.loopDelegate = self;
        self.mainView.drawWithPoints(self.pointsArray!);
        timer = NSTimer.scheduledTimerWithTimeInterval(Speed, target: self, selector: #selector(self.down(_:)), userInfo: nil, repeats: true);
    }
    
    func gameOver()
    {
        if timer != nil
        {
            timer!.invalidate();
            timer = nil;
        }
        self.currentShape = nil;
        self.refreshPointsArray();
        self.mainView.drawWithPoints(self.pointsArray!);
    }
    
    @IBAction func rotate(sender: AnyObject)
    {
        self.currentShape?.rotate(&self.pointsArray!)
        self.mainView.drawWithPoints(self.pointsArray!);
    }
    
    @IBAction func down(sender: AnyObject)
    {
        self.currentShape?.down(&self.pointsArray!);
        self.mainView.drawWithPoints(self.pointsArray!);
    }
    
    @IBAction func left(sender: AnyObject)
    {
        self.currentShape?.left(&self.pointsArray!);
        self.mainView.drawWithPoints(self.pointsArray!);
    }
    
    @IBAction func right(sender: AnyObject)
    {
        self.currentShape?.right(&self.pointsArray!);
        self.mainView.drawWithPoints(self.pointsArray!);
    }
}

