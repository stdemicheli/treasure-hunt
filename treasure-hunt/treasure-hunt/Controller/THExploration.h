//
//  THExploration.h
//  treasure-hunt
//
//  Created by De MicheliStefano on 04.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THExploration : NSObject

@property (nonatomic, readonly) NSArray *traversalPath;
@property (nonatomic, readonly) NSDictionary *traversalGraph;
@property (nonatomic, readonly) NSArray *traversedPath;

- (void)explore;
- (void)traverse;
- (void)traverseBack;

@end

NS_ASSUME_NONNULL_END
