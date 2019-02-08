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

@end

@implementation THHunt

- (instancetype)init
{
    self = [super init];
    if (self) {
        _networkService = [[THService alloc] init];
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
        completion();
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
            NSLog(@"DeqRoomId: %@", deqRoomId);
            NSLog(@"toVisit: %@", toVisit);
            
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

- (NSMutableDictionary *)loadGraph {
    NSData *graphData = [NSUserDefaults.standardUserDefaults dataForKey:@"graph"];
    NSMutableDictionary *loadedGraph = [NSKeyedUnarchiver unarchivedObjectOfClass:NSMutableDictionary.self fromData:graphData error:nil];
    
    return loadedGraph;
}

@end
