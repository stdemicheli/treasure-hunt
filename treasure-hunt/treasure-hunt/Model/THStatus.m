//
//  THStatus.m
//  treasure-hunt
//
//  Created by De MicheliStefano on 04.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

#import "THStatus.h"

@implementation THStatus

- (instancetype)initWithName:(NSString *)name
                encumberance:(NSNumber *)encumberance
                    strength:(NSNumber *)strength
                       speed:(NSNumber *)speed
                        gold:(NSNumber *)gold
                   inventory:(NSArray *)inventory
                      status:(NSArray *)status
                    cooldown:(NSNumber *)cooldown
                      errors:(NSArray *)errors
                    messages:(NSArray *)messages {
    self = [super init];
    if (self) {
        _name = name;
        _encumbrance = encumberance;
        _strength = strength;
        _speed = speed;
        _gold = gold;
        _inventory = inventory;
        _status = status;
        _cooldown = cooldown;
        _errrors = errors;
        _messages = messages;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    NSString *name = dictionary[@"name"];
    NSNumber *cooldown = dictionary[@"cooldown"];
    NSNumber *encumbrance = dictionary[@"encumbrance"];
    NSNumber *strength = dictionary[@"strength"];
    NSNumber *speed = dictionary[@"speed"];
    NSNumber *gold = dictionary[@"gold"];
    NSArray *inventory = dictionary[@"inventory"];
    NSArray *status = dictionary[@"status"];
    NSArray *errors = dictionary[@"errors"];
    NSArray *messages = dictionary[@"messages"];
    
    if (!name) {
        return NULL;
    }
    
    return [self initWithName:name encumberance:encumbrance strength:strength speed:speed gold:gold inventory:inventory status:status cooldown:cooldown errors:errors messages:messages];
}

@end
