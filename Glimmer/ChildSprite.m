//
//  ChildSprite.m
//  Glimmer
//
//  Created by Gavin Potts on 11/26/13.
//  Copyright (c) 2013 Gavin Potts. All rights reserved.
//

#import "ChildSprite.h"
#import "sprites.h"

@implementation ChildSprite
-(id)init{
    self = [super init];
    
    if(self)
    {
        self.direction = @"left";
    }
    
    return self;
    
}

-(void)resetCharacter
{
    //NSLog(@"RESET TEXTURE");

    [self removeAllActions];
    
    if([self.direction isEqualToString:@"left"]){
        [self setTexture:SPRITEBUNDLE_TEX_CHAR_STAND_CHAR_STAND_LEFT];
    } else {
        [self setTexture:SPRITEBUNDLE_TEX_CHAR_STAND_CHAR_STAND_RIGHT];
    }
    
}

-(void)miss
{
    //NSLog(@"MISS TEXTURE");
    [self removeAllActions];
    if([self.direction isEqualToString:@"left"]){
        [self setTexture:SPRITEBUNDLE_TEX_CHAR_MISS_CHAR_MISS_LEFT];
    } else {
        [self setTexture:SPRITEBUNDLE_TEX_CHAR_MISS_CHAR_MISS_RIGHT];
    }
}

-(void)catch
{
    //NSLog(@"CATCH TEXTURE");

    [self removeAllActions];
    if([self.direction isEqualToString:@"left"]){
        [self setTexture:SPRITEBUNDLE_TEX_CHAR_CATCH_CHAR_CATCH_LEFT];
    } else {
        [self setTexture:SPRITEBUNDLE_TEX_CHAR_CATCH_CHAR_CATCH_RIGHT];
    }
}

-(void)dash
{
    //NSLog(@"DASH TEXTURE");

    [self removeAllActions];
    if([self.direction isEqualToString:@"left"]){
        [self setTexture:SPRITEBUNDLE_TEX_CHAR_ZOOM_CHAR_ZOOM_LEFT];
    } else {
        [self setTexture:SPRITEBUNDLE_TEX_CHAR_ZOOM_CHAR_ZOOM_RIGHT];
    }
}

-(void)walk
{
    //NSLog(@"WALK TEXTURE");

    [self removeAllActions];
    SKAction *walk;
    if([self.direction isEqualToString:@"left"]){
        walk = [SKAction animateWithTextures:SPRITEBUNDLE_ANIM_CHAR_RUN_LEFT_CHAR_RUN_LEFT timePerFrame:0.1];
    } else {
        walk = [SKAction animateWithTextures:SPRITEBUNDLE_ANIM_CHAR_RUN_RIGHT_CHAR_RUN_RIGHT timePerFrame:0.1];
    }
    SKAction *walking = [SKAction repeatActionForever:walk];
    [self runAction:walking];
}

@end
