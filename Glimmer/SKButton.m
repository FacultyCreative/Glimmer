//
//  SKButton.m
//  Glimmer
//
//  Created by Gavin Potts on 12/8/13.
//  Copyright (c) 2013 Gavin Potts. All rights reserved.
//

#import "SKButton.h"

@implementation SKButton

@synthesize mySprite, myRect, myRadius;

- (id)init {
    
    // Use a default button image
    return [self initWithTexture:[SKTexture textureWithImageNamed:@"ButtonDefault.png"]];
    
}

- (id)initWithTexture:(SKTexture *)texture {
    
    self = [super init];
    if (self) {
        
        // Assumes there is a texture
        mySprite = [SKSpriteNode spriteNodeWithTexture:texture];
        [self addChild:mySprite];
        
        // Assumes the collision area is the size of the texture frame
        myRect = [mySprite frame];
        
        // Assumes the texture is square
        myRadius = myRect.size.width * 0.5;
        
    }
    
    return self;
    
}

- (CGRect)myRect {
    
    CGPoint pos = [self position];
    CGFloat originX = pos.x - (mySprite.size.width * 0.5);
    CGFloat originY = pos.y - (mySprite.size.height * 0.5);
    CGFloat width = mySprite.size.width;
    CGFloat height = mySprite.size.height;
    
    myRect = CGRectMake(originX, originY, width, height);
    
    return myRect;
    
}



@end
