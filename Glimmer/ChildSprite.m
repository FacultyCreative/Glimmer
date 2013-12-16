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
        [self setTexture:SPRITEBUNDLE_TEX_CHAR_REGULAR_STAND_CHAR_STAND_LEFT];        
    } else {
        [self setTexture:SPRITEBUNDLE_TEX_CHAR_REGULAR_STAND_CHAR_STAND_RIGHT];
    }
    
}

-(void)miss
{
    //NSLog(@"MISS TEXTURE");
    [self removeAllActions];
    SKAction *miss;
    if([self.direction isEqualToString:@"left"]){
        
        miss = [SKAction animateWithTextures:@[SPRITEBUNDLE_TEX_CHAR_REGULAR_MISS_CHAR_MISS_LEFT] timePerFrame:1.0 resize:YES restore:NO];
        
    } else {
        miss = [SKAction animateWithTextures:@[SPRITEBUNDLE_TEX_CHAR_REGULAR_MISS_CHAR_MISS_RIGHT] timePerFrame:1.0 resize:YES restore:NO];
    }
    [self runAction:miss];
}

-(void)catch
{
    //NSLog(@"CATCH TEXTURE");

    [self removeAllActions];
    SKAction *catch;
    if([self.direction isEqualToString:@"left"]){
        
        catch = [SKAction animateWithTextures:@[SPRITEBUNDLE_TEX_CHAR_REGULAR_CATCH_CHAR_CATCH_LEFT] timePerFrame:1.0 resize:YES restore:NO];
        
    } else {
        catch = [SKAction animateWithTextures:@[SPRITEBUNDLE_TEX_CHAR_REGULAR_CATCH_CHAR_CATCH_RIGHT] timePerFrame:1.0 resize:YES restore:NO];
    }
    [self runAction:catch];
}

-(void)dash
{
    //NSLog(@"DASH TEXTURE");

    [self removeAllActions];
    SKAction *dash;

    if([self.direction isEqualToString:@"left"]){
         dash = [SKAction animateWithTextures:@[SPRITEBUNDLE_TEX_CHAR_REGULAR_ZOOM_CHAR_ZOOM_LEFT] timePerFrame:1.0 resize:YES restore:NO];
    } else {
        dash = [SKAction animateWithTextures:@[SPRITEBUNDLE_TEX_CHAR_REGULAR_ZOOM_CHAR_ZOOM_RIGHT] timePerFrame:1.0 resize:YES restore:NO];
    }
    [self runAction:dash];
}

-(void)walk
{
    //NSLog(@"WALK TEXTURE");

    [self removeAllActions];
    
    SKAction *walk;
    if([self.direction isEqualToString:@"left"]){
        walk = [SKAction animateWithTextures:SPRITEBUNDLE_ANIM_CHAR_REGULAR_RUN_LEFT_CHAR_RUN_LEFT timePerFrame:0.1 resize:YES restore:NO];
    } else {
        walk = [SKAction animateWithTextures:SPRITEBUNDLE_ANIM_CHAR_REGULAR_RUN_RIGHT_CHAR_RUN_RIGHT timePerFrame:0.1 resize:YES restore:NO];
    }
    SKAction *walking = [SKAction repeatActionForever:walk];
    [self runAction:walking];
}

@end
