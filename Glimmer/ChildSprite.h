//
//  ChildSprite.h
//  Glimmer
//
//  Created by Gavin Potts on 11/26/13.
//  Copyright (c) 2013 Gavin Potts. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ChildSprite : SKSpriteNode
@property (strong, nonatomic) NSString *direction;

-(void)resetCharacter;

-(void)miss;

-(void)catch;

-(void)dash;

-(void)walk;

@end
