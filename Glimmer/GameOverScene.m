//
//  GameOverScene.m
//  Glimmer
//
//  Created by Gavin Potts on 11/26/13.
//  Copyright (c) 2013 Gavin Potts. All rights reserved.
//
@import AVFoundation;

#import "GameOverScene.h"
#import "sprites.h"
#import "IntroScene.h"
#import "MyScene.h"
#import "BackgroundSprite.h"
#import <TestFlightSDK/TestFlight.h>
#import <GameKit/GameKit.h>
#import "GameKitHelper.h"
#import "SKRoundedButton.h"

@implementation GameOverScene
{
    AVAudioPlayer *_backgroundMusicPlayer;
    int highScore;
    
    int highMulti;
    
    int lastScore;
    
    int lastMulti;
    
    SKRoundedButton *leaderboardBtn;
}


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        /* Setup your scene here */
        NSLog(@"GAME OVER");
        
                BackgroundSprite *bg = [[BackgroundSprite alloc] init];
                [self addChild:bg];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                highScore = [defaults integerForKey:@"score"];
                
                highMulti = [defaults integerForKey:@"multiplier"];
                
                lastScore = [defaults integerForKey:@"last_score"];
                
                lastMulti = [defaults integerForKey:@"last_multiplier"];
                
                [self reportScoreToGameCenter];
        
        NSNumberFormatter *_formatter = [[NSNumberFormatter alloc] init];
        [_formatter setNumberStyle:NSNumberFormatterNoStyle];
        NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
        [_formatter setGroupingSeparator:groupingSeparator];
        [_formatter setGroupingSize:3];
        [_formatter setAlwaysShowsDecimalSeparator:NO];
        [_formatter setUsesGroupingSeparator:YES];
        
                SKLabelNode *yourScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Dosis-Regular"];
                yourScoreLabel.text = @"YOUR SCORE";
                yourScoreLabel.fontSize = 15;
                yourScoreLabel.fontColor = [UIColor yellowColor];
                yourScoreLabel.position = CGPointMake(size.width - 15, size.height - 105);
                [yourScoreLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight];
                [self addChild:yourScoreLabel];
                
                SKLabelNode *lastScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Dosis-Regular"];
                lastScoreLabel.text = [_formatter stringFromNumber:[NSNumber numberWithInt:lastScore]];
                lastScoreLabel.fontSize = 45;
                lastScoreLabel.position = CGPointMake( size.width - 15, size.height -145);
                [lastScoreLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight];
                [self addChild:lastScoreLabel];
                
                SKLabelNode *_scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Dosis-Regular"];
                _scoreLabel.text = [NSString stringWithFormat:@"ALL TIME: %@", [_formatter stringFromNumber:[NSNumber numberWithInt:highScore]]];
                _scoreLabel.fontSize = 15;
                _scoreLabel.position = CGPointMake( size.width - 15, size.height - 165);
                [_scoreLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight];
                [self addChild:_scoreLabel];
                
                
                SKLabelNode *maxComboLabel = [SKLabelNode labelNodeWithFontNamed:@"Dosis-Regular"];
                maxComboLabel.text = @"MAX COMBO";
                maxComboLabel.fontSize = 15;
                maxComboLabel.fontColor = [UIColor yellowColor];
                maxComboLabel.position = CGPointMake(size.width - 15, size.height - 205);
                [maxComboLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight];
                [self addChild:maxComboLabel];
                
                
                SKLabelNode *lastMultiLabel = [SKLabelNode labelNodeWithFontNamed:@"Dosis-Regular"];
                lastMultiLabel.text = [NSString stringWithFormat:@"x%d", lastMulti];
                lastMultiLabel.fontSize = 45;
                lastMultiLabel.position = CGPointMake( size.width - 15, size.height - 245);
                [lastMultiLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight];
                [self addChild:lastMultiLabel];
                
                
                SKLabelNode *multiLabel = [SKLabelNode labelNodeWithFontNamed:@"Dosis-Regular"];
                multiLabel.text = [NSString stringWithFormat:@"ALL TIME: x%d", highMulti];
                multiLabel.fontSize = 15;
                multiLabel.position = CGPointMake( size.width - 15, size.height - 265);
                [multiLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight];
                [self addChild:multiLabel];
                
                SKSpriteNode *child = [SKSpriteNode spriteNodeWithTexture:SPRITEBUNDLE_TEX_CHAR_REGULAR_CELEBRATE_CHAR_CELEBRATE_07];
                //child.anchorPoint = CGPointMake(0, 0);
                child.position = CGPointMake((self.size.width/4 * 3), 120);
                
                child.name = @"child";
                
                [self addChild:child];
        
                SKSpriteNode *burst = [[SKSpriteNode alloc] initWithTexture:SPRITEBUNDLE_TEX_BURST_BURSTINGJAR_01];
        
                SKAction *bursting = [SKAction animateWithTextures:SPRITEBUNDLE_ANIM_BURST_BURSTINGJAR timePerFrame:0.25];
                [self addChild:burst];
                burst.position = CGPointMake((self.size.width/4) + 15, 350);
                SKAction *burstForever = [SKAction repeatActionForever:bursting];
                [burst runAction:burstForever];
        
                 //SKAction *dance = [SKAction animateWithTextures:SPRITEBUNDLE_ANIM_CHAR_REGULAR_CELEBRATE_CHAR_CELEBRATE timePerFrame:0.25 resize:NO restore:YES];
                 //[child runAction:dance];
        
        
                CGRect aboutRect = CGRectMake(0, 0, 110, 40);
                leaderboardBtn = [SKRoundedButton rectangleWithRect:aboutRect
                                                    cornerRadius:3.0
                                                     borderColor:[UIColor whiteColor]
                                                       fillColor:[UIColor clearColor]
                                                     borderWidth:1.0
                                                        fontName:@"Dosis-Regular"
                                                            text:@"Leaderboard"];
                leaderboardBtn.position = CGPointMake(size.width - 120, size.height - 50);
                [self addChild:leaderboardBtn];
        
        
        
                /*SKAction *jump = [SKAction moveToY:250.0 duration:0.25];
                SKAction *land = [SKAction moveToY:120.0 duration:0.25];
                SKAction *wait = [SKAction waitForDuration:0.25];
                SKAction *jumpAndLand = [SKAction sequence:@[ jump, wait, land]];
                SKAction *jumpAnim = [SKAction animateWithTextures:@[SPRITEBUNDLE_TEX_CHAR_REGULAR_CELEBRATE_CHAR_CELEBRATE_01,
                                                                     SPRITEBUNDLE_TEX_CHAR_REGULAR_CELEBRATE_CHAR_CELEBRATE_02,
                                                                     SPRITEBUNDLE_TEX_CHAR_REGULAR_CELEBRATE_CHAR_CELEBRATE_03]
                                                                     timePerFrame:0.25];
                SKAction *fullDance = [SKAction group:@[jumpAndLand, jumpAnim]];*/
                
                //[child runAction:fullDance completion:^{
                SKAction *dance = [SKAction animateWithTextures:@[SPRITEBUNDLE_TEX_CHAR_REGULAR_CELEBRATE_CHAR_CELEBRATE_04,
                                                                  SPRITEBUNDLE_TEX_CHAR_REGULAR_CELEBRATE_CHAR_CELEBRATE_05,
                                                                  SPRITEBUNDLE_TEX_CHAR_REGULAR_CELEBRATE_CHAR_CELEBRATE_06,
                                                                  SPRITEBUNDLE_TEX_CHAR_REGULAR_CELEBRATE_CHAR_CELEBRATE_07,
                                                                  SPRITEBUNDLE_TEX_CHAR_REGULAR_CELEBRATE_CHAR_CELEBRATE_08]
                                                   timePerFrame:0.25 resize:YES restore:NO];
                SKAction *repeatDance = [SKAction repeatActionForever:dance];
                [child runAction:repeatDance];
               // }];
                
                SKAction * waitMusic = [SKAction waitForDuration:1.0];
                SKAction * musicBlock = [SKAction runBlock:^{
                    //[self playBackgroundMusic:@"Music-Win.aifc"];
                }];
        
                SKRoundedButton *playAgain = [SKRoundedButton rectangleWithRect:CGRectMake(0, 0, 280, 40)
                                               cornerRadius:3.0
                                                borderColor:[UIColor whiteColor]
                                                  fillColor:[UIColor clearColor]
                                                borderWidth:1.0
                                                   fontName:@"Dosis-Regular"
                                                       text:@"PLAY AGAIN"];
        
                playAgain.position = CGPointMake( size.width/2 - playAgain.size.width/2, 10);
                [self addChild:playAgain];
        
                [self runAction:[SKAction sequence:@[waitMusic, musicBlock]]];
        
        
    }
    return self;
}

- (void)reportScoreToGameCenter {
    
    [[GameKitHelper sharedGameKitHelper]
     reportScore:lastScore forLeaderboardID:@"highscore"];
    
    [[GameKitHelper sharedGameKitHelper]
     reportScore:lastMulti forLeaderboardID:@"multiplier"];
}

- (void) authenticateLocalPlayer
{
   
}


-(void)authenticatedPlayer: (GKLocalPlayer*)localPlayer
{
    
}

-(void)showAuthenticationDialogWhenReasonable: (UIViewController*)viewController
{
    UIViewController *vc = self.view.window.rootViewController;
    [vc presentViewController:viewController animated:YES completion:^{
        
    }];
}

-(void)disableGameCenter
{
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    
    
    for (UITouch *touch in touches) {
        // Get the user's touch location
        CGPoint location = [touch locationInNode:self];
        
        if(CGRectContainsPoint(leaderboardBtn.frame, location)){
            
            [[GameKitHelper sharedGameKitHelper] showGKGameCenterViewController:self.view.window.rootViewController];
            
        } else {
            
            IntroScene *myScene = [[IntroScene alloc] initWithSize:self.size];
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            [_backgroundMusicPlayer stop];
            [self.view presentScene:myScene transition: reveal];
            [self removeFromParent];
        }
    }
    

}

- (void)playBackgroundMusic:(NSString *)filename {
    
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    _backgroundMusicPlayer = [[AVAudioPlayer alloc]
                              initWithContentsOfURL:backgroundMusicURL error:&error]; _backgroundMusicPlayer.numberOfLoops = -1; [_backgroundMusicPlayer prepareToPlay];
    //[_backgroundMusicPlayer setCurrentTime:30.0];
    //[_backgroundMusicPlayer setVolume:0.3];
    [_backgroundMusicPlayer play];
   
}
@end
