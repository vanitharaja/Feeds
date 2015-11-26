//
//  ViewController.m
//  Exercise
//
//  Created by Vanitha on 23/11/15.
//  Copyright © 2015 Vanitha. All rights reserved.
//

#import "FeedsViewController.h"
#import "FeedCell.h"
#import "ServiceHandler.h"
#import "Feed.h"

static NSString *cellIdentifier = @"FeedCell";

@interface FeedsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *feeds;
@property(nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation FeedsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    
    self.title = @"Loading...";
    [self addSubviews];
    
    [self refresh];
    
}


-(void)addSubviews{
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[FeedCell class] forCellReuseIdentifier:cellIdentifier];
    
    [self.view addSubview:self.tableView];
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.center = CGPointMake(self.view.bounds.size.width/2, (self.activityIndicatorView.frame.size.height) / 2);
    CGRect frame = self.activityIndicatorView.frame;
    frame.origin.x = (self.view.bounds.size.width - self.activityIndicatorView.frame.size.width) / 2;
    frame.origin.y = (self.view.bounds.size.height - self.activityIndicatorView.frame.size.height) / 2;
    self.activityIndicatorView.frame = frame;
    [self.view addSubview:self.activityIndicatorView];
    [self addConstraint];
    [self.tableView reloadData];
 
    [self.tableView layoutIfNeeded];
    
    
   
}

-(void)addConstraint
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.tableView layoutIfNeeded];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicatorView
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0
                                                                constant:0.0]];
    
    
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicatorView
                                                                   attribute:NSLayoutAttributeCenterY 
                                                                   relatedBy:NSLayoutRelationEqual 
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeCenterY 
                                                                  multiplier:1.0 
                                                                    constant:0.0]];
    
//    UIView *superview = self.view;
//    NSDictionary *variables = NSDictionaryOfVariableBindings(self.activityIndicatorView, superview);
//    NSArray *constraints =  [NSLayoutConstraint constraintsWithVisualFormat:@"V:[superview]-(<=1)-[activityIndicatorView]"
//                                            options: NSLayoutFormatAlignAllCenterX
//                                            metrics:nil
//                                              views:variables];
//    [self.view addConstraints:constraints];
//    
//    constraints =
//    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[superview]-(<=1)-[activityIndicatorView]"
//                                            options: NSLayoutFormatAlignAllCenterY
//                                            metrics:nil
//                                              views:variables];
//    [self.view addConstraints:constraints];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refresh{

    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.activityIndicatorView startAnimating];

    
    __weak __typeof(self)weakSelf = self;
    
    [[ServiceHandler sharedInstance] getUserContent:^(UserContent *userContent) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
           [weakSelf.activityIndicatorView stopAnimating];
            weakSelf.title = userContent.title;
            weakSelf.feeds = userContent.feeds;
            [weakSelf.tableView reloadData];
        });
        
        
        
    } failure:^(NSError *error) {
        
       
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
            [weakSelf.activityIndicatorView stopAnimating];
        });
      
        
    }];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return self.feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[FeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    Feed *feed = [self.feeds objectAtIndex:indexPath.row];
    [cell configureCell:feed];
    
    NSLog(@"text lenght %@", NSStringFromCGRect(cell.detailTextLabel.frame));
    NSLog(@"feeds desc %@",feed.desc);
    
    //Download image
    cell.tag = indexPath.row;

    if (feed.imageHref.length>0 && feed.isDownloaded == NO)
    {
        cell.imageView.image = nil;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^(void) {
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:feed.imageHref]];
                                 
                                 UIImage* image = [[UIImage alloc] initWithData:imageData];
                                 if (image) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         if (cell.tag == indexPath.row) {
                                             cell.imageView.image = image;
                                             Feed *feed = [self.feeds objectAtIndex:indexPath.row];
                                             feed.isDownloaded = YES;
                                             [self saveImage:image :feed.imageHref];
                                             [cell setNeedsLayout];
                                         }
                                     });
                                 }
                                 });
    }
    else
    {
        cell.imageView.image = [self getImage:feed.imageHref];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell"];
    Feed *feed = [self.feeds objectAtIndex:indexPath.row];
    
    
    return [cell heightForFeed:feed];
}

#pragma mark - Orientation methods
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Code here will execute before the rotation begins.
    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
       
        [self.tableView reloadData];
        
    }];
}

#pragma mark - Method to save and Retrieve image

- (IBAction)saveImage :(UIImage*)img :(NSString*)imgUrl {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[imgUrl lastPathComponent]];
//    UIImage *image = imageView.image; // imageView is my image from camera
    NSData *imageData = UIImagePNGRepresentation(img);
    [imageData writeToFile:savedImagePath atomically:NO];
}

- (UIImage*)getImage :(NSString*)imgURL {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[imgURL lastPathComponent]];
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    return img;
}

@end
