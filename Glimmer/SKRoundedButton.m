//
//  SKRoundedButton.m
//  Glimmer
//
//  Created by Gavin Potts on 1/2/14.
//  Copyright (c) 2014 Gavin Potts. All rights reserved.
//

#import "SKRoundedButton.h"

@implementation SKRoundedButton

+ (SKRoundedButton*)rectangleWithRect: (CGRect)rect
                         cornerRadius: (CGFloat)radius
                          borderColor:  (UIColor*)borderColor
                            fillColor:  (UIColor*)fillColor
                          borderWidth:  (CGFloat)borderWidth
                             fontName:  (NSString*)fontName
                                 text: (NSString*)text
{
    
    
    SKSpriteNode *btn = [[SKSpriteNode alloc] init];
    btn.anchorPoint = CGPointMake(0, 0);
    [btn setColor:[UIColor clearColor]];
    
    SKRoundedRectangle *roundedRect = [SKRoundedRectangle rectangleWithRect:rect
                                                               cornerRadius:radius
                                                                borderColor:borderColor
                                                                  fillColor:fillColor
                                                                borderWidth:borderWidth];
    
    SKLabelNode *lbl = [SKLabelNode labelNodeWithFontNamed:fontName];
    lbl.text = text;
    lbl.fontColor = [UIColor whiteColor];
    lbl.fontSize = 20;
    lbl.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    lbl.position = CGPointMake(roundedRect.frame.size.width/2.0, roundedRect.frame.size.height/2 - lbl.frame.size.height/2);
    [btn addChild:roundedRect];
    [btn addChild:lbl];
    [btn setSize:rect.size];
    
    return (SKRoundedButton*)btn;
    
}

@end
