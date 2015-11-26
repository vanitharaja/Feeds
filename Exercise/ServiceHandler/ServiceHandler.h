//
//  ServiceHandler.h
//  Exercise
//
//  Created by Gnana_v on 23/11/15.
//  Copyright © 2015 Vanitha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Feed.h"

@interface ServiceHandler : NSObject

+ (instancetype)sharedInstance;

-(void)getUserContent:(void (^)(UserContent *userContent))successCallback failure:(void (^)(NSError *error))failureCallback;

@end
