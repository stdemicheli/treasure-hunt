//
//  THStatus.h
//  treasure-hunt
//
//  Created by De MicheliStefano on 04.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THStatus : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, readonly) float cooldown;
@property (nonatomic, readonly) int encumbrance;
@property (nonatomic, readonly) int strength;
@property (nonatomic, readonly) int speed;
@property (nonatomic, readonly) int gold;
@property (nonatomic, strong) NSArray *inventory;
@property (nonatomic, strong) NSArray *status;
@property (nonatomic, strong) NSArray *errrors;
@property (nonatomic, strong) NSArray *messages;

- (instancetype) initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
