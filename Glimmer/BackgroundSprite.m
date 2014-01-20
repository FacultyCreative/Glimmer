//
//  BackgroundSprite.m
//  Glimmer
//
//  Created by Gavin Potts on 12/7/13.
//  Copyright (c) 2013 Gavin Potts. All rights reserved.
//

#import "BackgroundSprite.h"

@implementation BackgroundSprite

-(id)init{
    self = [super init];
    
    if(self)
    {
        
        SKNode *bgParent = [[SKNode alloc] init];
        SKSpriteNode *bg = [SKSpriteNode
                               spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"background-composite-new"]];
        bg.position = CGPointMake(bg.size.width/2, bg.size.height/2);
        [bgParent addChild:bg];
        
//        SKSpriteNode *tree1 = [SKSpriteNode
//                               spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"tree-01"]];
//        tree1.position = CGPointMake(50.0, 168.0);
//        [tree1 setScale:0.5];
//        [bgParent addChild:tree1];
//        
//        SKSpriteNode *tree2 = [SKSpriteNode
//                               spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"tree-02"]];
//        tree2.position = CGPointMake(250.0, 165.0);
//        [tree2 setScale:0.5];
//        [bgParent addChild:tree2];
//        
//        SKSpriteNode *grass = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"grass"]];
//        [grass setScale:0.5];
//        grass.position = CGPointMake(grass.size.width/2, grass.size.height/2);
//        [bgParent addChild:grass];
//        
//        SKSpriteNode *stars = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"bg-top-stars"]];
//        [stars setScale:0.5];
//        stars.position = CGPointMake(stars.size.width/2, 568);
//        [bgParent addChild:stars];
        
        [self addChild:bgParent];
        
    }
    
    return self;
    
}

@end
