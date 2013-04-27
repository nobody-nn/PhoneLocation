//
//  SearchViewController.m
//  PhoneLocation
//
//  Created by girl on 13-4-17.
//  Copyright (c) 2013年 NanaZhang. All rights reserved.
//

#import "SearchViewController.h"
#import "BackgroundService.h"

@interface SearchViewController ()
@property(nonatomic,retain)IBOutlet UITextField *searchLocationField;
@end

@implementation SearchViewController
@synthesize searchLocationField;

#pragma mark - touch

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.searchLocationField resignFirstResponder];
}

#pragma mark - actions

-(IBAction)searchClick:(id)sender
{
    NSString *inputPhone = [searchLocationField text];
    inputPhone = [BackgroundService getPhoneStringWith:inputPhone];
    if ([inputPhone length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入手机号" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        //TODO:请求，解析
    }
}

-(IBAction)backClick:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - life cycle

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
