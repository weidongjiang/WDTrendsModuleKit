//
//  ViewController.m
//  WDTrendsModuleKit
//
//  Created by yixiajwd on 2020/5/8.
//  Copyright © 2020 yixiajwd. All rights reserved.
//

#import "ViewController.h"
#import "WDTrendsModuleView.h"


#define WDScreenWidth [UIScreen mainScreen].bounds.size.width
#define WDScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    WDTrendsModuleView *moduleView = [[WDTrendsModuleView alloc] initWithFrame:CGRectMake(10, 100, WDScreenWidth - 20, 80)];
    [moduleView initTrendsModuleViewWith:[self getTrendsModulePlistInfo]];
    [self.view addSubview:moduleView];

}

- (NSArray *)getTrendsModulePlistInfo {

    NSString *trendsModulePlist = [[NSBundle mainBundle] pathForResource:@"TrendsModule" ofType:@"plist"];

    BOOL isExisted = [[NSFileManager defaultManager] fileExistsAtPath:trendsModulePlist];
    if (!isExisted) {
        NSAssert(NO, @"TrendsModule Plist is not exists : %@", trendsModulePlist);
        return nil;
    }

    NSArray *info = [NSArray arrayWithContentsOfFile:trendsModulePlist];

    if (!info) {
        NSAssert(NO, @"TrendsModule Plist is not well-formed : %@", trendsModulePlist);
        return nil;
    }

    return info;
}

@end
