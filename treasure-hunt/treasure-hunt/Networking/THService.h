//
//  THService.h
//  treasure-hunt
//
//  Created by De MicheliStefano on 04.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THService : NSObject

@property (nonatomic, readonly) NSURL *baseUrl;

- (void)moveInDirection:(NSString *)direction response:(void (^)(NSObject *room))response;
- (void)moveInDirection:(NSString *)direction nextRoom:(NSString *)nextRoomId response:(void (^)(NSObject *room))response;
- (void)sellTreasureWithName:(NSString *)treasureName response:(void (^)(NSObject *room))response;
- (void)takeTreasureWithName:(NSString *)treasureName response:(void (^)(NSObject *room))response;
- (void)checkInventoryWithResponse:(void (^)(NSObject *room))response;

@end

NS_ASSUME_NONNULL_END
