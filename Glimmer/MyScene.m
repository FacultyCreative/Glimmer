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
#import "BackgroundSprite.h"
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import "ContinueScene.h"

float const SCORE_PER_GLIMMER = 100.0;
float const LEVEL_THRESHOLD = 5.0;
float const BASE_WALK = 300.0;
float const BASE_DASH = 600.0;
float const BASE_CHILD_MOVE = 300.0;
float const BASE_GLIMMER = 170.0;
float const LEVEL_MAX = 11;
float const BASE_BONUS_COUNT = 20;
float const MULTI = 1.13;

@implementation MyScene
{
    ChildSprite *_child;
    NSTimeInterval  _lastUpdateTime;
    NSTimeInterval _dt;
    CGPoint _velocity;
    
    float GLIMMER_MOVE_PER_SEC;
    float GLIMMER_MOVE_PRE_BONUS;
    float CHILD_MOVE_PER_SECOND;
    float DASH;
    float WALK;
    float LEVEL_COUNT;
    float GAP;
    float LEVEL;
    float musicRate;
    
    BOOL isBonus;
    float bonusCount;
    
    int nextBlueCounter;
    int nextBlue;
    int nextRedCounter;
    int nextRed;
    int highMulti;
    int lastMulti;
    int lastScore;
    int highScore;
    int maxLevel;
    
    BOOL _gameOver;
    BOOL _firstTouch;
    
    NSNumberFormatter *_formatter;
    NSMutableArray *_glimmers;
    SKNode *_glimmerParent;
    SKNode *_particleParent;
    SKNode *_HUD;
    //SKEmitterNode *_glimmerEmitter;
    NSMutableArray *_hearts;
    NSMutableArray *_comboBlips;
    NSInteger _maxGlimmers;
    SKLabelNode *_scoreLabel;
    SKLabelNode *_lifeLabel;
    SKLabelNode *_multiplierLabel;
    SKLabelNode *_startLabel;
    SKSpriteNode *_helpOverlay;
    SKSpriteNode *_pauseOverlay;
    NSInteger _multiplier;
    NSInteger _score;
    NSInteger _lives;
    AVAudioPlayer *_backgroundMusicPlayer;
    SKSpriteNode *_moon;
    CGPoint lastPoint;
    NSInteger lastX;
    SKAction *resetFigure;
    SKSpriteNode *btn;
    NSTimer *timer;
    
}

@synthesize publicHearts = _publicHearts;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        isBonus = NO;
        bonusCount = BASE_BONUS_COUNT;
        DASH = BASE_DASH;
        WALK = BASE_WALK;
        CHILD_MOVE_PER_SECOND = BASE_CHILD_MOVE;
        GLIMMER_MOVE_PER_SEC = BASE_GLIMMER;
        GLIMMER_MOVE_PRE_BONUS = BASE_GLIMMER;
        LEVEL_COUNT = 1.0;
        _firstTouch = NO;
        _gameOver = NO;
        nextRed = (arc4random() % 5) + 5;
        nextBlue = (arc4random() % 25) + 10;
        nextRedCounter = 0;
        nextBlueCounter = 0;
        maxLevel = 0;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        highMulti = [defaults integerForKey:@"multiplier"];
        highScore = [defaults integerForKey:@"score"];
        lastMulti = 0;
        lastScore = 0;
        LEVEL = 0;
        musicRate = 1.0;
        
        /* Setup your scene here */
        
        
        
        lastX = 1;
        
        _formatter = [[NSNumberFormatter alloc] init];
        NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
        [_formatter setGroupingSeparator:groupingSeparator];
        [_formatter setGroupingSize:3];
        [_formatter setAlwaysShowsDecimalSeparator:NO];
        [_formatter setUsesGroupingSeparator:YES];
        
        SKNode *staticEls = [[SKNode alloc] init];
        
        BackgroundSprite *bg = [[BackgroundSprite alloc] init];
        [bg setBlendMode:SKBlendModeReplace];
        [staticEls addChild:bg];
        
        [self addChild:staticEls];
        
        _moon = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"moon-pause"]];
        [_moon setScale:0.5];
        _moon.position = CGPointMake(size.width - _moon.size.width, size.height - 30.0);
        [self addChild:_moon];
        
        
        
        
        SKSpriteNode *bg3 =
        [SKSpriteNode spriteNodeWithTexture:SPRITEBUNDLE_TEX_CONTROLS_BUTTONS];
        bg3.position = CGPointMake(size.width/2, 45.0);
        
        [self addChild:bg3];
        
        btn = [SKSpriteNode spriteNodeWithTexture:SPRITEBUNDLE_TEX_CONTROLS_BUTTONS_PRESSED];
        btn.position = CGPointMake(20.0, 20.0);
        [self addChild:btn];
        btn.alpha = 0.0;
        
        _maxGlimmers = 20;
        _multiplier = 1;
        _score = 0;
        _lives = 5;
        _glimmers = [[NSMutableArray alloc] initWithCapacity:5];
        
        _HUD = [[SKNode alloc] init];
        
        
        
        _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Dosis-Regular"];
        _scoreLabel.text = @"0";
        _scoreLabel.fontColor = [UIColor yellowColor];
        _scoreLabel.fontSize = 30;
        _scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        _scoreLabel.position = CGPointMake( 10.0, size.height - 25.0 - _scoreLabel.frame.size.height);
        
        [_HUD addChild:_scoreLabel];
        
        _multiplierLabel = [SKLabelNode labelNodeWithFontNamed:@"Dosis-Regular"];
        _multiplierLabel.text = @"x1";
        _multiplierLabel.fontSize = 15;
        _multiplierLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        _multiplierLabel.position = CGPointMake( _scoreLabel.frame.size.width + _scoreLabel.frame.origin.x, _scoreLabel.frame.origin.y + 5.0);
        
        [_HUD addChild:_multiplierLabel];
        
        [self addChild:_HUD];
        
        [self setPublicHearts:5];
        
        SKSpriteNode *heart = [SKSpriteNode spriteNodeWithImageNamed:@"life-gauge"];
        [heart setScale:0.5];
        heart.anchorPoint = CGPointMake(heart.anchorPoint.x, 1);
        heart.position = CGPointMake(19.0, 498);
        [_HUD addChild:heart];
        
        _comboBlips = [[NSMutableArray alloc] init];
        
        SKSpriteNode *combo = [SKSpriteNode spriteNodeWithImageNamed:@"combo-gauge"];
        combo.anchorPoint = CGPointMake(combo.anchorPoint.x, 1);
        [combo setScale:0.5];
        combo.position = CGPointMake(19.0, heart.position.y - heart.size.height - 15);
        [_HUD addChild:combo];
        
        _glimmerParent = [[SKNode alloc] init];
        _particleParent = [[SKNode alloc] init];
        
        SKNode *childParent = [[SKNode alloc] init];
        
        _child = [ChildSprite spriteNodeWithTexture:SPRITEBUNDLE_TEX_CHAR_REGULAR_STAND_CHAR_STAND_RIGHT size:CGSizeMake(100, 150)];
        _child.name = @"child";
        [childParent addChild:_child];
        _child.position = CGPointMake(-_child.size.width/2, 170.0);
        [_child walk];
        
        lastPoint = CGPointMake(130.0, 170.0);
        
        [self addChild:childParent];
        
        [self addChild:_glimmerParent];
        
        
        
        [self addChild:_particleParent];
        
        _startLabel = [SKLabelNode labelNodeWithFontNamed:@"Dosis-Regular"];
        _startLabel.text = @"TAP TO START";
        _startLabel.fontColor = [UIColor whiteColor];
        _startLabel.fontSize = 20;
        _startLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        _startLabel.position = CGPointMake( size.width/2, size.height/2 - 100);
        _helpOverlay = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"overlay_help"]];
        
        _helpOverlay.anchorPoint = CGPointMake(0, 0);
        [self addChild:_helpOverlay];
        [self addChild:_startLabel];
        
        SKAction *fadeOutLabel = [SKAction fadeOutWithDuration:1];
        SKAction *fadeInLabel = [SKAction fadeInWithDuration:1];
        SKAction *fader = [SKAction sequence:@[fadeOutLabel, fadeInLabel]];
        SKAction *faderRepeat = [SKAction repeatActionForever:fader];
        [_startLabel runAction:faderRepeat];
        
        SKAction *wait = [SKAction waitForDuration:0.3];
        
        _pauseOverlay = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"overlay_pause"]];
        _pauseOverlay.anchorPoint = CGPointMake(0, 0);
        
        [self runAction:wait completion:^{
            [self moveChildToward:lastPoint];
        }];
    }
    return self;
}



- (void)playBackgroundMusic:(NSString *)filename {
    
    NSError *error;
    NSURL *backgroundMusicURL = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    _backgroundMusicPlayer = [[AVAudioPlayer alloc]
                              initWithContentsOfURL:backgroundMusicURL error:&error]; _backgroundMusicPlayer.numberOfLoops = -1; [_backgroundMusicPlayer prepareToPlay];
    _backgroundMusicPlayer.enableRate = YES;
    //[_backgroundMusicPlayer play];
}

- (void)setPublicHearts:(NSInteger)h
{
    _lives = h;
    _hearts = [[NSMutableArray alloc] init];
    
    for (float i=0; i < _lives; i++) {
        SKSpriteNode *heart = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"life-gauge-tick"]];
        [heart setScale:0.5];
        heart.anchorPoint = CGPointMake(heart.anchorPoint.x, 1);
        heart.position = CGPointMake(19.0, _scoreLabel.position.y - 20 - heart.size.height * i - i/2.0f);
        NSLog(@"HEART: %f", heart.position.y);
        [_HUD addChild:heart];
        [_hearts addObject:heart];
    }
    
}

- (void)drawHearts{
    
}

- (void)glimmerDeath:(GlimmerSprite*)glimmer {
    
    [glimmer removeFromParent];
    
    [_glimmers removeObject:glimmer];
    
    if(glimmer.type != 3){
    
        if(glimmer.type == 2){
            for (GlimmerSprite *g in _glimmers) {
                [g removeFromParent];
            }
            [_glimmers removeAllObjects];
            isBonus = YES;
            bonusCount = BASE_BONUS_COUNT;
        }
        
        if(!glimmer.isBonus){
            _multiplier++;
        }
        
        if(highMulti < _multiplier){
            highMulti = _multiplier;
        }
        
        if(lastMulti < _multiplier){
            lastMulti = _multiplier;
        }

        _score += SCORE_PER_GLIMMER * _multiplier;
        _scoreLabel.text = [_formatter stringFromNumber:[NSNumber numberWithInt:_score]];
        _multiplierLabel.text = [NSString stringWithFormat:@"x%li", (long)_multiplier];
        _multiplierLabel.position = CGPointMake( _scoreLabel.frame.size.width + _scoreLabel.frame.origin.x, _scoreLabel.frame.origin.y + 5.0);
        
        
        [_child catch];
        
        if(!glimmer.isBonus){
            LEVEL_COUNT++;
            
            if(fmodf(LEVEL_COUNT, LEVEL_THRESHOLD) == 1)
            {
                LEVEL++;
                
                if(LEVEL < LEVEL_MAX){
                    SKSpriteNode *comboBlip = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"combo-gauge-tick"]];
                    [comboBlip setScale:0.5];
                    comboBlip.position = CGPointMake(19.0, 410 + (comboBlip.size.height * [_comboBlips count]) + [_comboBlips count]/2.0f);
                    
                    [_comboBlips addObject:comboBlip];
                    [_HUD addChild:comboBlip];
                    WALK *= MULTI;
                    DASH *= MULTI;
                    GLIMMER_MOVE_PER_SEC = GLIMMER_MOVE_PRE_BONUS;
                    GLIMMER_MOVE_PER_SEC *= MULTI;
                    GLIMMER_MOVE_PRE_BONUS = GLIMMER_MOVE_PER_SEC;
                    
                }
                
                
                musicRate += 0.02;
                if(musicRate > 2){
                    musicRate = 2;
                }
                
                [_backgroundMusicPlayer setRate:musicRate];
            }
        }
        SKEmitterNode *_glimmerEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:
                           [[NSBundle mainBundle] pathForResource:@"glimmerDeath" ofType:@"sks"]];
        _glimmerEmitter.position = glimmer.position;
        [_particleParent addChild:_glimmerEmitter];

        _glimmerEmitter.name = @"engineEmitter";
        [_glimmerEmitter resetSimulation];
        
        SKAction *waitToRemove = [SKAction waitForDuration:0.5];
        [_particleParent runAction:waitToRemove completion:^{
            [_particleParent removeAllActions];
            [_glimmerEmitter removeFromParent];
        }];
        
        
         //SKLabelNode *scorePop = [[SKLabelNode alloc] initWithFontNamed:@"Dosis-Regular"];
         //int points = SCORE_PER_GLIMMER * _multiplier;
         /*scorePop.text = [NSString stringWithFormat:@"+%d", points];
         scorePop.fontSize = 30.0;
         scorePop.position = engineEmitter.position;
         [_HUD addChild:scorePop];
         SKAction *flyScore = [SKAction moveToY:self.size.height duration:0.25];
         SKAction *fade = [SKAction fadeAlphaTo:0.0 duration:0.5];
         SKAction *flyAndFade = [SKAction group:@[flyScore, fade]];
         [scorePop runAction:flyAndFade completion:^{
             [scorePop removeAllActions];
             [scorePop removeFromParent];
         }];*/
    } else {
        [self miss];
    }
}

- (void)checkCollisions {
    
    [_glimmerParent enumerateChildNodesWithName:@"glimmer"
                           usingBlock:^(SKNode *node, BOOL *stop){
                               
                               GlimmerSprite *glimmer = (GlimmerSprite *)node;
                               
                               if(glimmer.position.y < 180){
                                   CGRect smallerFrame = CGRectMake(_child.frame.origin.x, _child.frame.origin.y + 10, _child.frame.size.width - 10.0, 50.0);
                                   
                                   if (CGRectIntersectsRect(smallerFrame, glimmer.frame)) {
                                       
                                       [self glimmerDeath:glimmer];
    
                                   }
                                   
                               }
                           }];
}

-(void)makeNewGlimmer{
        if([_glimmers count] < _maxGlimmers){
            
            GlimmerSprite *glimmer;
            NSInteger idx = arc4random() % 2 + 1;
            glimmer = [GlimmerSprite spriteNodeWithTexture:SPRITEBUNDLE_TEX_GLIMMER_GLIMMER_WHITE
                                                      size:CGSizeMake(20.0, 20.0)];
            if(idx == 1){
                SKAction *rotation = [SKAction rotateByAngle: M_PI/2.0 duration:0];
                //and just run the action
                [glimmer runAction: rotation];
            }
            
            glimmer.type = 1;
            
            GAP = (((arc4random() % 100)/100.0f)*.5) + 0.5 - (LEVEL/2)*0.05;
            if(GAP < 0.25){
                GAP = 0.25;
            }
            
            if(isBonus && bonusCount > 0){
                glimmer.isBonus = YES;
                GLIMMER_MOVE_PER_SEC = BASE_GLIMMER * 3;
                _maxGlimmers = BASE_BONUS_COUNT;
                bonusCount --;
                GAP = 0.1;
                if(bonusCount == 0){
                    isBonus = NO;
                    bonusCount = BASE_BONUS_COUNT;
                    _maxGlimmers = 10;
                    GAP = 1;
                }
                
                glimmer.position = CGPointMake(_child.position.x, self.view.frame.size.height);
            } else {
                GLIMMER_MOVE_PER_SEC = GLIMMER_MOVE_PRE_BONUS;
                if(nextBlueCounter == nextBlue){
                    
                    nextBlue = (arc4random() % 25) + 25;
                    nextBlueCounter = 0;
                    [glimmer setColor:[SKColor colorWithRed:0.164705882 green:.764705882 blue:.941176471 alpha:1]];
                    [glimmer setColorBlendFactor:1.0];
                    glimmer.type = 2;
                    

                } else if(nextRedCounter == nextRed){
                    nextRed = (arc4random() % 3) + 7;
                    nextRedCounter = 0;
                    [glimmer setColor:[SKColor redColor]];
                    [glimmer setColorBlendFactor:1.0];
                    glimmer.type = 3;
                } else {
                    nextRedCounter++;
                    nextBlueCounter++;
                    
                }
                
                NSInteger r = arc4random()%4 + 1;
                
                glimmer.position = CGPointMake(r * (self.view.frame.size.width / 4) - ((self.view.frame.size.width / 4)/2), self.view.frame.size.height);
            }
            
            
            [self moveSprite:glimmer toward:CGPointMake(glimmer.position.x, 0)];
            
            glimmer.name = @"glimmer";
            
            SKEmitterNode *engineEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:
                                            [[NSBundle mainBundle] pathForResource:@"GlimmerGlow" ofType:@"sks"]];
            engineEmitter.position = CGPointMake(1, -4); engineEmitter.name = @"engineEmitter";
            [glimmer addChild:engineEmitter];
            
            [_glimmers addObject:glimmer];
            
            [_glimmerParent addChild:glimmer];
        }
    
    [timer invalidate];
    timer = [NSTimer timerWithTimeInterval:GAP target:self selector:@selector(makeNewGlimmer) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    
}

-(void)togglePause
{
    if(self.paused){
        [self unpause];

    } else {
        [self pause];
    }
}

-(void)unpause
{
    self.paused = NO;
    timer = [NSTimer timerWithTimeInterval:GAP target:self selector:@selector(makeNewGlimmer) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [_backgroundMusicPlayer play];
    [_moon setTexture:[SKTexture textureWithImageNamed:@"moon-pause"]];
    [_pauseOverlay removeFromParent];
}

-(void)pause{
    self.paused = YES;
    [timer invalidate];
    [_backgroundMusicPlayer pause];
    _lastUpdateTime = 0;
    _dt = 0;
    [_moon setTexture:[SKTexture textureWithImageNamed:@"moon-play"]];
    [self addChild:_pauseOverlay];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
   
    /* Called when a touch begins */
    
    if(!_firstTouch){
        
        SKAction *fadeLabel = [SKAction fadeAlphaTo:0.0 duration:0.5];
        [_startLabel runAction:fadeLabel completion:^{
            [_startLabel removeAllActions];
            [_startLabel removeFromParent];
        }];
        
        [_helpOverlay runAction:fadeLabel completion:^{
            [_helpOverlay removeAllActions];
            [_helpOverlay removeFromParent];
        }];
        
        GAP = 0.75;
        timer = [NSTimer timerWithTimeInterval:GAP target:self selector:@selector(makeNewGlimmer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        [self playBackgroundMusic:@"528414_Robotic-Toothpaste.aifc"];
        
        _firstTouch = YES;
        
    }
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        
        
        // If the user taps on BACK Button Rectangle
        if (CGRectContainsPoint(_moon.frame, location))
        {
            [self togglePause];
        } else if(self.isPaused) {
            
            if(CGRectContainsPoint(CGRectMake(0, 55, 320, 95), location)){
                [self unpause];
            }
        
        } else {
            
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
}

-(void)update:(CFTimeInterval)currentTime {
    
    if(!self.paused){
        /* Called before each frame is rendered */
        //NSLog(@"UPDATE");
        if (_lastUpdateTime) {
            _dt = currentTime - _lastUpdateTime;
        } else {
            _dt = 0;
        }
        _lastUpdateTime = currentTime;
        
        CGPoint offset = CGPointMake(lastPoint.x - _child.position.x, lastPoint.y - _child.position.y);
        CGFloat length = sqrtf(offset.x * offset.x + offset.y * offset.y);
        
        if(length > 5 && _velocity.x != 0){
            [self moveSprite:_child velocity:_velocity];
            [self boundsCheckPlayer];
        } else {
            
            if(_velocity.x != 0){
                [_child setPosition:lastPoint];
                _velocity = CGPointMake(0, 0);
                
                [_child resetCharacter];
            }
        }
        
        
        for (GlimmerSprite *glimmer in _glimmers) {
            if(glimmer.isBonus){
                [self moveSprite:glimmer toward:CGPointMake(_child.position.x, _child.position.y - 20)];
                [self moveSprite:glimmer velocity:glimmer.velocity];
            } else {
                [self moveSprite:glimmer velocity:CGPointMake(0, -GLIMMER_MOVE_PER_SEC)];
            }
            
            
        }
    }
    
}

- (void)didEvaluateActions
{
    
    if(!self.paused){
        [self checkCollisions];
        
        NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] init];
        for (GlimmerSprite *glimmer in _glimmers) {
            if(glimmer.position.y < 10.0){
                NSUInteger fooIndex = [_glimmers indexOfObject: glimmer];
                [indexes addIndex:(fooIndex)];
                [glimmer removeFromParent];
                
                if(glimmer.type != 3){
                    [self miss];
                }
                
            }
        }
        [_glimmers removeObjectsAtIndexes:indexes];
    }

}

-(void)miss
{
    
    [_child miss];
    
    SKAction *pulseRed = [SKAction sequence:@[
                                              [SKAction waitForDuration:0.1],
                                              [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0 duration:0.15],
                                              [SKAction waitForDuration:0.1],
                                              [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0 duration:0.15],
                                              [SKAction colorizeWithColorBlendFactor:0.0 duration:0.15]]];
    [_child runAction:pulseRed];
    
    SKAction *missAction = [SKAction playSoundFileNamed:@"Char-Miss.aifc" waitForCompletion:NO];
    
    [self runAction:missAction];
    
    _multiplier = 1;
    _multiplierLabel.text = [NSString stringWithFormat:@"x%li", (long)_multiplier];
    
    for (SKSpriteNode *blip in _comboBlips) {
        [blip removeFromParent];
    }
    
    [_comboBlips removeAllObjects];
    
    DASH = BASE_DASH;
    WALK = BASE_WALK;
    CHILD_MOVE_PER_SECOND = BASE_CHILD_MOVE;
    GLIMMER_MOVE_PER_SEC = BASE_GLIMMER;
    GLIMMER_MOVE_PRE_BONUS = BASE_GLIMMER;
    LEVEL_COUNT = 1.0;
    
    LEVEL = 0;
    
    _lives--;
    
    musicRate = 1.0;
    [_backgroundMusicPlayer setRate:musicRate];
    
    
    if(_lives >= 0){
        SKSpriteNode *heart = [_hearts objectAtIndex:0];
        
        SKEmitterNode *engineEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:
                                        [[NSBundle mainBundle] pathForResource:@"HeartPop" ofType:@"sks"]];
        engineEmitter.position = heart.position;
        engineEmitter.name = @"engineEmitter";
        [_glimmerParent addChild:engineEmitter];
        [engineEmitter resetSimulation];
        
        [heart removeFromParent];
        [_hearts removeObjectAtIndex:0];
    }
    
    if(_lives < 1){
        
        _gameOver = YES;
        
        [timer invalidate];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if(highScore < _score){
            [defaults setInteger:_score forKey:@"score"];
        }
        
        [defaults setInteger:_score forKey:@"last_score"];
        
        if(highMulti < _multiplier){
            [defaults setInteger:_multiplier forKey:@"multiplier"];
        }
        
        if(lastMulti < _multiplier){
            [defaults setInteger:_multiplier forKey:@"last_multiplier"];
        } else {
            [defaults setInteger:lastMulti forKey:@"last_multiplier"];
        }
        
        [defaults synchronize];
        
        [defaults setInteger:_score forKey:@"last_score"];
        
        [defaults synchronize];
        
        for (SKSpriteNode *glimmer in _glimmers) {
            if(![glimmer isHidden]){
                SKEmitterNode *engineEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:
                                                [[NSBundle mainBundle] pathForResource:@"glimmerDeath" ofType:@"sks"]];
                engineEmitter.position = glimmer.position;
                engineEmitter.name = @"engineEmitter";
                [_glimmerParent addChild:engineEmitter];
                [engineEmitter resetSimulation];
                [glimmer setHidden:YES];
                [glimmer removeFromParent];
            }
        }
        
        
        SKAction *waitForGameOver = [SKAction waitForDuration:0.5];
        [self runAction:waitForGameOver completion:^{
            
            //[_backgroundMusicPlayer stop];
            // 1
            GAP = 0.75;
            [self pause];
            [_glimmers removeAllObjects];

            ContinueScene *continueScene = [[ContinueScene alloc] initWithSize:self.size];
            continueScene.gameScene = self;
            // 2
            SKTransition *reveal =
            [SKTransition fadeWithDuration:0.5];
            
            [self.view presentScene:continueScene transition:reveal];
        }];
    }
}

-(void)moveSprite:(SKSpriteNode*)glimmer
            velocity:(CGPoint)velocity
{
    CGPoint amountToMove = CGPointMake(velocity.x * _dt, velocity.y * _dt);
    glimmer.position = CGPointMake(glimmer.position.x + amountToMove.x, glimmer.position.y + amountToMove.y);
}


-(void)moveSprite:(GlimmerSprite*)glimmer toward:(CGPoint)location{
    CGPoint offset = CGPointMake(location.x - glimmer.position.x, location.y - glimmer.position.y);
    
    CGFloat length = sqrtf(offset.x * offset.x + offset.y * offset.y);
    
    CGPoint direction = CGPointMake(offset.x / length, offset.y / length);
    
    glimmer.velocity = CGPointMake(direction.x * GLIMMER_MOVE_PER_SEC,
                            direction.y * GLIMMER_MOVE_PER_SEC);
}

- (void)moveChildToward:(CGPoint)location {
    
    CGPoint offset = CGPointMake(location.x - _child.position.x, location.y - _child.position.y);
    
    CGFloat length = sqrtf(offset.x * offset.x + offset.y * offset.y);
    
    CGPoint direction = CGPointMake(offset.x / length, offset.y / length);
    
    _velocity = CGPointMake(direction.x * CHILD_MOVE_PER_SECOND,
                direction.y * CHILD_MOVE_PER_SECOND);
}

- (void)boundsCheckPlayer {
    // 1
    CGPoint newPosition = _child.position;
    CGPoint newVelocity = _velocity;
    
    if(newPosition.x > lastPoint.x && [_child.direction isEqualToString:@"right"]){
        newVelocity = CGPointMake(0, 0);
        _child.position = lastPoint;
        [_child resetCharacter];
    }
    if(newPosition.x < lastPoint.x && [_child.direction isEqualToString:@"left"]){
        newVelocity = CGPointMake(0, 0);
        _child.position = lastPoint;
        [_child resetCharacter];
    }
    _velocity = newVelocity;
    
}

@end
