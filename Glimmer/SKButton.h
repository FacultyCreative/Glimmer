//
//  SKButton.h
//  Glimmer
//
//  Created by Gavin Potts on 12/8/13.
//  Copyright (c) 2013 Gavin Potts. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKButton : SKNode
{
    
    SKSpriteNode *mySprite;
    CGRect myRect;
    CGFloat myRadius;
    
}

@property (nonatomic, strong)SKSpriteNode *mySprite;
@property (nonatomic, assign)CGRect myRect;
@property (nonatomic, assign)CGFloat myRadius;

- (id)initWithTexture:(SKTexture *)texture;

@end
