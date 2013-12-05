//
//  MyScene.m
//  Glimmer
//
//  Created by Gavin Potts on 11/25/13.
//  Copyright (c) 2013 Gavin Potts. All rights reserved.
//
@import AVFoundation;

#import "MyScene.h"
#import "GlimmerSprite.h"
#import "ChildSprite.h"
#import "sprites.h"
#import "GameOverScene.h"
#import <QuartzCore/QuartzCore.h>

float const SCORE_PER_GLIMMER = 2.0;
float const LEVEL_THRESHOLD = 20.0;

@implementation MyScene
{
    ChildSprite *_child;
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    CGPoint _velocity;
    float GLIMMER_MOVE_PER_SEC;
    float CHILD_MOVE_PER_SECOND;
    float DASH;
    float WALK;
    float LEVEL_COUNT;
    float GAP;
    float LEVEL;
    NSMutableArray *_glimmers;
    NSInteger _maxGlimmers;
    SKLabelNode *_scoreLabel;
    SKLabelNode *_lifeLabel;
    SKLabelNode *_multiplierLabel;
    NSInteger _multiplier;
    NSInteger _score;
    NSInteger _lives;
    AVAudioPlayer *_backgroundMusicPlayer;
    SKSpriteNode *_moon;
    BOOL _gameOver;
    CGPoint lastPoint;
    NSInteger lastX;
    SKAction *resetFigure;
    SKSpriteNode *btn;
    NSTimer *timer;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        DASH = 500.0;
        WALK = 250.0;
        CHILD_MOVE_PER_SECOND = 250.0;
        GLIMMER_MOVE_PER_SEC = 120.0;
        LEVEL_COUNT = 1.0;

        _gameOver = NO;
        
        /* Setup your scene here */
        self.backgroundColor = [SKColor lightGrayColor];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:0 forKey:@"last_score"];
        [defaults setInteger:0 forKey:@"last_multiplier"];
        
        lastX = 1;
        
        SKSpriteNode *sky =
        [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"gradient-01-small"]];
        sky.position = CGPointMake(size.width/2, size.height - sky.size.height/2);
        [self addChild:sky];
        
        _moon = [SKSpriteNode spriteNodeWithTexture:SPRITEBUNDLE_TEX_MOON_MOON_01];
        _moon.position = CGPointMake(size.width - _moon.size.width, size.height - 30.0);
        [self addChild:_moon];
        
        SKAction *moonAnim = [SKAction animateWithTextures:SPRITEBUNDLE_ANIM_MOON_MOON timePerFrame:3.0];
        
        SKAction *moonPhase = [SKAction repeatActionForever:moonAnim];
        
        [_moon runAction:moonPhase];
        
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
        
        btn =
        [SKSpriteNode spriteNodeWithTexture:SPRITEBUNDLE_TEX_CONTROLS_BUTTONS_PRESSED];
        btn.position = CGPointMake(20.0, 20.0);
        [self addChild:btn];
        btn.alpha = 0.0;
        
        _maxGlimmers = 5;
        _multiplier = 1;
        _score = 0;
        _lives = 5;
        _glimmers = [[NSMutableArray alloc] initWithCapacity:5];
        
        
        _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Dosis-Regular"];
        _scoreLabel.text = @"0";
        _scoreLabel.fontColor = [UIColor yellowColor];
        _scoreLabel.fontSize = 30;
        _scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        _scoreLabel.position = CGPointMake( 10.0, size.height - 25.0 - _scoreLabel.frame.size.height);
        
        [self addChild:_scoreLabel];
        
        _multiplierLabel = [SKLabelNode labelNodeWithFontNamed:@"Dosis-Regular"];
        _multiplierLabel.text = @"x1";
        _multiplierLabel.fontSize = 15;
        _multiplierLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        _multiplierLabel.position = CGPointMake( _scoreLabel.frame.size.width + _scoreLabel.frame.origin.x, _scoreLabel.frame.origin.y + 5.0);
        
        [self addChild:_multiplierLabel];
        
        _lifeLabel = [SKLabelNode labelNodeWithFontNamed:@"Dosis-Regular"];
        _lifeLabel.text = [NSString stringWithFormat:@"Lives: %ld", (long)_lives];
        _lifeLabel.fontSize = 12;
        _lifeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        _lifeLabel.position = CGPointMake(_scoreLabel.frame.origin.x, size.height - 70.0);
        
        [self addChild:_lifeLabel];
        
        GAP = 0.75;
        timer = [NSTimer timerWithTimeInterval:GAP target:self selector:@selector(makeNewGlimmer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        _child = [ChildSprite spriteNodeWithTexture:SPRITEBUNDLE_TEX_CHAR_STAND_CHAR_STAND_RIGHT];
        
        _child.position = CGPointMake((self.size.width/4), 170.0);
        
        _child.name = @"child";
        
        [self addChild:_child];
        
        [self playBackgroundMusic:@"Music-Level.aifc"];
        
        
    }
    return self;
}

- (void)playBackgroundMusic:(NSString *)filename {
    
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    _backgroundMusicPlayer = [[AVAudioPlayer alloc]
                              initWithContentsOfURL:backgroundMusicURL error:&error]; _backgroundMusicPlayer.numberOfLoops = -1; [_backgroundMusicPlayer prepareToPlay];
    [_backgroundMusicPlayer play];
}

- (void)checkCollisions {
    
    [self enumerateChildNodesWithName:@"glimmer"
                           usingBlock:^(SKNode *node, BOOL *stop){
                               SKSpriteNode *glimmer = (SKSpriteNode *)node;
                               
                               CGRect smallerFrame = CGRectMake(_child.frame.origin.x, _child.frame.origin.y + 60.0, _child.frame.size.width - 10.0, 5.0);
                               if (CGRectIntersectsRect(smallerFrame, glimmer.frame)) {

                                   [glimmer removeFromParent];
                                   [_glimmers removeObject:glimmer];
                                   if(_multiplier < 1){
                                       _multiplier = 1;
                                   }
                                   _multiplier++;
                                   
                                   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                   
                                   int highMulti = [defaults integerForKey:@"multiplier"];
                                   int lastMulti = [defaults integerForKey:@"last_multiplier"];
                                   
                                   if(highMulti < _multiplier){
                                       [defaults setInteger:_multiplier forKey:@"multiplier"];
                                   }
                                   
                                   if(lastMulti < _multiplier){
                                       [defaults setInteger:_multiplier forKey:@"last_multiplier"];
                                   }
                                   [defaults synchronize];
                                   
                                   _score += SCORE_PER_GLIMMER * _multiplier;
                                   _scoreLabel.text = [NSString stringWithFormat:@"%li", (long)_score];
                                   _multiplierLabel.text = [NSString stringWithFormat:@"x%li", (long)_multiplier];
                                   _multiplierLabel.position = CGPointMake( _scoreLabel.frame.size.width + _scoreLabel.frame.origin.x, _scoreLabel.frame.origin.y + 5.0);
                                   
                                   [_child catch];
                                   
                                   
                                   LEVEL_COUNT ++;
                                   if(fmodf(LEVEL_COUNT, LEVEL_THRESHOLD) == 1)
                                   {
                                      
                                       WALK += 25;
                                       DASH += 25;
                                       
                                       GLIMMER_MOVE_PER_SEC +=30;
                                       
                                       SKLabelNode *levelPop = [[SKLabelNode alloc] initWithFontNamed:@"Dosis-Regular"];
                                       int cur_level = LEVEL_COUNT/LEVEL_THRESHOLD;
                                       levelPop.text = [NSString stringWithFormat:@"LEVEL %d", cur_level+1];
                                       levelPop.fontSize = 50.0;
                                       levelPop.position = CGPointMake(self.size.width/2, self.size.height/2);
                                       [self addChild:levelPop];
                                       SKAction *flyScore = [SKAction moveToY:self.size.height duration:1.0];
                                       SKAction *fade = [SKAction fadeAlphaTo:0.0 duration:0.8];
                                       SKAction *flyAndFade = [SKAction group:@[flyScore, fade]];
                                       [levelPop runAction:flyAndFade completion:^{
                                           [levelPop removeFromParent];
                                       }];
                                   }
                                   
                                   
                                   
                                   
                                   SKEmitterNode *engineEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:
                                                                   [[NSBundle mainBundle] pathForResource:@"glimmerDeath" ofType:@"sks"]];
                                   
                                   engineEmitter.position = glimmer.position;
                                   
                                   engineEmitter.name = @"engineEmitter";
                                   
                                   [self addChild:engineEmitter];
                                   
                                   [engineEmitter resetSimulation];
                                   
                                   
                                   
                                   SKLabelNode *scorePop = [[SKLabelNode alloc] initWithFontNamed:@"Dosis-Regular"];
                                   int points = SCORE_PER_GLIMMER * _multiplier;
                                   scorePop.text = [NSString stringWithFormat:@"+%d", points];
                                   scorePop.fontSize = 30.0;
                                   scorePop.position = engineEmitter.position;
                                   [self addChild:scorePop];
                                   SKAction *flyScore = [SKAction moveToY:self.size.height duration:0.75];
                                   SKAction *fade = [SKAction fadeAlphaTo:0.0 duration:0.6];
                                   SKAction *flyAndFade = [SKAction group:@[flyScore, fade]];
                                   [scorePop runAction:flyAndFade completion:^{
                                       [scorePop removeFromParent];
                                   }];
                                   //SKAction *catchSoundAction = [SKAction playSoundFileNamed:@"Char-Catch.aifc" waitForCompletion:NO];
                                   //[self runAction:catchSoundAction];
                                   
                               }
                           }];
}
-(void)makeNewGlimmer{
    
    
    if([_glimmers count] < _maxGlimmers){
        
        SKSpriteNode *glimmer;
        NSInteger idx = arc4random()%2+1;
        if(idx == 1){
            glimmer = [SKSpriteNode spriteNodeWithTexture:SPRITEBUNDLE_TEX_GLIMMER_THING_02 size:CGSizeMake(20.0, 20.0)];

        } else {
         glimmer = [SKSpriteNode spriteNodeWithTexture:SPRITEBUNDLE_TEX_GLIMMER_THING_01 size:CGSizeMake(20.0, 20.0)];
        }
        NSInteger r = arc4random()%4 + 1;
        
        glimmer.position = CGPointMake(r * (self.view.frame.size.width / 4) - ((self.view.frame.size.width / 4)/2), self.view.frame.size.height);
        
        glimmer.name = @"glimmer";
        
        SKEmitterNode *engineEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:
                                        [[NSBundle mainBundle] pathForResource:@"GlimmerGlow" ofType:@"sks"]];
        engineEmitter.position = CGPointMake(1, -4); engineEmitter.name = @"engineEmitter";
        [glimmer addChild:engineEmitter];
        
        [_glimmers addObject:glimmer];
        
        [self addChild:glimmer];
        
        
    }
    
    GAP = (((arc4random() % 100)/100.0f)*.75) + 0.5;
    //NSLog(@"GAP: %f", GAP);
    [timer invalidate];
    timer = [NSTimer timerWithTimeInterval:GAP target:self selector:@selector(makeNewGlimmer) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {

        CGPoint location = [touch locationInNode:self];
        
        NSInteger nearestX = (location.x / (self.size.width/4));
        
        int x = (nearestX * (self.view.frame.size.width / 4)) + _child.size.width / 2;
        
        NSInteger dif = ABS(nearestX - lastX);
        
        
        if(x > _child.position.x){
            
            _child.direction = @"right";

            if(dif  < 2){
                CHILD_MOVE_PER_SECOND = WALK;
                [_child walk];
            } else {
                CHILD_MOVE_PER_SECOND = DASH;
                [_child dash];
            }
            
        } else {

            _child.direction = @"left";

            if(dif < 2){
                CHILD_MOVE_PER_SECOND = WALK;
                [_child walk];
            } else {
                CHILD_MOVE_PER_SECOND = DASH;
                [_child dash];
            }
        }
        
        lastX = nearestX;
        
        lastPoint = CGPointMake(x, _child.position.y);
        btn.position = CGPointMake(lastPoint.x - 10.0, 48.0);
        
        SKAction *btnFade = [SKAction fadeAlphaTo:1.0 duration:0.1];
        SKAction *btnFadeOut = [SKAction fadeAlphaTo:0.0 duration:0.3];
        SKAction *fadeAction = [SKAction sequence:@[btnFade, btnFadeOut]];
        
        [btn runAction:fadeAction];
        
        [self moveChildToward:lastPoint];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    
    if (_lastUpdateTime) {
        _dt = currentTime - _lastUpdateTime;
    } else {
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    
    CGPoint offset = CGPointMake(lastPoint.x - _child.position.x, lastPoint.y - _child.position.y);
    
    CGFloat length = sqrtf(offset.x * offset.x + offset.y * offset.y);

    if(length > 20){
    
        [self moveSprite:_child velocity:_velocity];
    
    } else {
        [_child setPosition:lastPoint];
        if(_velocity.x != 0){
            
            _velocity = CGPointMake(0, 0);
            
            [_child resetCharacter];
            
        }
        
    }
    
    /* Called before each frame is rendered */
    NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] init];
    for (SKSpriteNode *glimmer in _glimmers) {
       
        [self moveSprite:glimmer velocity:CGPointMake(0, -GLIMMER_MOVE_PER_SEC)];
        
        if(glimmer.position.y < 10.0){
            NSUInteger fooIndex = [_glimmers indexOfObject: glimmer];
            [indexes addIndex:(fooIndex)];
            [glimmer removeFromParent];
            
            [_child miss];
            
            SKAction *moveAction = [SKAction playSoundFileNamed:@"Char-Miss.aifc" waitForCompletion:NO];
            [self runAction:moveAction];
            
            _multiplier = 1;
            _multiplierLabel.text = [NSString stringWithFormat:@"x%li", (long)_multiplier];
            _lives--;
            _lifeLabel.text = [NSString stringWithFormat:@"Lives: %li", (long)_lives];
            
            //WALK = 250.0;
            //DASH = 500.0;
            //GLIMMER_MOVE_PER_SEC = 120.0;
            
            if(_lives < 1){
                
                _gameOver = YES;
                [timer invalidate];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                int highScore = [defaults integerForKey:@"score"];
                if(highScore < _score){
                    [defaults setInteger:_score forKey:@"score"];
                }
                
                [defaults setInteger:_score forKey:@"last_score"];
                
                [defaults synchronize];
                
                // 1
                SKScene * gameOverScene =
                [[GameOverScene alloc] initWithSize:self.size];
                // 2
                SKTransition *reveal =
                [SKTransition fadeWithDuration:0.5];
                reveal.pausesOutgoingScene = YES;
                reveal.pausesIncomingScene = NO;
                // 3
                [self.view presentScene:gameOverScene transition:reveal];
                [_backgroundMusicPlayer stop];
            }
        }
        
    }
    [_glimmers removeObjectsAtIndexes:indexes];
    
    [self checkCollisions];
    
}



-(void)moveSprite:(SKSpriteNode*)glimmer
            velocity:(CGPoint)velocity
{
    // 1
    CGPoint amountToMove = CGPointMake(velocity.x * _dt, velocity.y * _dt);
    // 2
    glimmer.position = CGPointMake(glimmer.position.x + amountToMove.x, glimmer.position.y + amountToMove.y);
    
}

- (void)moveChildToward:(CGPoint)location {
    
    CGPoint offset = CGPointMake(location.x - _child.position.x, location.y - _child.position.y);
    
    CGFloat length = sqrtf(offset.x * offset.x + offset.y * offset.y);
    
    CGPoint direction = CGPointMake(offset.x / length, offset.y / length);
    
    _velocity = CGPointMake(direction.x * CHILD_MOVE_PER_SECOND,
                direction.y * CHILD_MOVE_PER_SECOND);
}

@end
