//
//  FeedCell.h
//  Exercise
//
//  Created by Vanitha on 23/11/15.
//  Copyright © 2015 Vanitha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feed.h"

@interface FeedCell : UITableViewCell
{
    
}
- (CGFloat)heightForFeed:(Feed*)feed;
-(void)configureCell:(Feed*)feed;

@end
