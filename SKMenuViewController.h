//
//  SKMenuViewController.h
//  SKMenuViewController
//
//  Created by Shinji Kobayashi on 12/08/30.
//  Copyright (c) 2012年 Shinji Kobayashi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SKMenuViewController;

@protocol SKMenuViewControllerDelegate

@optional -(void)willSKMenuOpen:(SKMenuViewController*)controller;
@optional -(void)didSKMenuOpen:(SKMenuViewController*)controller;
@optional -(void)willSKMenuClose:(SKMenuViewController*)controller;
@optional -(void)didSKMenuClose:(SKMenuViewController*)controller;
@optional -(void)willSKMenuChange:(SKMenuViewController*)sourceViewController destinationViewController:(SKMenuViewController*)destinationViewControler;
@optional -(void)didSKMenuChange:(SKMenuViewController*)sourceViewController destinationViewController:(SKMenuViewController*)destinationViewControler;

@end

@interface SKMenuViewController : UIViewController

@property (nonatomic, weak) id<SKMenuViewControllerDelegate> delegate;
@property (nonatomic, assign) CGFloat duration;

- (void)addButton:(UIView*)button;
- (void)closeMenu:(BOOL)animated;

@end

@interface SKMenuView : UIView

@property (nonatomic, weak) SKMenuViewController* controller;

- (void)setButtonCount:(int)count;

@end

@interface SKMenuViewOpenSegue : UIStoryboardSegue
@end

@interface SKMenuViewChildSegue : UIStoryboardSegue
@end

@interface SKMenuViewCloseSegue : UIStoryboardSegue
@end
