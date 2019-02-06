//
//  THExploration.h
//  treasure-hunt
//
//  Created by De MicheliStefano on 04.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THService.h"
#import "THRoom.h"

NS_ASSUME_NONNULL_BEGIN

@interface THExploration : NSObject

@property (nonatomic, strong) THService *networkService;
@property (nonatomic, readonly) NSArray *traversalPath;
@property (nonatomic, readonly) NSDictionary *traversalGraph;
@property (nonatomic, readonly) NSArray *traversedPath;

- (void)initializeExploration;
- (void)explore;
- (void)traverseForwardInDirection:(NSString *)direction fromRoom:(THRoom *)prevRoom;
- (void)traverseBackInDirection;
- (void)traverseInRandomDirection;
- (void)pickUpTreasure;
- (void)sellTreasure;

@end

NS_ASSUME_NONNULL_END
