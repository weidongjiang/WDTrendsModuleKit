//
//  WDTrendsModuleView.m
//  WDTrendsModuleKit
//
//  Created by yixiajwd on 2020/5/15.
//  Copyright © 2020 yixiajwd. All rights reserved.
//

#import "WDTrendsModuleView.h"
#import "Masonry.h"
#import "UIColor+WDColor.h"
#import "WDTrendsModuleConfign.h"


@interface WDTrendsModuleView ()

@property (nonatomic, strong) NSMutableDictionary            *itemInfoDictionary; ///< <#value#>
@property (nonatomic, strong) NSMutableDictionary            *itemObjDictionary; ///< <#value#>
@property (nonatomic, strong) NSMutableArray                 *itemTempArray; ///< <#value#>

@end

@implementation WDTrendsModuleView
- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)initTrendsModuleViewWith:(NSArray *)trendsModuleArray {



    for (NSDictionary *info in trendsModuleArray) {

        NSString *itemType = [info objectForKey:itemType_key];


        // 创建
        UIView *item = [self _alloc_init_itemType:itemType];
        // 设置样式
        NSDictionary *style = [info objectForKey:style_key];
        item = [self _setItemStyle:style item:item itemType:itemType];

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
            [self addSubview:item];
        }else {
            if (!_superview) {
                continue;
            }
            [_superview addSubview:item];
        }

        // 布局
        NSDictionary *layout = [info objectForKey:layout_key];
        [self _steItemLayout:layout item:item];

        // 事件
        NSDictionary *action = [info objectForKey:action_key];
        [self _setAction:action item:item];

        // 数据显示
        [self _setDataWithItem:item];

    }

}


- (void)_setAction:(NSDictionary *)action item:(UIView *)item {

    NSString *actionType = [action objectForKey:actionType_key];
    if ([actionType isEqualToString:WDTrendsModuleActionTypeNone]) {
        return;
    }

    if ([actionType isEqualToString:WDTrendsModuleActionTypeTap]) {
        // 添加 点击图片放大图片
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapGestureAction:)];
        [item addGestureRecognizer:tapGesture];
    }

    if ([actionType isEqualToString:WDTrendsModuleActionTypeTowTap]) {
        //双击放大缩小手势
        UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTowTapGestureAction:)];
        tapGesture2.numberOfTapsRequired = 2;
        tapGesture2.numberOfTouchesRequired = 1;
        [item addGestureRecognizer:tapGesture2];
    }

    if ([actionType isEqualToString:WDTrendsModuleActionTypeLongTap]) {
        // 添加 没有放大的图片 删除功能
       UILongPressGestureRecognizer *longPressGestureM = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(itemLongPressGestureAction:)];
       longPressGestureM.minimumPressDuration = 1;
       longPressGestureM.allowableMovement = 15;
       longPressGestureM.numberOfTouchesRequired = 1;
       [item addGestureRecognizer:longPressGestureM];
    }

}

- (void)itemTapGestureAction:(UITapGestureRecognizer *)tap {

    NSString *iteminfoID = [NSString stringWithFormat:@"%p",tap.view];
    NSDictionary *info = [self.itemInfoDictionary objectForKey:iteminfoID];
    NSDictionary *action = [info objectForKey:action_key];
    NSString *actionScheme = [action objectForKey:actionScheme_key];
    NSLog(@"actionScheme-1-%@",actionScheme);

}

- (void)itemTowTapGestureAction:(UITapGestureRecognizer *)tap {

    NSString *iteminfoID = [NSString stringWithFormat:@"%p",tap.view];
    NSDictionary *info = [self.itemInfoDictionary objectForKey:iteminfoID];
    NSDictionary *action = [info objectForKey:action_key];
    NSString *actionScheme = [action objectForKey:actionScheme_key];
    NSLog(@"actionScheme-2-%@",actionScheme);

}

- (void)itemLongPressGestureAction:(UILongPressGestureRecognizer *)lonp {

    NSString *iteminfoID = [NSString stringWithFormat:@"%p",lonp.view];
    NSDictionary *info = [self.itemInfoDictionary objectForKey:iteminfoID];
    NSDictionary *action = [info objectForKey:action_key];
    NSString *actionScheme = [action objectForKey:actionScheme_key];
    NSLog(@"actionScheme-3-%@",actionScheme);

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

- (UIView *)_setItemStyle:(NSDictionary *)style item:(UIView *)item itemType:(NSString *)itemType {

    NSString *backgroundColor = [style objectForKey:backgroundColor_key];
    CGFloat alpha = [[style objectForKey:alpha_key] floatValue];
    [item setBackgroundColor:[UIColor wdt_colorWithHex:backgroundColor alpha:alpha]];

    NSString *text_color = [style objectForKey:text_color_key];
    CGFloat text_font = [[style objectForKey:text_font_key] floatValue];
    if ([itemType isEqualToString:@"button"]) {
        UIButton *_item = (UIButton *)item;
        [_item setTintColor:[UIColor wdt_colorWithHex:text_color alpha:1]];
        _item.titleLabel.font = [UIFont systemFontOfSize:text_font];
    }
    
    if ([itemType isEqualToString:@"label"]) {
        UILabel *_item = (UILabel *)item;
        _item.textColor = [UIColor wdt_colorWithHex:text_color alpha:1];
        _item.font = [UIFont systemFontOfSize:text_font];
    }
    
    if ([itemType isEqualToString:@"imageview"]) {
        UIImageView *_item = (UIImageView *)item;
    }

    
    BOOL isSetLayer = [[style objectForKey:isSetLayer_key] boolValue];
    NSString *borderColor = [style objectForKey:borderColor_key];
    CGFloat borderWidth = [[style objectForKey:borderWidth_key] floatValue];
    CGFloat cornerRadius = [[style objectForKey:cornerRadius_key] floatValue];
    if (isSetLayer) {
        item.layer.masksToBounds = YES;
        if (borderColor.length > 0) {
            item.layer.borderColor = [UIColor wdt_colorWithHex:borderColor].CGColor;
        }
        if (borderWidth > 0) {
            item.layer.borderWidth = borderWidth;
        }
        if (cornerRadius > 0) {
            item.layer.cornerRadius = cornerRadius;
        }
    }
    
    return item;
}

- (void)_setDataWithItem:(UIView *)item {
    NSString *iteminfoID = [NSString stringWithFormat:@"%p",item];
    NSDictionary *info = [self.itemInfoDictionary objectForKey:iteminfoID];
    NSString *itemType = [info objectForKey:itemType_key];

    NSDictionary *data = [info objectForKey:data_key];
    NSString *text = [data objectForKey:text_key];
    NSString *imageNamed = [data objectForKey:imageNamed_key];
    NSString *imageUrl = [data objectForKey:imageUrl_key];


    if ([itemType isEqualToString:@"button"]) {
       UIButton *_item = (UIButton *)item;
       [_item setTitle:text forState:UIControlStateNormal];
    }
    if ([itemType isEqualToString:@"label"]) {
        UILabel *_item = (UILabel *)item;
        _item.text = text;
    }
    if ([itemType isEqualToString:@"imageview"]) {
        UIImageView *_item = (UIImageView *)item;
        if (imageNamed.length > 0) {
            _item.image = [UIImage imageNamed:imageNamed];
        }else if (imageUrl.length > 0) {
            
        }
    }
    
}

- (UIView *)_alloc_init_itemType:(NSString *)itemType {

    UIView *item = nil;
    if ([itemType isEqualToString:@"button"]) {
        item = [[UIButton alloc] init];
    }else if ([itemType isEqualToString:@"label"]) {
        item = [[UILabel alloc] init];
    }else if ([itemType isEqualToString:@"imageview"]) {
        item = [[UIImageView alloc] init];
    }else {
        item = [[UIView alloc] init];
    }
    return item;
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
