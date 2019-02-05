//
//  THRoom.m
//  treasure-hunt
//
//  Created by De MicheliStefano on 04.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

#import "THRoom.h"

@implementation THRoom

- (instancetype)initWithRoom:(NSNumber *)roomId
                       title:(NSString *)title
                 description:(NSString *)description
                 coordinates:(NSString *)coordinates
                     players:(NSArray *)players
                       items:(NSArray *)items
                       exits:(NSArray *)exits
                    cooldown:(NSNumber *)cooldown
                      errors:(NSArray *)errors
                    messages:(NSArray *)messages {
    self = [super init];
    if (self) {
        _roomId = roomId;
        _title = title;
        _descript = description;
        _coordinates = coordinates;
        _players = players;
        _items = items;
        _exits = exits;
        _cooldown = cooldown;
        _errors = errors;
        _messages = messages;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    NSNumber *roomId = dictionary[@"room_id"];
    NSString *title = dictionary[@"title"];
    NSString *description = dictionary[@"description"];
    NSString *coordinates = dictionary[@"coordinates"];
    NSArray *players = dictionary[@"players"];
    NSArray *items = dictionary[@"items"];
    NSArray *exits = dictionary[@"exits"];
    NSNumber *cooldown = dictionary[@"cooldown"];
    NSArray *errors = dictionary[@"errors"];
    NSArray *messages = dictionary[@"messages"];
    
    if (!roomId ||!title ||!coordinates ||!cooldown) {
        return NULL;
    }
    
    return [self initWithRoom:roomId title:title description:description coordinates:coordinates players:players items:items exits:exits cooldown:cooldown errors:errors messages:messages];
}

@end
