//
//  PopBasicView.m
//  skyPicker
//
//  Created by GaoYong on 15/3/9.
//  Copyright (c) 2015年 GaoYong. All rights reserved.
//

#import "PopBasicView.h"
#import "skyPicker.h"

@implementation PopBasicView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.clipsToBounds = YES;
    }
    
    return self;
}

-(void) closeMyPage
{
    if (![self.superview isKindOfClass:[skyPicker class]])
    {
        return;
    }
    
    skyPicker *yySuperView = (skyPicker *)self.superview;
    
    if (yySuperView && [yySuperView respondsToSelector:@selector(closeTopView:)])
    {
        [yySuperView closeTopView:YES];
    }
}

-(void) selectInfo:(id) data
{
    if (![self.superview isKindOfClass:[skyPicker class]])
    {
        return;
    }
    
    skyPicker *skySuperView = (skyPicker *)self.superview;
    [skySuperView selectInfo:data];
    [skySuperView closeTopView:YES];
}

@end
