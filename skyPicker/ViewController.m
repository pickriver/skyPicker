//
//  ViewController.m
//  skyPicker
//  弹出方向可自定义的popview  PickerDirection：决定弹出方向
//  Created by GaoYong on 15/4/3.
//  Copyright (c) 2015年 GaoYong. All rights reserved.
//

#import "ViewController.h"
#import "PickerDataItem.h"
#import "skyPicker.h"
#import "PopBasicView.h"
#import "examplePopView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

//    [self createSkyPicker:Top];
    
    [self createSkyPicker:Down];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createSkyPicker:(PickerDirection) direction
{
    NSMutableArray *pikeDataList = [NSMutableArray array];
    
    PopBasicView *popView1 = [[PopBasicView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 400)];
    popView1.backgroundColor = [UIColor greenColor];
    PickerDataItem *item1 = [[PickerDataItem alloc] init:@"Color" itemImg:nil selectPickClick:^(id data) {
        
    } itemUI:popView1];
    [pikeDataList addObject:item1];
    
    
    examplePopView *popView2 = [[examplePopView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 350)];
    popView2.backgroundColor = [UIColor redColor];
    PickerDataItem *item2 = [[PickerDataItem alloc] init:@"Time" itemImg:nil selectPickClick:^(id data) {
        
        NSLog(@"selectData:%@",data);
        
    } itemUI:popView2];
    [pikeDataList addObject:item2];
    
    
    PopBasicView *popView3 = [[PopBasicView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 170)];
    popView3.backgroundColor = [UIColor yellowColor];
    
    PickerDataItem *item3 = [[PickerDataItem alloc] init:@"Sky" itemImg:nil selectPickClick:^(id data) {
        
    } itemUI:popView3];
    [pikeDataList addObject:item3];
    
    
    PopBasicView *popView4 = [[PopBasicView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 90)];
    popView4.backgroundColor = [UIColor blueColor];
    
    PickerDataItem *item4 = [[PickerDataItem alloc] init:@"Heart" itemImg:nil selectPickClick:^(id data) {
        
    } itemUI:popView4];
    
    [pikeDataList addObject:item4];
    
    skyPicker *picker = nil;
    if (direction == Top)
    {
        picker = [[skyPicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 49 , self.view.bounds.size.width, 49) direction:Top itemList:pikeDataList];
    }
    else
    {
        picker = [[skyPicker alloc] initWithFrame:CGRectMake(0, 20 , self.view.bounds.size.width, 49) direction:Down itemList:pikeDataList];
    }
    
    [self.view addSubview:picker];
}

@end
