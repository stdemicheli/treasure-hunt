//
//  THHunt.h
//  treasure-hunt
//
//  Created by De MicheliStefano on 04.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THRoom.h"

NS_ASSUME_NONNULL_BEGIN

@interface THHunt : NSObject

@property (nonatomic, strong) THRoom *currentRoom;

- (NSArray *)findShortestPathFromRoom:(THRoom *)currentRoom toRoom:(THRoom *)destination;

@end

NS_ASSUME_NONNULL_END
