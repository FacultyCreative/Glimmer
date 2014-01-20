//
//  AidListener.h
//  AidArcadeDemoApp
//
//  Created by Gavin Potts on 10/24/13.
//  Copyright (c) 2013 Gavin Potts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface AidListener : NSObject <SKProductsRequestDelegate>

+ (AidListener *)sharedInstance;

-(void)processPurchase:(SKPaymentTransaction*)transaction;

@end
