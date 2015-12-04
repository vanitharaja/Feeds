//
//  ServiceHandler.m
//  Exercise
//
//  Created by Gnana_v on 23/11/15.
//  Copyright © 2015 Vanitha. All rights reserved.
//

#import "ServiceHandler.h"
#import "Constant.h"

@interface ServiceHandler()

@property(nonatomic,strong) UserContent *userContent;

@end

@implementation ServiceHandler

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(void)getUserContent:(void (^)(UserContent *userContent))successCallback failure:(void (^)(NSError *error))failureCallback{
    
    NSURL *url = [NSURL URLWithString:WS_URL];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setTimeoutInterval:WS_TIMEOUT_KEY];
    
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse* serviceResponse = (NSHTTPURLResponse*)response;
        
        if (serviceResponse.statusCode == 200) {
        }
        
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]  options:0 error:&error];
        
//        NSLog(@"responseDictionary %@",responseDictionary);
        
        
        if (error != nil) {
            NSLog(@"Error parsing JSON.");
            
            failureCallback(error);
            
        }
        else {
            
            if (self.userContent == nil){
                self.userContent = [[UserContent alloc] init];
                self.userContent.feeds = [[NSMutableArray alloc] init];
            }
            
            [self.userContent.feeds removeAllObjects];
            
            NSString *title = [responseDictionary objectForKey:WS_RESPONSE_TITLE_KEY];
            NSArray *rows = [responseDictionary objectForKey:WS_RESPONSE_ROOT_KEY];
            self.userContent.title = title;
            
            for (NSDictionary *row in rows) {
                Feed *feed = [[Feed alloc] init];
                feed.title = [row objectForKey:WS_RESPONSE_TITLE_KEY];
                if ([feed.title isEqual:[NSNull null]]) {
                    feed.title = @"";
                }
                
                feed.desc = [row objectForKey:WS_RESPONSE_DECRIPTION_KEY];
                if ([feed.desc isEqual:[NSNull null]]) {
                    feed.desc = @"";
                }

                feed.desc = [NSString stringWithFormat:@"%@",feed.desc];
                feed.imageHref = [row objectForKey:WS_RESPONSE_IMAGEURL_KEY];
                if ([feed.imageHref isEqual:[NSNull null]]) {
                    feed.imageHref = @"";
                }
                
                [self.userContent.feeds addObject:feed];
                feed = nil;
                
            }
            
            successCallback(self.userContent);
        }
        
        

    }] resume];
    
    
}

@end
