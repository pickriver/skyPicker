//
//  skyPicker.m
//  skyPicker
//
//  Created by GaoYong on 15/3/5.
//  Copyright (c) 2015年 GaoYong. All rights reserved.
//

#import "skyPicker.h"
#import "PickerDataItem.h"

@interface skyPicker ()
{
    UIView *topView;     //当前弹出试图
    UIView *markView;    //遮罩层
    UIView *barView;     //底部bar
    CGRect basicFrame;   //初始化的frame
}

@property (nonatomic,retain) NSArray *itemList;
@property (nonatomic) PickerDirection direction;
@property (atomic) int selectIndex;

@end

@implementation skyPicker

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


-(void) dealloc
{
    [super dealloc];
    
    self.itemList = nil;
}

-(id) initWithFrame:(CGRect)frame direction:(PickerDirection) direction_ itemList:(NSArray *) itemList_
{
    if (self = [super initWithFrame:frame])
    {
        basicFrame = frame;
        self.clipsToBounds = YES;
        self.direction = direction_;
        self.itemList = itemList_;
        self.selectIndex = -1;   //收起状态
        
        [self createBarUI];
    }
    
    return self;
}

-(void) createBarUI
{
    barView = [[UIView alloc] initWithFrame:self.bounds];
    barView.backgroundColor = [UIColor whiteColor];
    [self addSubview:barView];
    [barView release];
    
    CGFloat btnSplitImgWidth = 1/[UIScreen mainScreen].scale;
    CGFloat btnWidth = (self.frame.size.width - btnSplitImgWidth * (_itemList.count - 1)) / _itemList.count;
    
    for (int i = 0; i < _itemList.count; i++)
    {
        PickerDataItem *pdi = [_itemList objectAtIndex:i];
        
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        itemBtn.frame = CGRectMake(i * btnWidth + btnSplitImgWidth * i, 0, btnWidth, barView.frame.size.height);
        [itemBtn setTitle:pdi.title forState:UIControlStateNormal];
        [itemBtn setImage:pdi.itemImg forState:UIControlStateNormal];
        itemBtn.backgroundColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1];
        itemBtn.tag = i;
        itemBtn.adjustsImageWhenHighlighted = NO;
        [itemBtn setTitleColor:[UIColor colorWithRed:60/255.0f green:60/255.0f blue:60/255.0f alpha:1] forState:UIControlStateNormal];
        itemBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [itemBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:itemBtn];
        
        //分割线
        if (i < _itemList.count - 1)
        {
            UIImageView *splitImg = [[UIImageView alloc] initWithFrame:CGRectMake(btnWidth * (i + 1) + btnSplitImgWidth * i, 0, btnSplitImgWidth, barView.frame.size.height)];
            splitImg.backgroundColor = [UIColor colorWithRed:155/255.0f green:155/255.0f blue:155/255.0f alpha:1];
            [barView addSubview:splitImg];
            [splitImg release];
        }
    }
}

-(void) itemClick:(id) sender
{
    @synchronized(self)
    {
        int nextSelectIndex = (int)((UIButton *)sender).tag;
        
        if(nextSelectIndex >= _itemList.count)
            return;
        
        //弹出新的
        if (self.selectIndex == -1)
        {
            [self showTopView:[self popNewTopView:nextSelectIndex]];
            self.selectIndex = nextSelectIndex;
        }
        else if (self.selectIndex >= 0)
        {
            //收起当前
            if (self.selectIndex == nextSelectIndex)
            {
                [self closeTopView:YES];
            }
            else
            {
                //收起当前
                [self closeTopView:NO];
                //弹出新的
                [self showTopView:[self popNewTopView:nextSelectIndex]];
                self.selectIndex = nextSelectIndex;
            }
        }
    }
}

-(UIView *) popNewTopView:(int) nextSelectIndex
{
    PickerDataItem *selectItem = [_itemList objectAtIndex:nextSelectIndex];
    
    return selectItem.itemUI;
}

-(void) showTopView:(UIView *) newTopView
{
    [self.superview bringSubviewToFront:self];
    
    if (newTopView == nil)
    {
        return;
    }
    
    if (topView == newTopView)
    {
        [self closeTopView:YES];
        return;
    }
    
    if (topView)
    {
        [topView removeFromSuperview];
        topView = nil;
    }
    
    topView = newTopView;
    [self insertSubview:topView belowSubview:barView];
    
    if (markView)
    {
        [markView removeFromSuperview];
        markView = nil;
    }
    
    if (!markView)
    {
        if (_direction == Top)
        {
            markView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.superview.bounds.size.height - barView.bounds.size.height)];
            
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - markView.bounds.size.height, self.bounds.size.width, self.superview.bounds.size.height);
            
            barView.frame = CGRectMake(barView.frame.origin.x, markView.bounds.size.height, barView.frame.size.width, barView.frame.size.height);
        }
        else
        {
            markView = [[UIView alloc] initWithFrame:CGRectMake(0, barView.bounds.size.height, self.bounds.size.width, self.superview.bounds.size.height - barView.bounds.size.height)];
            
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, self.superview.bounds.size.height);
        }
        
        markView.backgroundColor = [UIColor blackColor];
        markView.alpha = 0;
        [self insertSubview:markView belowSubview:topView];
        [markView release];
        
        UITapGestureRecognizer *closeTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTapGesEvent)];
        markView.userInteractionEnabled = YES;
        [markView addGestureRecognizer:closeTapGes];
        [closeTapGes release];
    }
    
    CGFloat topViewHeight = topView.frame.size.height;
    
    if (_direction == Top)
    {
        topView.frame = CGRectMake(topView.frame.origin.x, barView.frame.origin.y, barView.bounds.size.width, 0);
    }
    else
    {
        topView.frame = CGRectMake(topView.frame.origin.x, barView.frame.origin.y + barView.frame.size.height, barView.bounds.size.width, 0);
    }
    
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        markView.alpha = 0.6;
        
        if (_direction == Top)
        {
            topView.frame = CGRectMake(topView.frame.origin.x, topView.frame.origin.y - topViewHeight, topView.frame.size.width, topViewHeight);
        }
        else
        {
            topView.frame = CGRectMake(topView.frame.origin.x, topView.frame.origin.y, topView.frame.size.width, topViewHeight);
        }
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void) closeTapGesEvent
{
    [self closeTopView:YES];
}

-(void) closeTopView:(BOOL) animated
{
    if (!topView || !markView)
    {
        return;
    }
    
    if (animated)
    {
        CGFloat topViewHeight = topView.bounds.size.height;
        [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            markView.alpha = 0;
            if (_direction == Top)
            {
                topView.frame = CGRectMake(topView.frame.origin.x, barView.frame.origin.y, barView.bounds.size.width, 0);
            }
            else
            {
                topView.frame = CGRectMake(topView.frame.origin.x, barView.frame.origin.y, barView.bounds.size.width, 0);
            }
            
        }completion:^(BOOL finished)
         {
             self.frame = basicFrame;
             barView.frame = self.bounds;
             
             [markView removeFromSuperview];
             markView = nil;
             
             [topView removeFromSuperview];
             topView.bounds = CGRectMake(0, 0, topView.bounds.size.width, topViewHeight);
             topView = nil;
             
             self.selectIndex = -1;
         }];
    }
    else
    {
        markView.alpha = 0;
        if (_direction == Top)
        {
            topView.frame = CGRectMake(topView.frame.origin.x, barView.frame.origin.y, barView.bounds.size.width, topView.frame.size.height);
        }
        else
        {
            topView.frame = CGRectMake(topView.frame.origin.x, barView.frame.origin.y - topView.frame.size.height, barView.bounds.size.width, topView.frame.size.height);
        }
        
        self.frame = basicFrame;
        barView.frame = self.bounds;
        
        [markView removeFromSuperview];
        markView = nil;
        
        [topView removeFromSuperview];
        topView = nil;
        
        self.selectIndex = -1;
    }
}

-(void) selectInfo:(id) data
{
    UIButton *selectBtn = nil;
    for (id temControl in barView.subviews)
    {
        if ([temControl isKindOfClass:[UIButton class]])
        {
            UIButton *itemBtn = temControl;
            
            //选中
            if (_selectIndex == itemBtn.tag)
            {
                selectBtn = itemBtn;
                break;
            }
        }
    }
    
    PickerDataItem *selectItem = [_itemList objectAtIndex:_selectIndex];
    
    if (selectBtn && selectItem && selectItem.selectPickClick)
    {
        selectItem.selectPickClick(data);
    }
}


@end
