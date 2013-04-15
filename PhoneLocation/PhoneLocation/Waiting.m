//
//  Waiting.m
//  SafeCase
//
//  Created by Nana Zhang on 12-3-14.
//  Copyright (c) 2012年 Nana inc. All rights reserved.
//

#import "Waiting.h"
#import "DataCenter.h"

@implementation Waiting

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [(UIActivityIndicatorView *)self.view startAnimating];
}

-(void)viewDidAppear:(BOOL)animated
{
    [[[DataCenter sharedInstance] whosWaiting] performSelector:@selector(loadDetailView)];
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
