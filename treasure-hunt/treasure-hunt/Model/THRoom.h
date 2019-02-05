//
//  THRoom.h
//  treasure-hunt
//
//  Created by De MicheliStefano on 04.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THRoom : NSObject

@property (nonatomic) NSNumber *roomId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *descript;
@property (nonatomic, strong) NSString *coordinates;
@property (nonatomic, strong) NSArray *players;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *exits;
@property (nonatomic, strong) NSNumber *cooldown;
@property (nonatomic, strong) NSArray *errors;
@property (nonatomic, strong) NSArray *messages;

- (instancetype) initWithRoom:(NSNumber *)roomId
                        title:(NSString *)title
                  description:(NSString *)description
                  coordinates:(NSString *)coordinates
                      players:(NSArray *)players
                        items:(NSArray *)items
                        exits:(NSArray *)exits
                     cooldown:(NSNumber *)cooldown
                       errors:(NSArray *)errors
                     messages:(NSArray *)messages;

- (instancetype) initWithDictionary:(NSDictionary *)dictionary;


@end

NS_ASSUME_NONNULL_END
