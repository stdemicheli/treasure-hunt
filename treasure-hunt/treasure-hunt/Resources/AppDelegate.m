//
//  AppDelegate.m
//  treasure-hunt
//
//  Created by De MicheliStefano on 04.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

#import "AppDelegate.h"
#import "THExploration.h"
#import "THService.h"
#import "THHunt.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    THExploration *exploration = [[THExploration alloc] init];
//    THService *service = [[THService alloc] init];
//    [exploration setNetworkService:service];
//
//    [exploration initializeExploration];
    THHunt *hunt = [THHunt new];
    NSArray *shortestPath = [NSArray new];
    NSNumber *room = [[NSNumber alloc] initWithInteger:479];
    [hunt findShortestPathToRoom:room completion:^(NSArray * shortestPath) {
        NSArray *shortpath = shortestPath;
    }];
    
    
    return YES;
}

@end
