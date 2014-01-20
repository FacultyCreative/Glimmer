//
//  AidListener.m
//  AidArcadeDemoApp
//
//  Created by Gavin Potts on 10/24/13.
//  Copyright (c) 2013 Gavin Potts. All rights reserved.
//

#import "AidListener.h"
#import <Parse/Parse.h>

@implementation AidListener
{
    SKProductsRequest *_productsRequest;
}

+ (AidListener *)sharedInstance {
    // Override point for customization after application launch.
    [Parse setApplicationId:@"YtYzZ88hF4THKdQcZDwWXdL0fJhgrVxJhrJ1vHnW"
                  clientKey:@"2ki4NvWRdNMfMT6E67s2fCYu50SwYruIKyZ4DXcG"];
    static dispatch_once_t once;
    static AidListener * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    
    for (SKProduct * skProduct in skProducts) {
        
        PFObject *testObject = [PFObject objectWithClassName:@"Purchase"];
        
        [testObject setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"] forKey:@"App"];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        [testObject setObject:skProduct.productIdentifier forKey:@"ProductID"];
        [testObject setObject:skProduct.price forKey:@"Price"];
        [testObject saveInBackground];
    }
}

-(void)processPurchase:(SKPaymentTransaction*)transaction
{
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects:transaction.payment.productIdentifier, nil]];
    _productsRequest.delegate = self;
    [_productsRequest start];
}

@end
