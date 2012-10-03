//
//  ViewController.m
//  ScrollSwitcher
//
//  Created by Shiny Zhu on 12-1-7.
//  Copyright (c) 2012 Pluxs. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize numberLabel;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc 
{
    [numberLabel release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //添加温度选择器。
    NumberSwitcher *zwitcher = [[NumberSwitcher alloc] initWithOrigin:CGPointMake(100, 100) 
                                                        minimumNumber:18 
                                                        maximumNumber:29 
                                                       selectedNumber:23];
    zwitcher.delegate = self;
    [self.view addSubview:zwitcher];
    [zwitcher release];
    
    //更新方式见协议方法。Line82
    
    self.numberLabel.text = @"23ºc";
}

- (void)viewDidUnload
{
    [self setNumberLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Number switcher delegate

- (void)numberSwitcher:(NumberSwitcher *)switcher didUpdateToNumber:(NSInteger)number
{
    NSLog(@"Temperature updated to %i", number);
    self.numberLabel.text = [NSString stringWithFormat:@"%iºc", number];
}

@end
