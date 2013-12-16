//
//  IntroScene.m
//  Glimmer
//
//  Created by Gavin Potts on 12/5/13.
//  Copyright (c) 2013 Gavin Potts. All rights reserved.
//

#import "IntroScene.h"
#import "sprites.h"
#import "MyScene.h"
#import "SKButton.h"

@implementation IntroScene
{
    SKLabelNode *backButton;
    SKLabelNode *aboutButton;
}
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        SKSpriteNode *sky;
        
        if  ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) &&
             ([UIScreen mainScreen].bounds.size.height > 480.0f)) {
            sky =
            [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"start-568h"]];
        } else {
            sky =
            [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"start"]];
        }
        
        sky.position = CGPointMake(size.width/2, size.height/2);
        [self addChild:sky];
        
        
        SKLabelNode *nudgeLabel = [SKLabelNode labelNodeWithFontNamed:@"Dosis-Regular"];
        nudgeLabel.text = @"Nudge";
        nudgeLabel.fontColor = [UIColor whiteColor];
        nudgeLabel.fontSize = 20;
        nudgeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        nudgeLabel.position = CGPointMake(self.size.width/2, 150.0);
        
        [self addChild:nudgeLabel];
        
        SKAction *up = [SKAction moveToY:160 duration:1.25];
        SKAction *down = [SKAction moveToY:150.0 duration:.25];
        SKAction *bounce = [SKAction sequence:@[up, down]];
        SKAction *repeatBounce = [SKAction repeatActionForever:bounce];
        [nudgeLabel runAction:repeatBounce];

        backButton = [SKLabelNode labelNodeWithFontNamed:@"Dosis-Regular"];
        backButton.text = @"STORE";
        backButton.fontColor = [UIColor whiteColor];
        backButton.fontSize = 20;
        backButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        backButton.position = CGPointMake(40, self.size.height - 40);
        
        [self addChild:backButton];
        
        aboutButton = [SKLabelNode labelNodeWithFontNamed:@"Dosis-Regular"];
        aboutButton.text = @"?";
        aboutButton.fontColor = [UIColor whiteColor];
        aboutButton.fontSize = 20;
        aboutButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        aboutButton.position = CGPointMake(self.size.width - 40, self.size.height - 40);
        
        [self addChild:aboutButton];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        // Get the user's touch location
        CGPoint location = [touch locationInNode:self];
        
        // If the user taps on BACK Button Rectangle
        if (CGRectContainsPoint(backButton.frame, location))
        {
            UIViewController *vc = self.view.window.rootViewController;
            [vc performSegueWithIdentifier:@"ShowStore" sender:nil];
            
        } else if(CGRectContainsPoint(aboutButton.frame, location)){
            UIViewController *vc = self.view.window.rootViewController;
            [vc performSegueWithIdentifier:@"ShowAidArcade" sender:nil];
        } else {
            
            // 1
            MyScene * myScene = [[MyScene alloc] initWithSize:self.size];
            // 2
            SKTransition *reveal =
            [SKTransition fadeWithDuration:2.0];
            //3
            [self.view presentScene:myScene transition:reveal];
        }
    }
}

@end
