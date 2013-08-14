//
//  SidebarTopLevelView.m
//  WordPress
//
//  Created by Sendhil Panchadsaram on 8/13/13.
//  Copyright (c) 2013 WordPress. All rights reserved.
//

#import "SidebarTopLevelView.h"
#import "UIImageView+Gravatar.h"

@interface SidebarTopLevelView()

@property (nonatomic, strong) IBOutlet UIImageView *blavatarImage;
@property (nonatomic, strong) IBOutlet UILabel *blogTitleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *chevron;

@end

@implementation SidebarTopLevelView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[NSBundle mainBundle] loadNibNamed:@"SidebarTopLevelView" owner:self options:nil][0];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        
        NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:0 views:views];
        [self addConstraints:horizontalConstraints];
        
        NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:0 views:views];
        [self addConstraints:verticalConstraints];
        
    }
    return self;
}

- (void)setBlogTitle:(NSString *)blogTitle
{
    if (_blogTitle != blogTitle) {
        _blogTitle = blogTitle;
        self.blogTitleLabel.text = blogTitle;
        [self setNeedsLayout];
        [self setNeedsUpdateConstraints];
    }
}

- (void)setBlavatarUrl:(NSString *)url
{
    if (_blavatarUrl != url) {
        _blavatarUrl = url;
        [self setNeedsLayout];
        [self setNeedsUpdateConstraints];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.blogTitleLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0];
    
    NSURL *blogURL = [NSURL URLWithString:self.blavatarUrl];
    [self.blavatarImage setImageWithBlavatarUrl:[blogURL host] isWPcom:self.isWPCom];
}

@end
