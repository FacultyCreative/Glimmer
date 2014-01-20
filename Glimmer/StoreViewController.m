//
//  StoreViewController.m
//  Glimmer
//
//  Created by Gavin Potts on 12/8/13.
//  Copyright (c) 2013 Gavin Potts. All rights reserved.
//

#import "StoreViewController.h"
#import "AidArcadeIAPHelper.h"
#import "ItemDetailViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
@interface StoreViewController ()
{
    NSArray *_products;
    NSNumberFormatter * _priceFormatter;
}
@end

@implementation StoreViewController

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
    
        [self reload];

    
    
}

- (void)viewWillAppear:(BOOL)animated {
}



- (void)reload {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _products = nil;
    [[AidArcadeIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
            //NSLog(@"Products: %@", products);
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openProduct:(id)sender
{
    
    [self performSegueWithIdentifier:@"openProduct" sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ItemDetailViewController *productView = (ItemDetailViewController*)segue.destinationViewController;
    NSString *pID = [sender valueForKey:@"productID"];
    NSLog(@"pID: %@", pID);
    SKProduct *product = [[SKProduct alloc] init];
    for (SKProduct *p in _products) {
        
        if([p.productIdentifier isEqualToString:pID]){
            NSLog(@"Product: %@", p.productIdentifier);
            product = p;
        }
    }
    
    productView.product = product;
    NSLog(@"Product Before Segue: %@", productView.product);
    
}

- (IBAction)closeStore:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
