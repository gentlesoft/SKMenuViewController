//
//  SKMenuViewController.mm
//  SKMenuViewController
//
//  Created by Shinji Kobayashi on 12/08/30.
//  Copyright (c) 2012年 Shinji Kobayashi. All rights reserved.
//

#import <algorithm>
#import <vector>
#import "SKMenuViewController.h"

static const double PI     = 3.141592653589793;
static const CGFloat DEFAULT_DURATION = 0.4f;

#pragma mark - SKMenuViewController

@interface SKMenuViewController ()

@property (nonatomic) IBOutletCollection(UIView) NSArray* buttons;

@end

@implementation SKMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSMutableArray* ary = [NSMutableArray arrayWithArray:self.buttons];
    [ary sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([self.view.subviews indexOfObject:obj1] < [self.view.subviews indexOfObject:obj2])
            return NSOrderedAscending;
        else
            return NSOrderedDescending;
    }];
    self.buttons = ary;
    _duration = DEFAULT_DURATION;
    
    [(SKMenuView*)self.view setController:self];
    [(SKMenuView*)self.view setButtonCount:self.buttons.count];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)addButton:(UIView *)button {
    NSMutableArray* ary = [NSMutableArray arrayWithArray:self.buttons];
    [ary addObject:button];
    self.buttons = ary;
    [(SKMenuView*)self.view setButtonCount:self.buttons.count];
}

- (void)closeMenu:(BOOL)animated {
    if (animated) {
        SKMenuViewCloseSegue* segue = [[SKMenuViewCloseSegue alloc] initWithIdentifier:nil source:self destination:self.parentViewController];
        [segue perform];
        
    } else {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
}

@end


#pragma mark - SKMenuView

@interface SKMenuView ()

@property (nonatomic, assign) std::vector<double> xValues;
@property (nonatomic, assign) std::vector<double> yValues;

@end

@implementation SKMenuView

- (void)setButtonCount:(int)count {
    _xValues.resize(count);
    _yValues.resize(count);
    for (int i = 0; i < count; ++i) {
        _xValues[i] = cos(- PI / 2.0f + 2 * PI / count * i);
        _yValues[i] = sin(- PI / 2.0f + 2 * PI / count * i);
    }
    [self setFrame:self.frame];
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    double r = std::min(frame.size.width, frame.size.height) / 2.0f;
    CGPoint center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
    int i = 0;
    for (UIButton* button in self.controller.buttons) {
        CGPoint p;
        p.x = center.x + r * _xValues[i];
        p.y = center.y + r * _yValues[i];
        button.center = p;
        ++i;
    }
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView* view in self.subviews) {
        if ([view hitTest:[view convertPoint:point fromView:self] withEvent:event])
            return view;
    }
    return nil;
}

@end

#pragma mark - SKMenuViewOpenSegue

@implementation SKMenuViewOpenSegue

- (void)perform{
    UIView* menuView = [self.destinationViewController view];
    NSObject<SKMenuViewControllerDelegate>* delegate = [self.destinationViewController delegate];
    if ([delegate respondsToSelector:@selector(willSKMenuOpen:)])
        [delegate willSKMenuOpen:self.destinationViewController];
    [self.sourceViewController addChildViewController:self.destinationViewController];
    [[self.sourceViewController view] addSubview:menuView];
    
    menuView.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.01f, 0.01f),  -PI);
    [UIView animateWithDuration:[(SKMenuViewController*)self.destinationViewController duration] animations:^{
        menuView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if ([delegate respondsToSelector:@selector(didSKMenuOpen:)])
            [delegate didSKMenuOpen:self.destinationViewController];
    }];
}

@end

#pragma mark - SKMenuViewChildSegue

@implementation SKMenuViewChildSegue

- (void)perform {
    UIView* prevMenuView = [self.sourceViewController view];
    UIView* nextMenuView = [self.destinationViewController view];
    NSObject<SKMenuViewControllerDelegate>* delegate = [self.sourceViewController delegate];
    if ([delegate respondsToSelector:@selector(willSKMenuChange:destinationViewController:)])
        [delegate willSKMenuChange:self.sourceViewController destinationViewController:self.destinationViewController];
    [[self.sourceViewController parentViewController] addChildViewController:self.destinationViewController];
    [self.destinationViewController setDelegate:[self.sourceViewController delegate]];
    nextMenuView.center = prevMenuView.center;
    
    [UIView animateWithDuration:[(SKMenuViewController*)self.sourceViewController duration]
                     animations:^
    {
        prevMenuView.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.01f, 0.01f), -PI);
    }
                     completion:^(BOOL finished)
    {
        [prevMenuView.superview addSubview:nextMenuView];
        [prevMenuView removeFromSuperview];
        [self.sourceViewController removeFromParentViewController];

        nextMenuView.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.01f, 0.01f),  -PI);
        [UIView animateWithDuration:[(SKMenuViewController*)self.destinationViewController duration] animations:^{
            nextMenuView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if ([delegate respondsToSelector:@selector(didSKMenuChange:destinationViewController:)])
                [delegate didSKMenuChange:self.sourceViewController destinationViewController:self.destinationViewController];
        }];
    }];
}
     
@end

#pragma mark - SKMenuViewCloseSegue

@implementation SKMenuViewCloseSegue

- (void)perform {
    UIView* menuView = [self.sourceViewController view];
    NSObject<SKMenuViewControllerDelegate>* delegate = [self.sourceViewController delegate];
    if ([delegate respondsToSelector:@selector(willSKMenuClose:)])
        [delegate willSKMenuClose:self.sourceViewController];
    
    [UIView animateWithDuration:[(SKMenuViewController*)self.sourceViewController duration] animations:^{
        menuView.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.01f, 0.01f),  -PI);
    } completion:^(BOOL finished) {
        [menuView removeFromSuperview];
        [self.sourceViewController removeFromParentViewController];
        if ([delegate respondsToSelector:@selector(didSKMenuClose:)])
            [[self.sourceViewController delegate] didSKMenuClose:self.sourceViewController];
    }];
}

@end



