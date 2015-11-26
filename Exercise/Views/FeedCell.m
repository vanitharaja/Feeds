//
//  FeedCell.m
//  Exercise
//
//  Created by Vanitha on 23/11/15.
//  Copyright © 2015 Vanitha. All rights reserved.
//

#import "FeedCell.h"


#define kDEFAULT_HEIGHT 21
#define kMORE_HEIGHT 10

@interface FeedCell()

@property(nonatomic,strong) UIImageView *_imageView;
@property(nonatomic,strong) UILabel *_titleLabel;
@property(nonatomic,strong) UILabel *_detailTextLabel;


@end

@implementation FeedCell


- (void)awakeFromNib {
    // Initialization code
    
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    [self addSubviews];
    [self addConstraints];
    self.backgroundColor = [UIColor grayColor];
    [self.contentView layoutIfNeeded];
    
    
    return self;
}

-(UILabel*)textLabel{
   return self._titleLabel;
}

-(UILabel*)detailTextLabel{
    return self._detailTextLabel;
}

-(UIImageView*)imageView{
    return self._imageView;
}


-(void)addConstraints{
    
    //_titleLabel  Constraint
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self._titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:15]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self._titleLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-15]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self._titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:5]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self._titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:21]];
    
    
    
    //_detailTextLabel  Constraint
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self._detailTextLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:15]];
    
   [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self._detailTextLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self._imageView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self._detailTextLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self._titleLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:25]];
    
    
    
    //_imageView Constraint
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self._imageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-15]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self._imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self._titleLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:25]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self._imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:120]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self._imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:90]];
    

    [self layoutIfNeeded];
}


-(void)addSubviews{
    
    self._titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, [[UIScreen mainScreen] bounds].size.width - 30 , 21)];
    self._titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    self._titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self._detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self._titleLabel.frame) + 10, [[UIScreen mainScreen] bounds].size.width - (120 + 30) , 21)];
    self._detailTextLabel.numberOfLines = 0;
    self._detailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    //self._detailTextLabel.backgroundColor = [UIColor redColor];
    
    self._imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self._titleLabel.frame.origin.x + 10 , self._detailTextLabel.frame.origin.y, 120 , 90)];
    self._imageView.image = [UIImage imageNamed:@"image-not-available-thumbnail"];
    self._imageView.contentMode = UIViewContentModeScaleToFill;
     self._imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:self._titleLabel];
    [self.contentView addSubview:self._detailTextLabel];
    [self.contentView addSubview:self._imageView];
    
    
}

/** Method to bind the details from WS to the Tablecell **/

-(void)configureCell:(Feed*)feed{
    
    if (feed.title.length > 0){
        self._titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        self._titleLabel.text = feed.title;
    }
    else{
        self._titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:10];
        self._titleLabel.text = @"Title is not provided";

    }
    
    if (feed.desc.length > 0){
        self._detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        self._detailTextLabel.text = feed.desc;
    }
    else{
        self._detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:10];
        self._detailTextLabel.text = @"Content is not provided";
    }
    [self layoutIfNeeded];
}

/** Method to find the height of the feed description, so as to determine the height of the cell **/

- (CGFloat)heightForFeed:(Feed*)feed{
    
    CGFloat ratioOfLayoutWidth = ([[UIScreen mainScreen] bounds].size.width - 120-15 -15);/// [[UIScreen mainScreen] bounds].size.width
    CGFloat height = [self desiredHightText:feed.desc maxWidth:ratioOfLayoutWidth];
    if (height+30<130)
        return 130;
    
    return height+30;
}


-(CGFloat)desiredHightText:(NSString*)text maxWidth:(CGFloat)maxWidth{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    CGRect rect = [text
                      boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                      attributes:@{
                                   NSFontAttributeName : [UIFont fontWithName:@"Helvetica" size:15.0f],
                                   NSParagraphStyleAttributeName : paragraphStyle
                                   }
                      context:nil];

    
    return ceilf(rect.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
