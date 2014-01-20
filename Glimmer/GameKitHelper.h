//
//  GameKitHelper.h
//  Glimmer
//
//  Created by Gavin Potts on 12/19/13.
//  Copyright (c) 2013 Gavin Potts. All rights reserved.
//

@import GameKit;

extern NSString *const PresentAuthenticationViewController;

@interface GameKitHelper : NSObject <GKGameCenterControllerDelegate>
@property (nonatomic, readonly)
UIViewController *authenticationViewController;
@property (nonatomic, readonly) NSError *lastError; + (instancetype)sharedGameKitHelper;
- (void)authenticateLocalPlayer;
- (void)reportScore:(int64_t)score forLeaderboardID:(NSString*)leaderboardID;
- (void)showGKGameCenterViewController: (UIViewController *)viewController;
@end