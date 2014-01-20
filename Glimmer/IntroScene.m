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
#import "SKRoundedRectangle.h"
#import "SKRoundedButton.h"


@implementation IntroScene
{
    SKRoundedButton *backButton;
    SKRoundedButton *aboutButton;
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
        
        SKNode *nudge = [[SKNode alloc] init];
        nudge.position = CGPointMake(self.size.width/2, 150.0);
        [self addChild: nudge];
        
        SKLabelNode *nudgeLabel = [SKLabelNode labelNodeWithFontNamed:@"Dosis-Regular"];
        nudgeLabel.text = @"Nudge";
        nudgeLabel.fontColor = [UIColor whiteColor];
        nudgeLabel.fontSize = 20;
        nudgeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        
        [nudge addChild:nudgeLabel];
        
        SKSpriteNode *nudgeArrow = [SKSpriteNode spriteNodeWithImageNamed:@"arrow"];
        [nudgeArrow setScale:0.25];
        [nudge addChild: nudgeArrow];
        nudgeArrow.position = CGPointMake(0, -14);
        
        SKAction *up = [SKAction moveToY:160 duration:1.25];
        SKAction *down = [SKAction moveToY:150.0 duration:.25];
        SKAction *bounce = [SKAction sequence:@[up, down]];
        SKAction *repeatBounce = [SKAction repeatActionForever:bounce];
        [nudge runAction:repeatBounce];
        
        
        backButton = [SKRoundedButton rectangleWithRect:CGRectMake(0, 0, 80, 40)
                                            cornerRadius:3.0
                                             borderColor:[UIColor whiteColor]
                                               fillColor:[UIColor clearColor]
                                             borderWidth:1.0
                                                fontName:@"Dosis-Regular"
                                                    text:@"STORE"];
        
        backButton.position = CGPointMake( 15, size.height - 50);
        [self addChild:backButton];
        
        
        CGRect aboutRect = CGRectMake(0, 0, 40, 40);
        aboutButton = [SKRoundedButton rectangleWithRect:aboutRect
                                            cornerRadius:3.0
                                             borderColor:[UIColor whiteColor]
                                               fillColor:[UIColor clearColor]
                                             borderWidth:1.0
                                                fontName:@"Dosis-Regular"
                                                    text:@"?"];
        aboutButton.position = CGPointMake(size.width - 50, size.height - 50);
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
