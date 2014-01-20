//
//  ViewController.m
//  Glimmer
//
//  Created by Gavin Potts on 11/25/13.
//  Copyright (c) 2013 Gavin Potts. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "IntroScene.h"
#import "sprites.h"
#import "GameKitHelper.h"
@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAuthenticationViewController) name:PresentAuthenticationViewController object:nil];
    [[GameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    //self.view.backgroundColor = [UIColor blackColor];
    
    
    // Configure the view
    [SKTexture preloadTextures:@[
                                 SPRITEBUNDLE_TEX_CONTROLS_BUTTONS,
                                 SPRITEBUNDLE_TEX_MOON_MOON_01,
                                 SPRITEBUNDLE_TEX_MOON_MOON_02,
                                 SPRITEBUNDLE_TEX_MOON_MOON_03,
                                 SPRITEBUNDLE_TEX_MOON_MOON_04,
                                 SPRITEBUNDLE_TEX_MOON_MOON_05,
                                 SPRITEBUNDLE_TEX_MOON_MOON_06,
                                 SPRITEBUNDLE_TEX_MOON_MOON_07,
                                 SPRITEBUNDLE_TEX_MOON_MOON_08,
                                 SPRITEBUNDLE_TEX_MOON_MOON_09,
                                 SPRITEBUNDLE_TEX_MOON_MOON_10,
                                 SPRITEBUNDLE_TEX_MOON_MOON_11,
                                 SPRITEBUNDLE_TEX_STATE_TYPE_GAMEOVER,
                                 SPRITEBUNDLE_TEX_STATE_TYPE_GLIMMER,
                                 SPRITEBUNDLE_TEX_STATE_TYPE_WIN,
                                 SPRITEBUNDLE_TEX_CHAR_REGULAR_CATCH_CHAR_CATCH_LEFT,
                                 SPRITEBUNDLE_TEX_CHAR_REGULAR_CATCH_CHAR_CATCH_RIGHT,
                                 SPRITEBUNDLE_TEX_CHAR_REGULAR_ZOOM_CHAR_ZOOM_LEFT,
                                 SPRITEBUNDLE_TEX_CHAR_REGULAR_ZOOM_CHAR_ZOOM_RIGHT,
                                 SPRITEBUNDLE_TEX_GLIMMER_THING_01,
                                 SPRITEBUNDLE_TEX_GLIMMER_THING_02,
                                 SPRITEBUNDLE_TEX_CHAR_REGULAR_CELEBRATE_CHAR_CELEBRATE_01,
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
         
         
         
         SKView * skView = (SKView *)self.view;
         skView.showsFPS = YES;
         skView.showsNodeCount = YES;
         skView.showsDrawCount = YES;
         // Create and configure the scene.
         SKScene * scene = [IntroScene sceneWithSize:skView.bounds.size];
         scene.scaleMode = SKSceneScaleModeAspectFill;
         // Present the scene.
         [skView presentScene:scene];
         
        
     }];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewAppeared" object:nil userInfo:nil];
}
- (void)showAuthenticationViewController {
    GameKitHelper *gameKitHelper = [GameKitHelper sharedGameKitHelper];
    [self presentViewController: gameKitHelper.authenticationViewController
                                         animated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
