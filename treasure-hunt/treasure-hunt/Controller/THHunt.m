//
//  THHunt.m
//  treasure-hunt
//
//  Created by De MicheliStefano on 04.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

#import "THHunt.h"
#import "THService.h"

@interface THHunt ()

@property (nonatomic, strong) THService *networkService;
@property (nonatomic, strong) NSMutableDictionary *graph;

@end

@implementation THHunt

- (instancetype)init
{
    self = [super init];
    if (self) {
        _networkService = [[THService alloc] init];
        _graph = [self loadGraph];
    }
    return self;
}

- (void)initializeHunt:(void (^) (void))completion {
    [self.networkService initializeWithCompletion:^(THRoom * room, NSError * error) {
        if (room == nil) {
            NSLog(@"Fetched room was nil after initializing");
            return;
        }
        self.currentRoom = room;
        [NSThread sleepForTimeInterval:[room.cooldown doubleValue]];
        completion();
    }];
}

- (void)traverseToRoom:(NSNumber *)roomId {
    [self findShortestPathToRoom:roomId completion:^(NSArray * shortestPath) {
        NSLog(@"Shortest path: %@", shortestPath);
        NSMutableArray *shortestPathM = [shortestPath mutableCopy];
        [shortestPathM removeObjectAtIndex:0];
        
        while (shortestPathM.count > 0) {
            NSNumber *currRoom = self.currentRoom.roomId;
            NSNumber *nextRoom = shortestPathM.firstObject;
            [shortestPathM removeObjectAtIndex:0];
            NSString *nextDirection = [[NSString alloc] init];
            
            if (self.graph[currRoom] != nil) {
                for (NSString *direction in self.graph[currRoom]) {
                    if (self.graph[currRoom][direction] == [nextRoom stringValue]) {
                        nextDirection = direction;
                        break;
                    }
                }
            }
            
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [NSThread sleepForTimeInterval:[self.currentRoom.cooldown doubleValue]];
            [self.networkService moveInDirection:nextDirection roomId:[nextRoom stringValue] completion:^(THRoom *room, NSError * error) {
                if (room == nil) {
                    NSLog(@"Fetched room was nil after traversing to destination");
                    return;
                }
                NSLog(@"Room title: %@", room.title);
                NSLog(@"Moved to room: %@", room.roomId);
                NSLog(@"Messages: %@", room.messages);
                if (room.items.count > 1) {
                    NSLog(@"TREASURE: %@ \n\n", room.items);
                }
                
                if (room.items.count > 0) {
                    [self pickUpTreasure];
                }
                
                self.currentRoom = room;
                dispatch_semaphore_signal(semaphore);
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
    }];
}

- (void)findShortestPathToRoom:(NSNumber *)roomId completion:(void (^) (NSArray *shortestPath))completion {
    NSMutableArray *shortestPath = [[NSMutableArray alloc] init];
    
    dispatch_group_t initDispatchGroup = dispatch_group_create();
    dispatch_group_enter(initDispatchGroup);
    [self initializeHunt:^{
        dispatch_group_leave(initDispatchGroup);
    }];
    
    dispatch_group_notify(initDispatchGroup, dispatch_get_main_queue(), ^{
        if (self.currentRoom == nil) {
            NSLog(@"Can't find shortest path. Current room has not yet been defined");
            completion(nil);
            return;
        }
        
        NSMutableArray *toVisit = [NSMutableArray new];
        NSMutableDictionary *graph = [self loadGraph];
        NSMutableSet *visited = [NSMutableSet new];
        [toVisit addObject:@[self.currentRoom.roomId]];
        
        while (toVisit.count > 0) {
            NSMutableArray *deqPath = toVisit.firstObject;
            [toVisit removeObjectAtIndex:0];
            NSNumber *deqRoomId = deqPath.lastObject;
            
            if (![visited containsObject:deqRoomId]) {
                if ([deqRoomId isEqualToNumber:roomId]) {
                    [shortestPath addObjectsFromArray:deqPath];
                    completion([shortestPath copy]);
                    return;
                }
                if (deqRoomId != nil) {
                    [visited addObject:deqRoomId];
                }
                if (graph != nil) {
                    NSMutableDictionary *directions = graph[deqRoomId];
                    [directions removeObjectForKey:@"coordinates"];
                    for (id direction in directions) {
                        NSString *nextRoomString = graph[deqRoomId][direction];
                        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                        f.numberStyle = NSNumberFormatterDecimalStyle;
                        NSNumber *nextRoom = [f numberFromString:nextRoomString];
                        
                        NSMutableArray *copiedPath = [deqPath mutableCopy];
                        if (copiedPath != nil && nextRoom != nil) {
                            [copiedPath addObject:nextRoom];
                            [toVisit addObject:copiedPath];
                        }
                    }
                }
            }
        }
    });
}

- (void)pickUpTreasure {
    NSArray *treasures = self.currentRoom.items;
    
    if (treasures.count > 0) {
        dispatch_time_t cooldown = dispatch_time(DISPATCH_TIME_NOW, [self.currentRoom.cooldown doubleValue] * NSEC_PER_SEC);
        dispatch_after(cooldown, dispatch_get_main_queue(), ^{
            for (NSString *treasure in treasures) {
                if ([treasure isEqualToString:@"amazing treasure"] || [treasure isEqualToString:@"spectacular treasure"] || [treasure isEqualToString:@"great treasure"] || [treasure isEqualToString:@"shiny treasure"]) {
                    dispatch_time_t cooldown = dispatch_time(DISPATCH_TIME_NOW, [self.currentRoom.cooldown doubleValue] * NSEC_PER_SEC);
                    dispatch_after(cooldown, dispatch_get_main_queue(), ^{
                        [self.networkService takeTreasureWithName:treasure completion:^(THRoom *room, NSError * error) {
                            if (error != nil || room == nil) {
                                NSLog(@"Error picking up treasure");
                                return;
                            }
                            NSLog(@"Picked up treasure: %@", treasure);
                            self.currentRoom = room;
                            return;
                        }];
                    });
                }
            }
        });
    }
}

- (NSMutableDictionary *)loadGraph {
    NSData *graphData = [NSUserDefaults.standardUserDefaults dataForKey:@"graph"];
    NSMutableDictionary *loadedGraph = [NSKeyedUnarchiver unarchivedObjectOfClass:NSMutableDictionary.self fromData:graphData error:nil];
    
    return loadedGraph;
}

@end
