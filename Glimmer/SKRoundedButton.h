//
//  SKRoundedButton.h
//  Glimmer
//
//  Created by Gavin Potts on 1/2/14.
//  Copyright (c) 2014 Gavin Potts. All rights reserved.
//

#import "SKRoundedRectangle.h"

@interface SKRoundedButton : SKSpriteNode
+ (SKRoundedButton*)rectangleWithRect: (CGRect)rect
                         cornerRadius: (CGFloat)radius
                          borderColor:  (UIColor*)borderColor
                            fillColor:  (UIColor*)fillColor
                          borderWidth:  (CGFloat)borderWidth
                             fontName:  (NSString*)fontName
                                 text: (NSString*)text;

@end
