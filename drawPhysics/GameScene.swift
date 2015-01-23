//
//  GameScene.swift
//  drawPhysics
//
//  Created by wangbo on 1/23/15.
//  Copyright (c) 2015 wangbo. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    // currentPath keeps current drew path, currentDrawing keeps current shape
    var currentPath = CGPathCreateMutable()
    var currentDrawing = SKShapeNode()
    let lineWidth : CGFloat = 4
    
    override func didMoveToView(view: SKView) {
        setupScene()
        setupGlobals()
        setupGestureRecognizers()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func setupScene(){
        self.backgroundColor = UIColor.whiteColor()
        self.physicsWorld.gravity = CGVectorMake(0, -9.8)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
    }
    func setupGlobals(){
        currentDrawing.strokeColor = UIColor.blackColor()
        currentDrawing.lineWidth = lineWidth
    }
    func setupGestureRecognizers(){
        //detects when a user is dragging their finger around the screen, corresponding action is below
        self.view?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: Selector("handlePan:")))
    }
    func handlePan(panReco:UIPanGestureRecognizer){
        // current location point
        let touchLoc = self.convertPointFromView(panReco.locationInView(panReco.view))
        
        if panReco.state == UIGestureRecognizerState.Began{
            CGPathMoveToPoint(currentPath, nil, touchLoc.x, touchLoc.y)
        }
        else if panReco.state == UIGestureRecognizerState.Changed{
            CGPathAddLineToPoint(currentPath, nil, touchLoc.x, touchLoc.y)
            adjustDrawing()
        }
        else if panReco.state == UIGestureRecognizerState.Ended{
            CGPathAddLineToPoint(currentPath, nil, touchLoc.x, touchLoc.y)
            CGPathCloseSubpath(currentPath)
            addObject()
            
            // build next new path
            currentDrawing.removeFromParent()
            currentPath = CGPathCreateMutable()
        }
    }
    func adjustDrawing(){
        currentDrawing.removeFromParent()
        currentDrawing.path = currentPath
        self.addChild(currentDrawing)
    }
    func addObject(){
        let shapeNode = SKShapeNode(path: currentPath)
       // shapeNode.strokeColor = getRandomColor()
       // shapeNode.fillColor = getRandomColor()
        shapeNode.lineWidth = lineWidth
        self.addChild(shapeNode)
        // change from shapenode to spritenode
        let spriteNode = SKSpriteNode(texture: self.view?.textureFromNode(shapeNode), size: shapeNode.frame.size)
        shapeNode.removeFromParent()
        spriteNode.position = CGPoint(x: shapeNode.frame.width/2, y: shapeNode.frame.height/2)
        spriteNode.physicsBody = SKPhysicsBody(texture: spriteNode.texture, alphaThreshold: 0.99, size: spriteNode.size)
        self.addChild(spriteNode)
    }
    
    
}
