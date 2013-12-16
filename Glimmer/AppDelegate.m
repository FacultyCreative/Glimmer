//
//  AppDelegate.m
//  Glimmer
//
//  Created by Gavin Potts on 11/25/13.
//  Copyright (c) 2013 Gavin Potts. All rights reserved.
//

#import "AppDelegate.h"
#import <TestFlightSDK/TestFlight.h>

@implementation AppDelegate
{
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // start of your application:didFinishLaunchingWithOptions // ...
    self.window.backgroundColor = [UIColor blackColor];
    [TestFlight takeOff:@"7876795f-7c4b-425d-854d-04fc4e9bc232"];
    
    [NewRelicAgent startWithApplicationToken:@"AA2fd08763d5d73a7163579748e2bd74a5b380ff5d"];
    // The rest of your application:didFinishLaunchingWithOptions method
    // ...
    // Authenticate Player with Game Center
    
    //GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    // Handle the call back from Game Center Authentication
    //GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];

    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    NSLog(@"MEMORY LOW");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
