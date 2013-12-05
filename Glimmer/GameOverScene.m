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
#import "MyScene.h"
#import <TestFlightSDK/TestFlight.h>
#import <GameKit/GameKit.h>
@implementation GameOverScene
{
    AVAudioPlayer *_backgroundMusicPlayer;
}
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        /* Setup your scene here */
        self.backgroundColor = [SKColor lightGrayColor];
        
        SKSpriteNode *sky =
        [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"gradient-01-small"]];
        sky.position = CGPointMake(size.width/2, size.height - sky.size.height/2);
        [self addChild:sky];
        
        SKSpriteNode *tree1 =
        [SKSpriteNode spriteNodeWithTexture:SPRITEBUNDLE_TEX_BACKGROUND_TREE_01];
        tree1.position = CGPointMake(50.0, 158.0);
        [self addChild:tree1];
        
        SKSpriteNode *tree2 =
        [SKSpriteNode spriteNodeWithTexture:SPRITEBUNDLE_TEX_BACKGROUND_TREE_02];
        tree2.position = CGPointMake(size.width - 40.0, 158.0);
        [self addChild:tree2];
        
        SKSpriteNode *grass =
        [SKSpriteNode spriteNodeWithTexture:SPRITEBUNDLE_TEX_BACKGROUND_GRASS];
        grass.position = CGPointMake(size.width/2, 65.0);
        [self addChild:grass];
        
        SKSpriteNode *bg3 =
        [SKSpriteNode spriteNodeWithTexture:SPRITEBUNDLE_TEX_CONTROLS_BUTTONS];
        bg3.position = CGPointMake(size.width/2, 45.0);
        [self addChild:bg3];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        int highScore = [defaults integerForKey:@"score"];
        
        int highMulti = [defaults integerForKey:@"multiplier"];
        
        int lastScore = [defaults integerForKey:@"last_score"];
        
        int lastMulti = [defaults integerForKey:@"last_multiplier"];
        
        
        SKLabelNode *yourScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Dosis-Regular"];
        yourScoreLabel.text = @"YOUR SCORE";
        yourScoreLabel.fontSize = 15;
        yourScoreLabel.fontColor = [UIColor yellowColor];
        yourScoreLabel.position = CGPointMake(size.width - 15, size.height - 105);
        [yourScoreLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight];
        [self addChild:yourScoreLabel];
        
        SKLabelNode *lastScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Dosis-Regular"];
        lastScoreLabel.text = [NSString stringWithFormat:@"%d", lastScore];
        lastScoreLabel.fontSize = 45;
        lastScoreLabel.position = CGPointMake( size.width - 15, size.height -145);
        [lastScoreLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight];
        [self addChild:lastScoreLabel];
        
        SKLabelNode *_scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Dosis-Regular"];
        _scoreLabel.text = [NSString stringWithFormat:@"ALL TIME: %d", highScore];
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
        lastMultiLabel.text = [NSString stringWithFormat:@"X%d", lastMulti];
        lastMultiLabel.fontSize = 45;
        lastMultiLabel.position = CGPointMake( size.width - 15, size.height - 245);
        [lastMultiLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight];
        [self addChild:lastMultiLabel];
        
        
        SKLabelNode *multiLabel = [SKLabelNode labelNodeWithFontNamed:@"Dosis-Regular"];
        multiLabel.text = [NSString stringWithFormat:@"ALL TIME: X%d", highMulti];
        multiLabel.fontSize = 15;
        multiLabel.position = CGPointMake( size.width - 15, size.height - 265);
        [multiLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight];
        [self addChild:multiLabel];
        
        SKSpriteNode *child = [SKSpriteNode spriteNodeWithTexture:SPRITEBUNDLE_TEX_CHAR_STAND_CHAR_STAND_RIGHT];
        
        child.position = CGPointMake((self.size.width/4), 120);
        
        child.name = @"child";
        
        [self addChild:child];
        
        SKAction *dance = [SKAction animateWithTextures:SPRITEBUNDLE_ANIM_CHAR_CELEBRATE_CHAR_CELEBRATE timePerFrame:0.25];
        
        SKAction *jump = [SKAction moveToY:350.0 duration:0.25];
        SKAction *land = [SKAction moveToY:120.0 duration:0.25];
        SKAction *wait = [SKAction waitForDuration:0.25];
        SKAction *jumpAndLand = [SKAction sequence:@[wait, jump, wait, land, wait, wait, wait, wait]];
        SKAction *repeatDance = [SKAction repeatActionForever:dance];
        SKAction *repeatJump = [SKAction repeatActionForever:jumpAndLand];
        SKAction *fullDance = [SKAction group:@[repeatJump, repeatDance]];
        
        [child runAction:fullDance];
        
        SKAction * waitMusic = [SKAction waitForDuration:1.0];
        SKAction * musicBlock = [SKAction runBlock:^{
            [self playBackgroundMusic:@"Music-Win.mp3"];
        }];
        [self runAction:[SKAction sequence:@[waitMusic, musicBlock]]];
        //a[self authenticateLocalPlayer];
        
    }
    return self;
}

- (void) authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil)
        {
            //showAuthenticationDialogWhenReasonable: is an example method name. Create your own method that displays an authentication view when appropriate for your app.
            [self showAuthenticationDialogWhenReasonable: viewController];
        }
        else if (localPlayer.isAuthenticated)
        {
            //authenticatedPlayer: is an example method name. Create your own method that is called after the loacal player is authenticated.
            [self authenticatedPlayer: localPlayer];
        }
        else
        {
            [self disableGameCenter];
        }
    };
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
    MyScene *myScene = [[MyScene alloc] initWithSize:self.size];
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
    [_backgroundMusicPlayer stop];
    [self.view presentScene:myScene transition: reveal];
    
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
