//
//  SKViewController.m
//  SKMenu
//
//  Created by Shinji Kobayashi on 12/08/30.
//  Copyright (c) 2012年 Shinji Kobayashi. All rights reserved.
//

#import "SKViewController.h"
#import "SKMenuViewController.h"

@interface SKViewController() <SKMenuViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIButton* openMenuButton;
@property (nonatomic, weak) IBOutlet UIButton* closeMenuButton;
@property (nonatomic, weak) UIViewController* opendMenu;

- (IBAction)closeMenuButtonPress:(id)sender;
- (IBAction)menuButtonPress:(id)sender;
- (IBAction)handleGesture:(UIGestureRecognizer *)recognizer;

@end

@implementation SKViewController

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
    if (self.opendMenu == nil)
        return;
    
    SKMenuViewCloseSegue* segue = [[SKMenuViewCloseSegue alloc] initWithIdentifier:nil
                                                                            source:self.opendMenu
                                                                       destination:self];
    [segue perform];
}

- (IBAction)menuButtonPress:(id)sender {
    NSLog(@"%@", [sender titleLabel].text);
}

- (IBAction)handleGesture:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (recognizer.numberOfTapsRequired == 1) {
            if (self.opendMenu == nil) {
                [self performSegueWithIdentifier:@"SKMenuViewGestuerSegue"
                                          sender:[NSValue valueWithCGPoint:[recognizer locationInView:self.view]]];
            }
            else {
                SKMenuViewCloseSegue* segue = [[SKMenuViewCloseSegue alloc] initWithIdentifier:nil
                                                                                        source:self.opendMenu
                                                                                   destination:self];
                [segue perform];
            }
        }
    }
}

#pragma mark - SKMenuViewControllerDelegate

- (void)didSKMenuOpen:(SKMenuViewController *)controller {
    self.opendMenu = controller;
    self.openMenuButton.hidden = YES;
    self.closeMenuButton.hidden = NO;
}

- (void)didSKMenuClose:(SKMenuViewController *)controller {
    self.opendMenu = nil;
    self.openMenuButton.hidden = NO;
    self.closeMenuButton.hidden = YES;
}

- (void)didSKMenuChange:(SKMenuViewController *)sourceViewController destinationViewController:(SKMenuViewController *)destinationViewControler {
    self.opendMenu = destinationViewControler;
}

@end
