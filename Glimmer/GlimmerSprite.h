//
//  GlimmerSprite.h
//  Glimmer
//
//  Created by Gavin Potts on 11/25/13.
//  Copyright (c) 2013 Gavin Potts. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GlimmerSprite : SKSpriteNode

@property int type;
@property CGPoint destination;
@property CGPoint velocity;
@property BOOL isBonus;

@end
