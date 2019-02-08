//
//  THMapViewController.m
//  treasure-hunt
//
//  Created by De MicheliStefano on 07.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

#import "THMapViewController.h"

@interface THMapViewController ()

@end

@implementation THMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawMap];
}


#pragma mark - Map Visualization

- (void)drawMap {
    NSData *graphData = [NSUserDefaults.standardUserDefaults dataForKey:@"graph"];
    NSMutableDictionary *loadedGraph = [NSKeyedUnarchiver unarchivedObjectOfClass:NSMutableDictionary.self fromData:graphData error:nil];
    
    for (NSNumber *roomId in loadedGraph) {
        NSInteger xInt = [[loadedGraph[roomId][@"coordinates"] substringWithRange:NSMakeRange(1, 2)] integerValue];
        NSInteger yInt = [[loadedGraph[roomId][@"coordinates"] substringWithRange:NSMakeRange(4, 2)] integerValue];
        NSNumber *x = [NSNumber numberWithInteger:xInt];
        NSNumber *y = [NSNumber numberWithInteger:yInt];
        
        loadedGraph[roomId][@"coordinates"] = @[x, y];
    }
    
    
    NSNumber *cellSize = @70;
    NSNumber *scrollWidth = [NSNumber numberWithInt:[cellSize intValue] * 35];
    NSNumber *scrollHeight = [NSNumber numberWithInt:[cellSize intValue] * 35];
    
    [self.scrollView setContentSize:CGSizeMake([scrollWidth floatValue], [scrollHeight floatValue])];
    
    for (int y = 0; y <= 27; y++) {
        for (int x = 0; x <= 35; x++) {
            
            BOOL isInCoordinates = false;
            NSNumber *roomId = [[NSNumber alloc] init];
            for (NSNumber *room in loadedGraph) {
                NSArray *coordinates = loadedGraph[room][@"coordinates"];
                NSInteger translatedX = [[coordinates firstObject] integerValue] - 50;
                NSInteger translatedY = ([[coordinates lastObject] integerValue] - 74) * -1;
                
                if (translatedX == x && translatedY == y) {
                    isInCoordinates = true;
                    roomId = room;
                }
            }
            
            CGFloat xOffset = ([cellSize integerValue] + 5) * x;
            CGFloat yOffset = ([cellSize integerValue] + 5) * y;
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(xOffset, yOffset, [cellSize floatValue], [cellSize floatValue])];
            
            NSArray *directions = [self getDirectionsForRoom:loadedGraph[roomId]];
            [self drawBorderForView:view withDirections:directions];
            //[self drawPathForView:view];
            
            isInCoordinates ? [view setBackgroundColor:[UIColor redColor]] : [view setBackgroundColor:[UIColor grayColor]];
            
            [self.scrollView addSubview:view];
        }
    }
}

- (void)drawPathForView:(UIView *)view {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:view.center];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(view.frame), view.center.y)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor blueColor] CGColor];
    shapeLayer.lineWidth = 3.0;
    
    [view.layer addSublayer:shapeLayer];
}

- (void)drawBorderForView:(UIView *)view withDirections:(NSArray *)directions {
    view.clipsToBounds = YES;
    
    CALayer *border = [CALayer layer];
    border.borderColor = [UIColor greenColor].CGColor;
    border.borderWidth = 5;
    if ([directions isEqualToArray:@[@"e"]]) {
        // right
        border.frame = CGRectMake(-5, -5, CGRectGetWidth(view.frame)+5, CGRectGetHeight(view.frame)+10);
    } else if ([directions isEqualToArray:@[@"s"]]) {
        // down
        border.frame = CGRectMake(-5, -5, CGRectGetWidth(view.frame) + 10, CGRectGetHeight(view.frame)+5);
    } else if ([directions isEqualToArray:@[@"w"]]) {
        // left
        border.frame = CGRectMake(0, -5, CGRectGetWidth(view.frame) + 10, CGRectGetHeight(view.frame) + 10);
    } else if ([directions isEqualToArray:@[@"n"]]) {
        // up
        border.frame = CGRectMake(-5, 0, CGRectGetWidth(view.frame) + 10, CGRectGetHeight(view.frame) + 10);
    } else if ([directions isEqualToArray:@[@"n", @"w"]]) {
        // left up
        border.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame) + 10, CGRectGetHeight(view.frame) + 10);
    } else if ([directions isEqualToArray:@[@"e", @"n"]]) {
        // up right
        border.frame = CGRectMake(-5, 0, CGRectGetWidth(view.frame) + 5, CGRectGetHeight(view.frame) + 10);
    } else if ([directions isEqualToArray:@[@"e", @"s"]]) {
        // right down
        border.frame = CGRectMake(-5, -5, CGRectGetWidth(view.frame) + 5, CGRectGetHeight(view.frame) + 5);
    } else if ([directions isEqualToArray:@[@"s", @"w"]]) {
        // down left
        border.frame = CGRectMake(0, -5, CGRectGetWidth(view.frame) + 10, CGRectGetHeight(view.frame) + 5);
    } else if ([directions isEqualToArray:@[@"e", @"w"]]) {
        // left right
        border.frame = CGRectMake(0, -5, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame) + 10);
    } else if ([directions isEqualToArray:@[@"n", @"s"]]) {
        // up down
        border.frame = CGRectMake(-5, 0, CGRectGetWidth(view.frame) + 10, CGRectGetHeight(view.frame));
    } else if ([directions isEqualToArray:@[@"n", @"s", @"w"]]) {
        //down left up
        border.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame) + 10, CGRectGetHeight(view.frame) + 0);
    } else if ([directions isEqualToArray:@[@"e", @"n", @"w"]]) {
        // left up right
        border.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame) + 0, CGRectGetHeight(view.frame) + 5);
    } else if ([directions isEqualToArray:@[@"e", @"n", @"s"]]) {
        // up right down
        border.frame = CGRectMake(-5, 0, CGRectGetWidth(view.frame) + 5, CGRectGetHeight(view.frame) + 0);
    } else if ([directions isEqualToArray:@[@"e", @"s", @"w"]]) {
        // right down left
        border.frame = CGRectMake(0, -5, CGRectGetWidth(view.frame) + 0, CGRectGetHeight(view.frame) + 5);
    } else if ([directions isEqualToArray:@[@"e", @"n", @"s", @"w"]]) {
        // all
        border.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
    }
    
    [view.layer addSublayer:border];
}

- (NSArray *)getDirectionsForRoom:(NSMutableDictionary *)room {
    NSMutableArray *directions = [[NSMutableArray alloc] init];
    
    for (NSString *direction in room) {
        if (![direction isEqualToString:@"coordinates"]) {
            [directions addObject:direction];
        }
    }
    
    NSArray *sortedDirections = [directions sortedArrayUsingSelector:@selector(compare:)];
    
    return sortedDirections;
}


@end
