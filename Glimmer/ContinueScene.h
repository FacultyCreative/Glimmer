//
//  ContinueScene.h
//  Glimmer
//
//  Created by Gavin Potts on 1/3/14.
//  Copyright (c) 2014 Gavin Potts. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKRoundedButton.h"
#import "GameOverScene.h"
#import "MyScene.h"
#import "KeychainItemWrapper.h"
#import "GSKeychain.h"

@interface ContinueScene : SKScene
{
    SKRoundedButton *store;
    SKRoundedButton *useContinue;
    SKRoundedButton *gameover;
    SKLabelNode *pillCount;
    SKLabelNode *timeLbl;
    NSTimer *timer;
}
-(void)updateCounter:(NSTimer *)theTimer;
-(void)countdownTimer;
@property int continues;
@property (strong, nonatomic) MyScene *gameScene;
@end
