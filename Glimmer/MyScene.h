//
//  MyScene.h
//  Glimmer
//

//  Copyright (c) 2013 Gavin Potts. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene
@property (nonatomic) NSInteger publicHearts;
-(void)unpause;
-(void)pause;
-(void)togglePause;
@end
