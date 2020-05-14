//
//  ViewController.m
//  WDTrendsModuleKit
//
//  Created by yixiajwd on 2020/5/8.
//  Copyright © 2020 yixiajwd. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"


static NSString *itemType_key = @"itemType";
static NSString *itemSuperview_key = @"itemSuperview";
static NSString *itemID_key = @"itemID";




static NSString *layout_key = @"layout";

static NSString *height_key = @"height";
static NSString *width_key = @"width";

static NSString *benchmark_top_key = @"benchmark_top";
static NSString *benchmark_top_offset_key = @"benchmark_top_offset";
static NSString *benchmark_left_key = @"benchmark_left";
static NSString *benchmark_left_offset_key = @"benchmark_left_offset";
static NSString *benchmark_bottom_key = @"benchmark_bottom";
static NSString *benchmark_bottom_offset_key = @"benchmark_bottom_offset";
static NSString *benchmark_right_key = @"benchmark_right";
static NSString *benchmark_right_offset_key = @"benchmark_right_offset";

static NSString *benchmark_center_key = @"benchmark_center";
static NSString *benchmark_center_offset_key = @"benchmark_center_offset";
static NSString *benchmark_centerX_key = @"benchmark_centerX";
static NSString *benchmark_centerX_offset_key = @"benchmark_centerX_offset";
static NSString *benchmark_centerY_key = @"benchmark_centerY";
static NSString *benchmark_centerY_offset_key = @"benchmark_centerY_offset";




static NSString *style_key = @"style";
static NSString *backgroundColor_key = @"backgroundColor";
static NSString *alpha_key = @"alpha";




@interface ViewController ()

@property (nonatomic, strong) NSMutableDictionary            *itemDictionary; ///< <#value#>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.



    UIButton *itemButton = [[UIButton alloc] init];
    [itemButton setTitle:@"jj" forState:UIControlStateNormal];
    [itemButton setBackgroundColor:[UIColor yellowColor]];


    [self creatUI];

}


- (void)creatUI {

    NSArray *uiArray = [self getTrendsModulePlistInfo];

    for (NSDictionary *obj in uiArray) {

        NSString *itemType = [obj objectForKey:itemType_key];
        NSString *itemID = [obj objectForKey:itemID_key];
        NSString *itemSuperview = [obj objectForKey:itemSuperview_key];


        UIView *item = [self _alloc_init_itemType:itemType];
        [self.itemDictionary setValue:item forKey:itemID];

        if ([itemSuperview isEqualToString:@"default"]) {
            [self.view addSubview:item];
        }else {
            UIView *_itemSuperview = [self.itemDictionary objectForKey:itemSuperview];
            if (!_itemSuperview) {
                return;
            }
            [_itemSuperview addSubview:item];
        }

        NSDictionary *style = [obj objectForKey:style_key];
        item = [self _setItemStyle:style item:item];

        NSDictionary *layout = [obj objectForKey:layout_key];
        item = [self _steItemLayout:layout item:item];

    }

}

- (UIView *)_steItemLayout:(NSDictionary *)layout item:(UIView *)item {


    CGFloat width = [[layout objectForKey:width_key] floatValue];
    CGFloat height = [[layout objectForKey:height_key] floatValue];

    // 顶
    BOOL benchmark_top = [[layout objectForKey:benchmark_top_key] boolValue];
    CGFloat benchmark_top_offset = [[layout objectForKey:benchmark_top_offset_key] floatValue];

    // 左
    BOOL benchmark_left = [[layout objectForKey:benchmark_left_key] boolValue];
    CGFloat benchmark_left_offset = [[layout objectForKey:benchmark_left_offset_key] floatValue];

    // 低
    BOOL benchmark_bottom = [[layout objectForKey:benchmark_bottom_key] boolValue];
    CGFloat benchmark_bottom_offset = [[layout objectForKey:benchmark_bottom_offset_key] floatValue];

    // 右
    BOOL benchmark_right = [[layout objectForKey:benchmark_right_key] boolValue];
    CGFloat benchmark_right_offset = [[layout objectForKey:benchmark_right_offset_key] floatValue];

    // 中
    BOOL benchmark_center = [[layout objectForKey:benchmark_center_key] boolValue];
    CGFloat benchmark_center_offset = [[layout objectForKey:benchmark_center_offset_key] floatValue];

    // 中X
    BOOL benchmark_centerX = [[layout objectForKey:benchmark_centerX_key] boolValue];
    CGFloat benchmark_centerX_offset = [[layout objectForKey:benchmark_centerX_offset_key] floatValue];

    // 中Y
    BOOL benchmark_centerY = [[layout objectForKey:benchmark_centerY_key] boolValue];
    CGFloat benchmark_centerY_offset = [[layout objectForKey:benchmark_centerY_offset_key] floatValue];


    [item mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
        make.left.equalTo(item.superview).offset(benchmark_left_offset);
        make.top.equalTo(item.superview).offset(benchmark_top_offset);
    }];

    return item;
}

- (UIView *)_setItemStyle:(NSDictionary *)style item:(UIView *)item {

    NSString *backgroundColor = [style objectForKey:backgroundColor_key];
    CGFloat alpha = [[style objectForKey:alpha_key] floatValue];


    [item setBackgroundColor:[UIColor greenColor]];
    item.alpha = alpha;

    return item;
}

- (UIView *)_alloc_init_itemType:(NSString *)itemType {

    UIView *item = nil;
    if ([itemType isEqualToString:@"button"]) {
        item = [[UIButton alloc] init];
    }

    return item;
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

- (NSMutableDictionary *)itemDictionary {
    if (!_itemDictionary) {
        _itemDictionary = [[NSMutableDictionary alloc] init];
    }
    return _itemDictionary;;
}

@end
