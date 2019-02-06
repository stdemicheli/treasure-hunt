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
@property (nonatomic, readonly) NSNumber *cooldown;
@property (nonatomic, readonly) NSNumber *encumbrance;
@property (nonatomic, readonly) NSNumber *strength;
@property (nonatomic, readonly) NSNumber *speed;
@property (nonatomic, readonly) NSNumber *gold;
@property (nonatomic, strong) NSArray *inventory;
@property (nonatomic, strong) NSArray *status;
@property (nonatomic, strong) NSArray *errrors;
@property (nonatomic, strong) NSArray *messages;

- (instancetype) initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
