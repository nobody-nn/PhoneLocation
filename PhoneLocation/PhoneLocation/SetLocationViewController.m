//
//  SetLocationViewController.m
//  PhoneLocation
//
//  Created by girl on 13-4-22.
//  Copyright (c) 2013年 NanaZhang. All rights reserved.
//

#import "SetLocationViewController.h"
#import "SetLocationView.h"
#import "CustomLocationView.h"
#import "ContactClass.h"

@interface SetLocationViewController ()

@property(nonatomic,retain) IBOutlet UIButton *setLocation,*custom,*reset;
@property(nonatomic,retain) IBOutlet UIImageView *headImageView;
@property(nonatomic,retain) IBOutlet UILabel *nameLabel,*phoneLabel;

@end

@implementation SetLocationViewController
@synthesize setLocation,custom,reset,thisContact,headImageView,nameLabel,selectedPhone;

#pragma mark - begining

-(ContactClass *)thisContact
{
    return thisContact;
}

-(void)setThisContact:(ContactClass *)contact
{
    if (contact != thisContact)
    {
        thisContact = contact;
    }
    [self.headImageView setImage:thisContact.headImage];
    [self.nameLabel setText:thisContact.friendName];
}

#pragma mark - keyboard

- (void)editBegin
{
    
}

- (void)editEnd
{
    
}

#pragma mark - location delegate


- (void)choosedLocation:(NSString *)location
{
    //此处设置，还是返回到center设置？
}

#pragma mark - actions

-(IBAction)backClick:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)topButtonClick:(id)sender
{
    int buttonTag = [sender tag];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [preButton setImage:nil forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:[selectedImageName objectAtIndex:buttonTag]] forState:UIControlStateNormal];
    preButton = sender;
    //TODO:load view
    switch (buttonTag)
    {
        case 0:
        {
            [preView removeFromSuperview];
            
            if (!setLocationView)
            {
                setLocationView = [[[NSBundle mainBundle] loadNibNamed:@"SetLocationView" owner:nil options:nil] objectAtIndex:0];
            }
            //TODO:初始化数据
            
            [setLocationView setFrame:CGRectMake(28, 237, 265, 190)];
            [self.view addSubview:setLocationView];
            preView = setLocationView;
            break;
        }
        case 1:
        {
            [preView removeFromSuperview];
            
            if (!customLocationView)
            {
                customLocationView = [[[NSBundle mainBundle] loadNibNamed:@"CustomLocationView" owner:nil options:nil] objectAtIndex:0];
            }
            //TODO:初始化数据
            
            [customLocationView setFrame:CGRectMake(28, 237, 265, 190)];
            [self.view addSubview:customLocationView];
            preView = customLocationView;
            break;
        }
        case 2:
        {
            [preView removeFromSuperview];
            
            if (!resetLocationView)
            {
                resetLocationView = [[[NSBundle mainBundle] loadNibNamed:@"SetLocationView" owner:nil options:nil] objectAtIndex:0];
            }
            //TODO:初始化数据
            
            [resetLocationView setFrame:CGRectMake(28, 237, 265, 190)];
            [self.view addSubview:resetLocationView];
            preView = resetLocationView;
            break;
        }
        default:
            break;
    }
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

-(void)viewWillAppear:(BOOL)animated
{
    [setLocation setImage:[UIImage imageNamed:[selectedImageName objectAtIndex:0]] forState:UIControlStateNormal];
    preButton = setLocation;
    
    [self.phoneLabel setText:selectedPhone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    selectedImageName = [[NSArray alloc] initWithObjects:@"dianji1.png",@"dianji3.png",@"dianji2.png", nil];
}

-(void)dealloc
{
    NSLog(@"SetLocationViewController dealloc");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
