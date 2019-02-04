//
//  THService.m
//  treasure-hunt
//
//  Created by De MicheliStefano on 04.02.19.
//  Copyright © 2019 De MicheliStefano. All rights reserved.
//

#import "THService.h"

@implementation THService

static NSString * const baseUrlString = @"https://lambda-treasure-hunt.herokuapp.com/api/adv";

- (void)moveInDirection:(NSString *)direction roomId:(NSString *)roomId completion:(void (^)(THRoom *room, NSError *error))completion {
    NSURL *baseUrl = [[NSURL alloc] initWithString:baseUrlString];
    [baseUrl URLByAppendingPathComponent:@"move"];
    
    NSString *body = ([roomId isEqualToString:@""]) ? [NSString stringWithFormat:@"direction=%@", direction] : [NSString stringWithFormat:@"direction=%@&next_room_id=%@", direction, roomId];
    NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:baseUrl];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error fetching data: %@", error);
            completion(nil, error);
            return;
        }
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSDictionary *errorMessage = dictionary[@"error"];
        
        if (![dictionary isKindOfClass:[NSDictionary class]]) {
            NSLog(@"JSON was not a dictionary");
            completion(nil, [[NSError alloc] init]);
            return;
        }
        
        if (errorMessage) {
            NSString *message = errorMessage[@"message"];
            NSLog(@"%@", message);
            completion(nil,  [[NSError alloc] init]);
            return;
        }
        
        THRoom *room = [[THRoom alloc] initWithDictionary:dictionary];
        if (room) {
            completion(room, nil);
        } else {
            completion(nil, [[NSError alloc] init]);
        }
        
    }] resume];
}

- (void)moveInDirection:(NSString *)direction completion:(void (^)(THRoom *room, NSError *error))completion {
    [self moveInDirection:direction roomId:@"" completion:completion];
}

- (void)sellTreasureWithName:(NSString *)treasureName completion:(void (^)(THRoom *room, NSError * error))completion {
    
}

- (void)takeTreasureWithName:(NSString *)treasureName completion:(void (^)(THRoom * room, NSError * error))completion {
    
}

- (void)checkInventoryWithResponse:(void (^)(THStatus * room, NSError * error))completion{
    
}

@end
