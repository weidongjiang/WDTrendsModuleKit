//
//  ViewController.m
//  WDTrendsModuleKit
//
//  Created by yixiajwd on 2020/5/8.
//  Copyright © 2020 yixiajwd. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "UIColor+WDColor.h"


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

@property (nonatomic, strong) NSMutableDictionary            *itemInfoDictionary; ///< <#value#>
@property (nonatomic, strong) NSMutableDictionary            *itemObjDictionary; ///< <#value#>

@property (nonatomic, strong) NSMutableArray            *itemTempArray; ///< <#value#>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self creatUI];

}


- (void)creatUI {

    NSArray *uiArray = [self getTrendsModulePlistInfo];

    for (NSDictionary *info in uiArray) {

        NSString *itemType = [info objectForKey:itemType_key];


        // 创建
        UIView *item = [self _alloc_init_itemType:itemType];
        // 设置样式
        NSDictionary *style = [info objectForKey:style_key];
        item = [self _setItemStyle:style item:item];

        // 内存ID
        NSString *iteminfoID = [NSString stringWithFormat:@"%p",item];
        // 标记ID
        NSString *itemID = [info objectForKey:itemID_key];

        // 跟进内存ID存储 配置信息
        [self.itemInfoDictionary setValue:info forKey:iteminfoID];
        // 跟进标记ID 存储对象
        [self.itemObjDictionary setValue:item forKey:itemID];
        // 临时存储对象
        [self.itemTempArray addObject:item];

    }


    for (UIView *item in self.itemTempArray) {

        // 获取配置信息
        NSString *iteminfoID = [NSString stringWithFormat:@"%p",item];
        NSDictionary *info = [self.itemInfoDictionary objectForKey:iteminfoID];

        // 根据标记ID 获取对象的 superView
        NSString *item_superview = [info objectForKey:itemSuperview_key];
        UIView *_superview = [self.itemObjDictionary objectForKey:item_superview];
        
        if ([item_superview isEqualToString:@"default"]) {
            [self.view addSubview:item];
        }else {
            if (!_superview) {
                continue;
            }
            [_superview addSubview:item];
        }

        NSDictionary *layout = [info objectForKey:layout_key];
        [self _steItemLayout:layout item:item];

    }

}

- (UIView *)_steItemLayout:(NSDictionary *)layout item:(UIView *)item {

    if (!item) {
        return nil;
    }
    if (!item.superview) {
        return nil;
    }


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


    if (width > 0 && height > 0 && benchmark_top && benchmark_left) {
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            make.left.equalTo(item.superview).offset(benchmark_left_offset);
            make.top.equalTo(item.superview).offset(benchmark_top_offset);
        }];
    }else if (width > 0 && height > 0 && benchmark_bottom && benchmark_left) {
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            make.left.equalTo(item.superview).offset(benchmark_left_offset);
            make.bottom.equalTo(item.superview).offset(benchmark_bottom_offset);
        }];
    }else if (width > 0 && height > 0 && benchmark_bottom && benchmark_right) {
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            make.right.equalTo(item.superview).offset(benchmark_right_offset);
            make.bottom.equalTo(item.superview).offset(benchmark_bottom_offset);
        }];
    }else if (width > 0 && height > 0 && benchmark_top && benchmark_right) {
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            make.right.equalTo(item.superview).offset(benchmark_right_offset);
            make.top.equalTo(item.superview).offset(benchmark_top_offset);
        }];
    }else if (width > 0 && height > 0 && benchmark_center) {
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            make.center.equalTo(item.superview).offset(benchmark_center_offset);
        }];
    }else if (width > 0 && height > 0 && benchmark_centerX && benchmark_centerY) {
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            make.centerX.equalTo(item.superview).offset(benchmark_centerX_offset);
            make.centerY.equalTo(item.superview).offset(benchmark_centerY_offset);
        }];
    }else if (benchmark_top && benchmark_left && benchmark_bottom && benchmark_right) {
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(item.superview).offset(benchmark_top_offset);
            make.left.equalTo(item.superview).offset(benchmark_left_offset);
            make.bottom.equalTo(item.superview).offset(benchmark_bottom_offset);
            make.right.equalTo(item.superview).offset(benchmark_right_offset);
        }];
    }

    return item;
}

- (UIView *)_setItemStyle:(NSDictionary *)style item:(UIView *)item {

    NSString *backgroundColor = [style objectForKey:backgroundColor_key];
    CGFloat alpha = [[style objectForKey:alpha_key] floatValue];

    [item setBackgroundColor:[UIColor wdt_colorWithHex:backgroundColor alpha:alpha]];

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

- (NSMutableDictionary *)itemInfoDictionary {
    if (!_itemInfoDictionary) {
        _itemInfoDictionary = [[NSMutableDictionary alloc] init];
    }
    return _itemInfoDictionary;;
}

- (NSMutableArray *)itemTempArray {
    if (!_itemTempArray) {
        _itemTempArray = [[NSMutableArray alloc] init];
    }
    return _itemTempArray;
}

- (NSMutableDictionary *)itemObjDictionary {
    if (!_itemObjDictionary) {
        _itemObjDictionary = [[NSMutableDictionary alloc] init];
    }
    return _itemObjDictionary;
}

@end
