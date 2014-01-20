//
//  SKRoundedRectangle.h
//  Glimmer
//
//  Created by Gavin Potts on 12/27/13.
//  Copyright (c) 2013 Gavin Potts. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKRoundedRectangle : SKShapeNode
+ (SKRoundedRectangle*)rectangleWithRect: (CGRect)rect
                      cornerRadius: (CGFloat)radius
                       borderColor:  (UIColor*)borderColor
                         fillColor:  (UIColor*)fillColor
                       borderWidth:  (CGFloat)borderWidth;
@end
