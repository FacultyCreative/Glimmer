//
//  ItemDetailViewController.h
//  Glimmer
//
//  Created by Gavin Potts on 12/9/13.
//  Copyright (c) 2013 Gavin Potts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
@interface ItemDetailViewController : UIViewController
{
    IBOutlet UILabel *priceLabel;
    IBOutlet UILabel *itemLabel;
    IBOutlet UILabel *gameEffect;
    IBOutlet UILabel *realEffect;
    IBOutlet UILabel *gameEffectTitle;
    IBOutlet UILabel *realEffectTitle;
    IBOutlet UIButton *purchase;
    IBOutlet UIImageView *itemImage;
    
}
- (IBAction)closeDetail:(id)sender;
@property (strong, nonatomic) SKProduct *product;
@end
