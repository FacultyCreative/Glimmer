//
//  AidArcadeIAPHelper.m
//  AidArcadeDemoApp
//
//  Created by Gavin Potts on 10/24/13.
//  Copyright (c) 2013 Gavin Potts. All rights reserved.
//

#import "AidArcadeIAPHelper.h"

@implementation AidArcadeIAPHelper

+ (AidArcadeIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static AidArcadeIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"medicine",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end