//
//  ViewController.m
//  SKMenuViewControllerSample
//
//  Created by Shinji Kobayashi on 12/08/30.
//  Copyright (c) 2012年 Shinji Kobayashi. All rights reserved.
//

#import "ViewController.h"
#import "SKMenuViewController.h"

@interface ViewController() <SKMenuViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIButton* openMenuButton;
@property (nonatomic, weak) IBOutlet UIButton* closeMenuButton;
@property (nonatomic, weak) IBOutlet UILabel* tapText;
@property (nonatomic, weak) SKMenuViewController* openedMenu;

- (IBAction)closeMenuButtonPress:(id)sender;
- (IBAction)menuButtonPress:(id)sender;
- (IBAction)handleGesture:(UIGestureRecognizer *)recognizer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.openMenuButton.hidden = NO;
    self.closeMenuButton.hidden = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SKMenuViewButtonSegue"]) {
        [segue.destinationViewController view].center = [sender center];
        [segue.destinationViewController setDelegate:self];
    
    } else if ([segue.identifier isEqualToString:@"SKMenuViewGestuerSegue"]) {
        [segue.destinationViewController view].center = [sender CGPointValue];
        [segue.destinationViewController setDelegate:self];
    }
}

#pragma mark - Action

- (IBAction)closeMenuButtonPress:(id)sender {
    if (self.openedMenu != nil)
        [self.openedMenu closeMenu:YES];
}

- (IBAction)menuButtonPress:(id)sender {
    NSLog(@"%@", [sender titleLabel].text);
}

- (IBAction)handleGesture:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (recognizer.numberOfTapsRequired == 1) {
            if (self.openedMenu == nil) {
                [self performSegueWithIdentifier:@"SKMenuViewGestuerSegue"
                                          sender:[NSValue valueWithCGPoint:[recognizer locationInView:self.view]]];
            }
            else {
                SKMenuViewCloseSegue* segue = [[SKMenuViewCloseSegue alloc] initWithIdentifier:nil
                                                                                        source:self.openedMenu
                                                                                   destination:self];
                [segue perform];
            }
        }
    }
}

#pragma mark - SKMenuViewControllerDelegate

- (void)didSKMenuOpen:(SKMenuViewController *)controller {
    self.openedMenu = controller;
    self.openMenuButton.hidden = YES;
    self.closeMenuButton.hidden = NO;
    self.tapText.text = @"Tap Menu Close";
}

- (void)didSKMenuClose:(SKMenuViewController *)controller {
    self.openedMenu = nil;
    self.openMenuButton.hidden = NO;
    self.closeMenuButton.hidden = YES;
    self.tapText.text = @"Tap Menu Open";
}

- (void)didSKMenuChange:(SKMenuViewController *)sourceViewController destinationViewController:(SKMenuViewController *)destinationViewControler {
    self.openedMenu = destinationViewControler;
}

@end
