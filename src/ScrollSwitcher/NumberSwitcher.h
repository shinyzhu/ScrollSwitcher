//
//  NumberSwitcher.h
//  ScrollSwitcher
//
//  Created by Shiny Zhu on 12-1-7.
//  Copyright (c) 2012 Pluxs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NumberSwitcherDelegate;

@interface NumberSwitcher : UIView

@property (nonatomic, assign) id<NumberSwitcherDelegate> delegate;

//构造函数，指定坐标原点（控件大小固定为 575x60 ）和最小、最大、当前选中的数字。
- (id)initWithOrigin:(CGPoint)origin minimumNumber:(NSInteger)min maximumNumber:(NSInteger)max selectedNumber:(NSInteger)selected;

@end


@protocol NumberSwitcherDelegate <NSObject>

@optional

//数字改变（滑动或点击）后被调用，每经过滑块中间的时候都会引发。
- (void)numberSwitcher:(NumberSwitcher *)switcher didUpdateToNumber:(NSInteger)number;

@end