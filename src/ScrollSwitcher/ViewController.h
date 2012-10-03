//
//  ViewController.h
//  ScrollSwitcher
//
//  Created by Shiny Zhu on 12-1-7.
//  Copyright (c) 2012 Pluxs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberSwitcher.h"

@interface ViewController : UIViewController<NumberSwitcherDelegate>

@property (retain, nonatomic) IBOutlet UILabel *numberLabel;

@end
