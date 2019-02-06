//
//  THHunt.m
//  treasure-hunt
//
//  Created by De MicheliStefano on 04.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

#import "THHunt.h"

@implementation THHunt

- (NSArray *)findShortestPathFromRoom:(THRoom *)currentRoom toRoom:(THRoom *)destination {
    NSMutableArray *toVisit = [NSMutableArray new];
    NSMutableSet *visited = [NSMutableSet new];
    [toVisit addObjectsFromArray:@[currentRoom.roomId]];
    
    while (toVisit.count > 0) {
        NSMutableArray *deqPath = toVisit.firstObject;
        [toVisit removeObjectAtIndex:0];
        NSNumber *deqRoomId = deqPath.lastObject;
        
        if (![visited containsObject:deqRoomId]) {
            if ([deqRoomId isEqualToValue:destination.roomId]) {
                return deqPath;
            }
            
            [visited addObject:deqRoomId];
            NSMutableDictionary *graph = [self loadGraph];
            if (graph != nil) {
                NSMutableDictionary *directions = graph[deqRoomId];
                for (id direction in directions) {
                    NSNumber *nextRoom = graph[deqRoomId][direction];
                    NSMutableArray *copiedPath = [deqPath copy];
                    [copiedPath addObject:nextRoom];
                    [toVisit addObject:copiedPath];
                }
            }
        }
    }
    
    return nil;
}

- (NSMutableDictionary *)loadGraph {
    NSData *graphData = [NSUserDefaults.standardUserDefaults dataForKey:@"graph"];
    NSMutableDictionary *loadedGraph = [NSKeyedUnarchiver unarchivedObjectOfClass:NSMutableDictionary.self fromData:graphData error:nil];
    
    return loadedGraph;
}

@end
