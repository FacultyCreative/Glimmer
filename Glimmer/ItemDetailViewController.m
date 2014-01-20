//
//  ItemDetailViewController.m
//  Glimmer
//
//  Created by Gavin Potts on 12/9/13.
//  Copyright (c) 2013 Gavin Potts. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "AidArcadeIAPHelper.h"
#import <Security/Security.h>
#import "KeychainItemWrapper.h" 
#import "GSKeychain.h"
#import <QuartzCore/QuartzCore.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface ItemDetailViewController ()

@end

@implementation ItemDetailViewController

@synthesize product = _product;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [gameEffect setFont:[UIFont fontWithName:@"Dosis-Regular" size:15.0]];
    [realEffect setFont:[UIFont fontWithName:@"Dosis-Regular" size:15.0]];
    [gameEffectTitle setFont:[UIFont fontWithName:@"Dosis-Regular" size:15.0]];
    [realEffectTitle setFont:[UIFont fontWithName:@"Dosis-Regular" size:15.0]];
    [[purchase titleLabel] setFont:[UIFont fontWithName:@"Dosis-Regular" size:15.0]];
    [itemLabel setFont:[UIFont fontWithName:@"Dosis-Regular" size:15.0]];
    [priceLabel setFont:[UIFont fontWithName:@"Dosis-Regular" size:15.0]];
    
    purchase.layer.cornerRadius = 2;
    purchase.layer.borderWidth = 1;
    purchase.layer.borderColor = [UIColor whiteColor].CGColor;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeDetail:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)purchaseProduct:(id)sender
{
    NSLog(@"Product: %@", self.product.productIdentifier);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        [[AidArcadeIAPHelper sharedInstance] buyProduct:self.product];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    
}

- (void)productPurchased:(NSNotification *)notification {
    
    // Fetch existing pills
    NSString *pills = [[GSKeychain systemKeychain] secretForKey:@"Pills"];
    int continues = [pills intValue];
    continues += 5;
    [[GSKeychain systemKeychain] setSecret:[NSString stringWithFormat:@"%d", continues] forKey:@"Pills"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
