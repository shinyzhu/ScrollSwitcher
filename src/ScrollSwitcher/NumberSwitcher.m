//
//  NumberSwitcher.m
//  ScrollSwitcher
//
//  Created by Shiny Zhu on 12-1-7.
//  Copyright (c) 2012 Pluxs. All rights reserved.
//

#import "NumberSwitcher.h"
#import <QuartzCore/QuartzCore.h>

#define kLabelFontSizeNormal    34
#define kLabelFontSizeBig       42

@interface NumberSwitcher()<UIScrollViewDelegate>
{
    UIScrollView *containerView;
    NSInteger minimumNumber, maximumNumber, selectedNumber;
    
    NSMutableArray *numberLabels;//holds each number to resize font
}

- (void)didNumberLabelTap:(UITapGestureRecognizer *)gesture;
- (NSInteger)indexByOffsetOfScrollView:(UIScrollView *)scrollView;
- (void)moveToIndex:(NSInteger)index;
- (void)resizeNumberLabelAtIndex:(NSInteger)index;
- (void)fixScroll:(UIScrollView *)scrollView;

@end

@implementation NumberSwitcher
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithOrigin:frame.origin minimumNumber:18 maximumNumber:29 selectedNumber:23];
}

- (id)initWithOrigin:(CGPoint)origin minimumNumber:(NSInteger)min maximumNumber:(NSInteger)max selectedNumber:(NSInteger)selected
{
    CGRect realFrame;
    realFrame.origin = origin;
    realFrame.size = CGSizeMake(575, 60);
    
    self = [super initWithFrame:realFrame];
    if (self) {
        minimumNumber = min;
        maximumNumber = max;
        
        selectedNumber = selected;
        
        if (selectedNumber < minimumNumber) {
            selectedNumber = minimumNumber;
        }
        
        if (selectedNumber > maximumNumber) {
            selectedNumber = maximumNumber;
        }
        
        NSInteger selectedIndex = selectedNumber - minimumNumber;
        
        UIImageView *bgBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"temp_bg"]];
		[self addSubview:bgBar];
		[bgBar release];
        
        UIImageView *bgMask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"temp_bg_mask"]];
        bgMask.layer.opacity = 0.75;
		[self addSubview:bgMask];
		[bgMask release];
        
        NSInteger count = maximumNumber - minimumNumber + 1;
        CGRect containerFrame = CGRectMake(11, 0, 553, 60);
        CGRect contentFrame = CGRectMake(0, 0, 79 * count, 60);
        
        containerView = [[UIScrollView alloc] initWithFrame:containerFrame];
        containerView.contentSize = contentFrame.size;
        containerView.contentInset = UIEdgeInsetsMake(0, 79 * 3, 0, 79 * 3);
        containerView.contentOffset = CGPointMake(79 * (selectedNumber - minimumNumber - 3), 0);
        containerView.showsHorizontalScrollIndicator = NO;
        containerView.delegate = self;
        
        numberLabels = [[NSMutableArray alloc] initWithCapacity:count];
        
        UIView *labelsView = [[UIView alloc] initWithFrame:contentFrame];
        labelsView.backgroundColor = [UIColor clearColor];
        
        CGRect labelFrame;
        labelFrame.size = CGSizeMake(79, 40);

        for (int i = 0; i < count; i++) {
            labelFrame.origin = CGPointMake(i * 79, 10);
            
			UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
			label.backgroundColor = [UIColor clearColor];
			label.text = [NSString stringWithFormat:@"%i", i + minimumNumber];
			label.textColor = [UIColor blackColor];
			label.font = [UIFont boldSystemFontOfSize:i == selectedIndex ? kLabelFontSizeBig : kLabelFontSizeNormal];
			label.textAlignment = UITextAlignmentCenter;
			label.userInteractionEnabled = YES;
			
			UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                         action:@selector(didNumberLabelTap:)];
			[label addGestureRecognizer:tapGesture];
			[tapGesture release];
			
			[labelsView addSubview:label];
            
            [numberLabels addObject:label];
			
			[label release];
        }
        
        [containerView addSubview:labelsView];
        [labelsView release];
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)dealloc
{
    [containerView release];
    [numberLabels release];
    
    [super dealloc];
}

#pragma mark - Number logic

- (void)didNumberLabelTap:(UITapGestureRecognizer *)gesture
{
	UILabel *selectedNumberLabel = (UILabel *)gesture.view;
    NSInteger number = [selectedNumberLabel.text intValue];
    
    NSInteger index = number - minimumNumber;
    
    [self moveToIndex:index];
}

- (NSInteger)indexByOffsetOfScrollView:(UIScrollView *)scrollView
{
    NSInteger maxIndex = maximumNumber - minimumNumber;
    
    CGPoint offset = scrollView.contentOffset;
    NSInteger index = roundf((offset.x + 79 * 3) / 79);

    if (index < 0) {
        index = 0;
    }
    
    if (index > maxIndex) {
        index = maxIndex;
    }
    
    return index;
}

- (void)moveToIndex:(NSInteger)index
{
    // center number at index
    CGRect toRect = CGRectMake(index * 79, 0, 79, 60);
    [containerView scrollRectToVisible:toRect animated:YES];
}

- (void)fixScroll:(UIScrollView *)scrollView
{
    NSInteger index = [self indexByOffsetOfScrollView:scrollView];
        
    [self moveToIndex:index];
}

- (void)resizeNumberLabelAtIndex:(NSInteger)index
{
    @autoreleasepool {
        for (int i = 0; i < [numberLabels count]; i++) {
            if (i == index) {
                [[numberLabels objectAtIndex:i] setFont:[UIFont boldSystemFontOfSize:kLabelFontSizeBig]];
            }else{
                [[numberLabels objectAtIndex:i] setFont:[UIFont boldSystemFontOfSize:kLabelFontSizeNormal]];
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = [self indexByOffsetOfScrollView:scrollView];
    
    [self resizeNumberLabelAtIndex:index];
    
    // Notify delegate to update number
    if (selectedNumber != index + minimumNumber) {
        selectedNumber = index + minimumNumber;
        
        if ([self.delegate respondsToSelector:@selector(numberSwitcher:didUpdateToNumber:)]) {
            [self.delegate numberSwitcher:self didUpdateToNumber:selectedNumber];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self fixScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self fixScroll:scrollView];
}

@end
