//
//  THExploration.m
//  treasure-hunt
//
//  Created by De MicheliStefano on 04.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

#import "THExploration.h"

@interface THExploration ()

@property (nonatomic, strong) NSMutableArray *internalTraversalPath;
@property (nonatomic, strong) NSMutableArray *internalTraversalGraph;
@property (nonatomic, strong) NSMutableArray *internalTraversedPath;

@end

@implementation THExploration

- (instancetype)init
{
    self = [super init];
    if (self) {
        _networkService = [[THService alloc] init];
        _internalTraversedPath = [[NSMutableArray alloc] init];
        _internalTraversalGraph = [[NSMutableArray alloc] init];
        _internalTraversedPath = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)explore {
    [self.networkService moveInDirection:@"n" completion:^(THRoom * room, NSError * error) {
        
    }];
}

- (void)traverse {
    
}

- (void)traverseBack {
    
}

#pragma mark - Properties

- (NSArray *)traversalPath {
    return [_internalTraversalPath copy];
}

- (NSDictionary *)traversalGraph {
    return [_internalTraversalGraph copy];
}

- (NSMutableArray *)internalTraversedPath {
    return [_internalTraversedPath copy];
}

@end
