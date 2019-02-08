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
@property (nonatomic) BOOL keepExploring;

- (NSString *)getInverseDirectionFrom:(NSString *)direction;

@end

@implementation THExploration

- (instancetype)init {
    self = [super init];
    if (self) {
        _networkService = [[THService alloc] init];
        _room = [[THRoom alloc] init];
        ___traversalPath = [[NSMutableArray alloc] init];
        ___visitedGraph = [[NSMutableDictionary alloc] init];
        ___traversedPath = [[NSMutableArray alloc] init];
        _timer = [[NSTimer alloc] init];
        _keepExploring = true;
        
        [self loadExploration];
    }
    return self;
}

- (void)initializeExploration {
    [self.networkService initializeWithCompletion:^(THRoom * room, NSError * error) {
        if (room == nil) {
            NSLog(@"Fetched room was nil after initializing");
            [self restartExplorationWithLag:10.0];
            return;
        }
        self.room = room;
        
        if (self.__visitedGraph[room.roomId] == NULL) {
            self.__visitedGraph[room.roomId] = [@{ @"n": @"?", @"e": @"?", @"w": @"?", @"s": @"?" } mutableCopy];
            self.__visitedGraph[room.roomId][@"coordinates"] = room.coordinates;
            if (room.items.count > 0) {
                self.__visitedGraph[room.roomId][@"items"] = room.items.firstObject;
            }
        }
        
        [self explore];
    }];
}

- (void)explore {
    NSArray *exits = self.room.exits;
    NSMutableDictionary *curr_exits = self.__visitedGraph[self.room.roomId];
    NSMutableArray *unexploredExits = [[NSMutableArray alloc] init];
    for (NSString *exit in exits) {
        if ([curr_exits[exit] isEqualToString:@"?"]) {
            [unexploredExits addObject:exit];
        }
    }
    
    NSLog(@"Current room id: %@", self.room.roomId);
    NSLog(@"Current room title: %@", self.room.title);
    NSLog(@"Cooldown: %@", self.room.cooldown);
    NSLog(@"Graph size: '%lu", [self.__visitedGraph count]);
    NSLog(@"Coordinates: %@", self.room.coordinates);
    //NSLog(@"graph: %@", self.__visitedGraph);
    
    dispatch_time_t cooldown = dispatch_time(DISPATCH_TIME_NOW, [self.room.cooldown doubleValue] * NSEC_PER_SEC);
    dispatch_after(cooldown, dispatch_get_main_queue(), ^{
        
        [self pickUpTreasure];
        //[self sellTreasure];
        if ([self.room.title isEqualToString:@"An Ancient Shrine"]) {
            
        }
        
        if (self.traversalGraph.count >= 500) {
            [self traverseInRandomDirection];
        } else if (unexploredExits.count > 0) {
            NSLog(@"Traversing forward to: %@", unexploredExits[0]);
            [self traverseForwardInDirection:unexploredExits[0] fromRoom:self.room];
        } else {
            [self traverseBackInDirection];
        }
        
    });
}

- (void)traverseForwardInDirection:(NSString *)direction fromRoom:(THRoom *)prevRoom {
    [self.networkService moveInDirection:direction completion:^(THRoom * room, NSError * error) {
        if (room == nil) {
            NSLog(@"Fetched room was nil after traversing forward");
            [self restartExplorationWithLag:10.0];
            return;
        }
        self.room = room;
        
        [self.__traversalPath addObject:direction];
        [self.__traversedPath addObject:direction];
        
        // Checks if the entered room is in our visited graph.
        if ([self.__visitedGraph objectForKey:room.roomId] == nil) {
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
        self.__visitedGraph[room.roomId][@"coordinates"] = room.coordinates;
        if (room.items.count > 1) {
            self.__visitedGraph[room.roomId][@"items"] = room.items.firstObject;
        }
        
        [self saveExploration];
        [self explore];
    }];
}

- (void)traverseBackInDirection {
    // check next room we're traversing to
    NSString *prevDirection = [self.__traversedPath lastObject];
    [self.__traversedPath removeLastObject];
    NSString *directionBack = [self getInverseDirectionFrom:prevDirection];
    NSString *nextRoomId = self.__visitedGraph[self.room.roomId][directionBack];
    NSLog(@"Traversing backwards to: %@ into room: %@", directionBack, nextRoomId);
    [self.networkService moveInDirection:directionBack roomId:nextRoomId completion:^(THRoom *room, NSError *error) {
        if (room == nil) {
            NSLog(@"Fetched room was nil after traversing backwards");
            [self restartExplorationWithLag:10.0];
            return;
        }
        self.room = room;
        [self saveExploration];
        [self explore];
    }];
}

- (void)traverseInRandomDirection {
    NSArray *exits = self.room.exits;
    int randomIndex = arc4random_uniform(exits.count);
    NSString *randomDirection = exits[randomIndex];
    NSString *nextRoomId = self.__visitedGraph[self.room.roomId][randomDirection];
    self.__visitedGraph[self.room.roomId][@"coordinates"] = self.room.coordinates;
    self.__visitedGraph[self.room.roomId][@"items"] = self.room.items;
    NSLog(@"Traversing randomly to: %@ into room: %@", randomDirection, nextRoomId);
    
    [self.networkService moveInDirection:randomDirection roomId:nextRoomId completion:^(THRoom *room, NSError *error) {
        if (room == nil) {
            NSLog(@"Fetched room was nil after traversing randomly");
            [self restartExplorationWithLag:10.0];
            return;
        }
        self.room = room;
        [self explore];
    }];
}

- (void)pickUpTreasure {
    NSArray *treasures = self.room.items;
    
    if (treasures.count > 0) {
        // TODO: check most worthy treasure to pick up
        NSString *firstTreasure = treasures.lastObject;
        
        dispatch_time_t cooldown = dispatch_time(DISPATCH_TIME_NOW, [self.room.cooldown doubleValue] * NSEC_PER_SEC);
        dispatch_after(cooldown, dispatch_get_main_queue(), ^{
            [self.networkService checkInventoryWithResponse:^(THStatus *status, NSError *error) {
                
                NSInteger encumberance = [status.encumbrance integerValue];
                NSInteger strength = [status.strength integerValue];
                NSInteger deficit = encumberance - strength;
                
                if (deficit > 0) {
                    dispatch_time_t cooldown = dispatch_time(DISPATCH_TIME_NOW, [status.cooldown doubleValue] * NSEC_PER_SEC);
                    dispatch_after(cooldown, dispatch_get_main_queue(), ^{
                        [self.networkService takeTreasureWithName:firstTreasure completion:^(THRoom *room, NSError * error) {
                            if (error != nil || room == nil) {
                                NSLog(@"Error picking up treasure");
                                [self restartExplorationWithLag:10.0];
                                return;
                            }
                            NSLog(@"Picked up treasure: %@", firstTreasure);
                            self.room = room;
                        }];
                    });
                }
            }];
        });
    }
    
}

- (void)sellTreasure {
    if ([self.room.title isEqualToString:@"Shop"]) {
        [self.networkService checkInventoryWithResponse:^(THStatus *status, NSError *error) {
            NSArray *treasures = status.inventory;
            for (NSString *treasure in treasures) {
                dispatch_time_t cooldown = dispatch_time(DISPATCH_TIME_NOW, [self.room.cooldown doubleValue] * NSEC_PER_SEC);
                dispatch_after(cooldown, dispatch_get_main_queue(), ^{
                    [self.networkService sellTreasureWithName:treasure completion:^(THRoom *room, NSError *error) {
                        if (error != nil) {
                            NSLog(@"Error selling up treasure");
                            [self restartExplorationWithLag:10.0];
                            return;
                        }
                        self.room = room;
                        NSLog(@"Successfully sold treasure: %@", treasure);
                    }];
                });
            }
        }];
    }
}

- (void)pray {
    [self.networkService pray:^(THRoom * room, NSError * error) {
        
        if (room == nil) {
            NSLog(@"Fetched room was nil after praying");
            [self restartExplorationWithLag:10.0];
            return;
        }
        self.room = room;
    }];
}

#pragma mark - Private methods

- (void)saveExploration {
    NSData *graphData = [NSKeyedArchiver archivedDataWithRootObject:self.__visitedGraph requiringSecureCoding:false error:nil];
    [NSUserDefaults.standardUserDefaults setObject:graphData forKey:@"graph"];
    
    NSData *traversalPathData = [NSKeyedArchiver archivedDataWithRootObject:self.__traversalPath requiringSecureCoding:false error:nil];
    [NSUserDefaults.standardUserDefaults setObject:traversalPathData forKey:@"traversalPath"];
    
    NSData *traversedPathData = [NSKeyedArchiver archivedDataWithRootObject:self.__traversedPath requiringSecureCoding:false error:nil];
    [NSUserDefaults.standardUserDefaults setObject:traversedPathData forKey:@"traversedPath"];
    
}

- (void)loadExploration {
    NSData *graphData = [NSUserDefaults.standardUserDefaults dataForKey:@"graph"];
    NSMutableDictionary *loadedGraph = [NSKeyedUnarchiver unarchivedObjectOfClass:NSMutableDictionary.self fromData:graphData error:nil];
    
    NSData *traversalPathData = [NSUserDefaults.standardUserDefaults dataForKey:@"traversalPath"];
    NSMutableArray *loadedTraversalPath = [NSKeyedUnarchiver unarchivedObjectOfClass:NSMutableArray.self fromData:traversalPathData error:nil];
    
    NSData *traversedPathData = [NSUserDefaults.standardUserDefaults dataForKey:@"traversedPath"];
    NSMutableArray *loadedTraversedPath = [NSKeyedUnarchiver unarchivedObjectOfClass:NSMutableArray.self fromData:traversedPathData error:nil];
    
    if (loadedGraph != nil) {
        self.__visitedGraph = loadedGraph;
    }
    if (loadedTraversedPath != nil) {
        [self.__traversedPath addObjectsFromArray:loadedTraversedPath];
    }
    if (loadedTraversalPath != nil) {
        [self.__traversalPath addObjectsFromArray:loadedTraversalPath];
    }
    
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

- (void)restartExplorationWithLag:(double)lag {
    dispatch_time_t cooldown = dispatch_time(DISPATCH_TIME_NOW, lag * NSEC_PER_SEC);
    dispatch_after(cooldown, dispatch_get_main_queue(), ^{
        [self explore];
    });
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
