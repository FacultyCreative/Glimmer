//
//  DosisLabel.m
//  Glimmer
//
//  Created by Gavin Potts on 1/3/14.
//  Copyright (c) 2014 Gavin Potts. All rights reserved.
//

#import "DosisLabel.h"

@implementation DosisLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) awakeFromNib{
    
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"Dosis-Regular" size: self.font.pointSize];
    
    //set other settings of the custom label here (colour, etc.)
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
