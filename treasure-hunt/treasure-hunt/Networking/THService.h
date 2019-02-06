//
//  THService.h
//  treasure-hunt
//
//  Created by De MicheliStefano on 04.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THRoom.h"
#import "THStatus.h"

NS_ASSUME_NONNULL_BEGIN

@interface THService : NSObject

- (void)initializeWithCompletion:(void (^)(THRoom *room, NSError *error))completion;
- (void)moveInDirection:(NSString *)direction roomId:(NSString *)roomId completion:(void (^)(THRoom *room, NSError *error))completion;
- (void)moveInDirection:(NSString *)direction completion:(void (^)(THRoom *room, NSError *error))completion;
- (void)sellTreasureWithName:(NSString *)treasureName completion:(void (^)(THRoom *room, NSError *error))completion;
- (void)takeTreasureWithName:(NSString *)treasureName completion:(void (^)(THRoom *room, NSError *error))completion;
- (void)dropTreasureWithName:(NSString *)treasureName completion:(void (^)(THRoom *room, NSError * error))completion;
- (void)checkInventoryWithResponse:(void (^)(THStatus *status, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
