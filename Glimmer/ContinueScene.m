//
//  ContinueScene.m
//  Glimmer
//
//  Created by Gavin Potts on 1/3/14.
//  Copyright (c) 2014 Gavin Potts. All rights reserved.
//

#import "ContinueScene.h"
#import "sprites.h"

@implementation ContinueScene
@synthesize continues = _continues;
@synthesize gameScene = _gameScene;
int secondsLeft;
- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        NSString *pills = [[GSKeychain systemKeychain] secretForKey:@"Pills"];
        self.continues = [pills intValue];
        
        SKSpriteNode *pillSprite = [[SKSpriteNode alloc] initWithImageNamed:@"item-pills"];
        pillSprite.position = CGPointMake(size.width/2 + 5, size.height/2);
        [self addChild:pillSprite];
        
        pillCount = [SKLabelNode labelNodeWithFontNamed:@"Dosis-Regular"];
        pillCount.text = [NSString stringWithFormat:@"x%d", self.continues];
        pillCount.fontSize = 15;
        pillCount.position = CGPointMake(pillSprite.position.x + pillSprite.size.width/2 - 15, pillSprite.position.y + pillSprite.size.height/2);
        [self addChild:pillCount];
        
        
        
        SKLabelNode *usePill = [SKLabelNode labelNodeWithFontNamed:@"Dosis-Regular"];
        usePill.text = @"Use 1 Malaria Pill to Continue";
        usePill.fontSize = 15;
        usePill.position = CGPointMake(size.width/2, 200);
        [self addChild:usePill];
        
        
        timeLbl = [SKLabelNode labelNodeWithFontNamed:@"Dosis-Regular"];
        timeLbl.text = @"05";
        timeLbl.fontSize = 30;
        timeLbl.position = CGPointMake(size.width/2, 400);
        [self addChild:timeLbl];
        secondsLeft = 5;
        [self countdownTimer];
        
        useContinue = [SKRoundedButton rectangleWithRect:CGRectMake(0, 0, 100, 30)
                                           cornerRadius:3.0
                                            borderColor:[UIColor whiteColor]
                                              fillColor:[UIColor clearColor]
                                            borderWidth:1.0
                                               fontName:@"Dosis-Regular"
                                                   text:@"CONTINUE?"];
        
        useContinue.position = CGPointMake( size.width/2 - useContinue.size.width/2, 150);
        [self addChild:useContinue];
    
    }
    
    return self;

}

- (void)willMoveFromView:(SKView *)view
{
    [timer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didMoveToView:(SKView *)view{
    NSString *pills = [[GSKeychain systemKeychain] secretForKey:@"Pills"];
    self.continues = [pills intValue];
    pillCount.text = [NSString stringWithFormat:@"x%d", self.continues];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(countdownTimer) name:@"ViewAppeared" object:nil];
}

-(void)countdownTimer{
    
    NSString *pills = [[GSKeychain systemKeychain] secretForKey:@"Pills"];
    self.continues = [pills intValue];
    pillCount.text = [NSString stringWithFormat:@"x%d", self.continues];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}

- (void)updateCounter:(NSTimer *)theTimer {
    if(secondsLeft > 0 ){
        secondsLeft -- ;
        
        timeLbl.text = [NSString stringWithFormat:@"%02d", secondsLeft];
    }
    else{
        [timer invalidate];
        [self gameOver];
    }
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        // Get the user's touch location
        CGPoint location = [touch locationInNode:self];
        
        if(CGRectContainsPoint(useContinue.frame, location)){
            [timer invalidate];
            if(self.continues > 0){
                [self doContinue];
            } else {
                [self openStore];
            }
            
        } else if(CGRectContainsPoint(gameover.frame, location)){
            
            [self gameOver];
            
        } else if(CGRectContainsPoint(store.frame, location)){
            [self openStore];
        }
    }
}

- (void)gameOver{
    SKScene * gameOverScene =
    [[GameOverScene alloc] initWithSize:self.size];
    
    [SKTexture preloadTextures:@[SPRITEBUNDLE_TEX_CHAR_REGULAR_CELEBRATE_CHAR_CELEBRATE_01,
                                 SPRITEBUNDLE_TEX_CHAR_REGULAR_CELEBRATE_CHAR_CELEBRATE_02,
                                 SPRITEBUNDLE_TEX_CHAR_REGULAR_CELEBRATE_CHAR_CELEBRATE_03,
                                 SPRITEBUNDLE_TEX_CHAR_REGULAR_CELEBRATE_CHAR_CELEBRATE_04,
                                 SPRITEBUNDLE_TEX_CHAR_REGULAR_CELEBRATE_CHAR_CELEBRATE_05,
                                 SPRITEBUNDLE_TEX_CHAR_REGULAR_CELEBRATE_CHAR_CELEBRATE_06,
                                 SPRITEBUNDLE_TEX_CHAR_REGULAR_CELEBRATE_CHAR_CELEBRATE_07,
                                 SPRITEBUNDLE_TEX_CHAR_REGULAR_CELEBRATE_CHAR_CELEBRATE_08,
                                 SPRITEBUNDLE_TEX_BURST_BURSTINGJAR_01,
                                 SPRITEBUNDLE_TEX_BURST_BURSTINGJAR_02,
                                 SPRITEBUNDLE_TEX_BURST_BURSTINGJAR_03,
                                 SPRITEBUNDLE_TEX_BURST_BURSTINGJAR_04,
                                 SPRITEBUNDLE_TEX_BURST_BURSTINGJAR_05,
                                 SPRITEBUNDLE_TEX_BURST_BURSTINGJAR_06]
         withCompletionHandler:^
     {
    
    // 2
    SKTransition *reveal =
    [SKTransition fadeWithDuration:0.5];
    
    [self.view presentScene:gameOverScene transition:reveal];
     }];
}

- (void)doContinue{
    self.continues --;
    
    [[GSKeychain systemKeychain] setSecret:[NSString stringWithFormat:@"%d", self.continues] forKey:@"Pills"];
    self.gameScene.publicHearts = 5;
    // 2
    SKTransition *reveal =
    [SKTransition fadeWithDuration:0.5];

    [self.view presentScene:self.gameScene transition:reveal];
    [self.gameScene unpause];
}

- (void)openStore{
    UIViewController *vc = self.view.window.rootViewController;
    [vc performSegueWithIdentifier:@"ShowStore" sender:nil];
}

@end
