//
//  ItemDetailViewController.h
//  Glimmer
//
//  Created by Gavin Potts on 12/9/13.
//  Copyright (c) 2013 Gavin Potts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemDetailViewController : UIViewController
{
    IBOutlet UILabel *priceLabel;
    IBOutlet UILabel *itemLabel;
    IBOutlet UIImageView *itemImage;
    
}
- (IBAction)closeDetail:(id)sender;
@end
