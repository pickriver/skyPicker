//
//  examplePopView.m
//  skyPicker
//
//  Created by GaoYong on 15/4/3.
//  Copyright (c) 2015年 GaoYong. All rights reserved.
//

#import "examplePopView.h"

@implementation examplePopView

-(id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        itemBtn.bounds = CGRectMake(0, 0, 100, 40);
        itemBtn.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 - 60);
        [itemBtn setTitle:@"close" forState:UIControlStateNormal];
        itemBtn.backgroundColor = [UIColor whiteColor];
        [itemBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [itemBtn addTarget:self action:@selector(itemClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemBtn];
        
        UIButton *itemSelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        itemSelBtn.bounds = CGRectMake(0, 0, 100, 40);
        itemSelBtn.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        [itemSelBtn setTitle:@"select" forState:UIControlStateNormal];
        itemSelBtn.backgroundColor = [UIColor whiteColor];
        [itemSelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [itemSelBtn addTarget:self action:@selector(itemSelectClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemSelBtn];
    }
    
    return self;
}

-(void) itemClick
{
    [self closeMyPage];
}

-(void) itemSelectClick
{
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:@"1" forKey:@"id"];
    [data setObject:@"tom" forKey:@"name"];
    [self selectInfo:data];
}

@end
