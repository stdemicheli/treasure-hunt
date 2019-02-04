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
    NSURL *url = [baseUrl URLByAppendingPathComponent:@"move"];
    
    NSDictionary *body = ([roomId isEqualToString:@""]) ? [[NSDictionary alloc] initWithObjectsAndKeys:direction, @"direction", nil] : [[NSDictionary alloc] initWithObjectsAndKeys:direction, @"direction", roomId, @"next_room_id", nil];

    NSData *data = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
    NSString *key = [NSString stringWithFormat:@"Token %@", apiKey];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:key forHTTPHeaderField:@"Authorization"];
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
