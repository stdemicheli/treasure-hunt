//
//  THExploration.m
//  treasure-hunt
//
//  Created by De MicheliStefano on 04.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THExploration.h"

@interface THExploration ()

@property (nonatomic, strong) THRoom *room;
@property (nonatomic, strong) NSMutableArray *__traversalPath;
@property (nonatomic, strong) NSMutableDictionary *__visitedGraph;
@property (nonatomic, strong) NSMutableArray *__traversedPath;
@property (nonatomic, strong) NSTimer *timer;

- (NSString *)getInverseDirectionFrom:(NSString *)direction;

@end

@implementation THExploration

- (instancetype)init {
    self = [super init];
    if (self) {
        _networkService = [[THService alloc] init];
        _room = [[THRoom alloc] init];
        ___traversedPath = [[NSMutableArray alloc] init];
//        NSDictionary *initialGraph = @{ @"0": [@{ @"n": @"?", @"e": @"?", @"w": @"?", @"s": @"?" } mutableCopy] };
//        ___visitedGraph = [initialGraph mutableCopy];
        ___visitedGraph = [[NSMutableDictionary alloc] init];
        ___traversedPath = [[NSMutableArray alloc] init];
        _timer = [[NSTimer alloc] init];
        
        [self loadExploration];
    }
    return self;
}

- (void)explore {
    [self.networkService initializeWithCompletion:^(THRoom * room, NSError * error) {
        if (room == NULL) {
            NSLog(@"Fetched room was nil after initializing");
            return;
        }
        self.room = room;
        
        // TODO: need to check first if in graph
        if (self.__visitedGraph[room.roomId] == NULL) {
            self.__visitedGraph[room.roomId] = [@{ @"n": @"?", @"e": @"?", @"w": @"?", @"s": @"?" } mutableCopy];
        }
        
        NSArray *exits = room.exits;
        NSMutableDictionary *curr_exits = self.__visitedGraph[room.roomId];
        NSMutableArray *unexploredExits = [[NSMutableArray alloc] init];
        for (NSString *exit in exits) {
            if ([curr_exits[exit] isEqualToString:@"?"]) {
                [unexploredExits addObject:exit];
            }
        }
        
        if (unexploredExits.count > 0) {
            [self traverseForwardInDirection:unexploredExits[0] fromRoom:room];
        } else {
            //[self traverseBack];
        }
    }];
    // time out?
}

- (void)traverseForwardInDirection:(NSString *)direction fromRoom:(THRoom *)prevRoom {
    [self.networkService moveInDirection:direction completion:^(THRoom * room, NSError * error) {
        if (room == NULL) {
            NSLog(@"Fetched room was nil after traversing forward");
            return;
        }
        
        [self.__traversalPath addObject:direction];
        [self.__traversedPath addObject:direction];
        self.room = room;
        
        // Checks if the entered room is in our visited graph.
        if ([self.__visitedGraph objectForKey:room.roomId] == NULL) {
            NSMutableDictionary *enteredRoomExits = [[NSMutableDictionary alloc] init];
            for (NSString *exit in room.exits) {
                enteredRoomExits[exit] = @"?";
            }
            self.__visitedGraph[room.roomId] = enteredRoomExits;
        }
        
        // Adds previous and entered room to our graph.
        NSString *inverseDirection = [self getInverseDirectionFrom:direction];
        self.__visitedGraph[prevRoom.roomId][direction] = [room.roomId stringValue];
        self.__visitedGraph[room.roomId][inverseDirection] = [prevRoom.roomId stringValue];
        
        [self saveExploration];
    }];
}

- (void)traverseBackInDirection:(NSString *)direction fromRoom:(THRoom *)room {
    // check next room we're traversing to
}

#pragma mark - Private methods

- (void)saveExploration {
    NSData *graphData = [NSKeyedArchiver archivedDataWithRootObject:self.__visitedGraph requiringSecureCoding:FALSE error:NULL];
    [NSUserDefaults.standardUserDefaults setObject:graphData forKey:@"graph"];
}

- (void)loadExploration {
    NSData *data = [NSUserDefaults.standardUserDefaults dataForKey:@"graph"];
    NSMutableDictionary *loadedGraph = [NSKeyedUnarchiver unarchivedObjectOfClass:NSMutableDictionary.self fromData:data error:NULL];
    self.__visitedGraph = loadedGraph;
}

- (NSString *)getInverseDirectionFrom:(NSString *)direction {
    if ([direction isEqualToString:@"n"]) {
        return @"s";
    } else if ([direction isEqualToString:@"e"]) {
        return @"w";
    } else if ([direction isEqualToString:@"s"]) {
        return @"n";
    } else if ([direction isEqualToString:@"w"]) {
        return @"e";
    }
    
    return @"n";
}

#pragma mark - Properties

- (NSArray *)traversalPath {
    return [___traversalPath copy];
}

- (NSDictionary *)traversalGraph {
    return [___visitedGraph copy];
}

- (NSMutableArray *)traversedPath {
    return [___traversedPath copy];
}

@end
