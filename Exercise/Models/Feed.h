//
//  Feed.h
//  Exercise
//
//  Created by Gnana_v on 23/11/15.
//  Copyright © 2015 Vanitha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feed : NSObject

@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *desc;
@property(nonatomic,strong) NSString *imageHref;
@property(nonatomic,assign) BOOL isDownloaded;


@end


@interface UserContent : NSObject

@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSMutableArray *feeds;

@end