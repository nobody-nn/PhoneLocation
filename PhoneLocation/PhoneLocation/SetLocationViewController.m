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
#import <AddressBook/AddressBook.h>
#import "DataCenter.h"
#import "PersonCenter.h"

@interface SetLocationViewController ()

@property(nonatomic,retain) IBOutlet UIButton *setLocation,*custom,*reset;
@property(nonatomic,retain) IBOutlet UIImageView *headImageView;
@property(nonatomic,retain) IBOutlet UILabel *nameLabel,*phoneLabel;
@property(nonatomic,retain) IBOutlet UIScrollView *backScrollView;
@property(nonatomic,retain) NSString *selectedPhone,*originLabelString;
@property(nonatomic,retain) IBOutlet UIImageView *buttonBGImageView;

@end

@implementation SetLocationViewController
@synthesize setLocation,custom,reset,thisContact,headImageView,nameLabel,phoneIndex,backScrollView,selectedPhone,originLabelString,parent,buttonBGImageView;

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
    if ([thisContact headImage])
    {
        [[self headImageView] setImage:[thisContact headImage]];
    }
    else
    {
        [[self headImageView] setImage:[[DataCenter sharedInstance] headImage]];
    }
    [self.nameLabel setText:thisContact.friendName];
    
    self.selectedPhone = [[self.thisContact phoneNumbersArray] objectAtIndex:self.phoneIndex];
    [self.phoneLabel setText:self.selectedPhone];
    
    ABAddressBookRef addressRef;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        addressRef = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressRef, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else
    {
        addressRef = ABAddressBookCreate();
    }
    
    ABRecordRef personRef = ABAddressBookGetPersonWithRecordID(addressRef, self.thisContact.recordID);
    ABMultiValueRef phones = ABRecordCopyValue(personRef,kABPersonPhoneProperty);
    CFStringRef originRef = ABMultiValueCopyLabelAtIndex(phones, self.phoneIndex);
    NSString *originLabel = (__bridge NSString *)originRef;
    if ([[[DataCenter sharedInstance] labelsDic] objectForKey:originLabel])
    {
        self.originLabelString = [[[DataCenter sharedInstance] labelsDic] objectForKey:originLabel];
    }
    else
    {
        originLabel = [originLabel stringByReplacingOccurrencesOfString:@"_$!<" withString:@""];
        originLabel = [originLabel stringByReplacingOccurrencesOfString:@">!$_" withString:@""];
        self.originLabelString = originLabel;
    }
    
    CFRelease(originRef);
    CFRelease(phones);
    CFRelease(addressRef);
    
    [setLocation setBackgroundImage:[UIImage imageNamed:[selectedImageName objectAtIndex:1]] forState:UIControlStateNormal];
    preButton = setLocation;
    [self topButtonClick:setLocation];
    
}

#pragma mark - keyboard

- (void)editBegin
{
    [self.backScrollView setContentSize:CGSizeMake(320, 417+237)];
    [self.backScrollView setContentOffset:CGPointMake(0, 237) animated:YES];
}

- (void)editEnd
{
    [self.backScrollView setContentSize:CGSizeMake(320, 418)];
}

#pragma mark - location delegate


- (void)choosedLocation:(NSString *)location
{
    //此处设置，还是返回到center设置？
    
    ABAddressBookRef addressRef;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        addressRef = ABAddressBookCreateWithOptions(NULL, NULL);
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressRef, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else
    {
        addressRef = ABAddressBookCreate();
    }
    
    ABRecordRef personRef = ABAddressBookGetPersonWithRecordID(addressRef, self.thisContact.recordID);
    ABMultiValueRef phones = ABRecordCopyValue(personRef,kABPersonPhoneProperty);
    ABMutableMultiValueRef toChangeValue = ABMultiValueCreateMutableCopy(phones);
    ABMultiValueReplaceLabelAtIndex(toChangeValue, (__bridge CFStringRef)location, self.phoneIndex);
    CFErrorRef error = NULL;
    if(ABRecordSetValue(personRef, kABPersonPhoneProperty, toChangeValue, &error))
    {
        NSLog(@"修改成功");
        [self.thisContact.locationDic setObject:location forKey:self.selectedPhone];
        [self.parent reloadPhoneTable];
        ABAddressBookSave(addressRef, nil);
        
        //Doc 保存
        NSMutableDictionary *tempChangedDic = [[DataCenter sharedInstance] changedLocationDic];
        if (![tempChangedDic objectForKey:self.selectedPhone])
        {
            [tempChangedDic setObject:self.originLabelString forKey:self.selectedPhone];
            [[DataCenter sharedInstance] saveChangedDic];
        }
    }
    else
    {
        CFStringRef reason = CFErrorCopyFailureReason(error);
        NSLog(@"%@",(__bridge NSString *)(reason));
        CFRelease(reason);
    }
    CFRelease(toChangeValue);
    CFRelease(phones);
    CFRelease(addressRef);
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - actions

-(IBAction)backClick:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)topButtonClick:(id)sender
{
    int buttonTag = [sender tag];
    
    float animationTime = abs(buttonTag - [preButton tag]) * 0.5f;
    [UIView animateWithDuration:animationTime animations:^{
        buttonBGImageView.center = CGPointMake(20 + buttonTag * 109, buttonBGImageView.center.y);
    }];
    
    [preButton setBackgroundImage:[UIImage imageNamed:[selectedImageName objectAtIndex:0]] forState:UIControlStateNormal];
    [sender setBackgroundImage:[UIImage imageNamed:[selectedImageName objectAtIndex:1]] forState:UIControlStateNormal];
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
            
            [setLocationView setFrame:CGRectMake(28, 175, 265, 210)];
            [setLocationView setDelegate:self];
            [self.backScrollView addSubview:setLocationView];
            [setLocationView.originLabel setText:self.originLabelString];
            [setLocationView.toChangeLabel setText:[[[DataCenter sharedInstance] requestedDic] objectForKey:self.selectedPhone]];
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
            
            [customLocationView setFrame:CGRectMake(28, 175, 265, 210)];
            [customLocationView setDelegate:self];
            [customLocationView setParent:self];
            [self.backScrollView addSubview:customLocationView];
            [customLocationView.originLabel setText:self.originLabelString];
            preView = customLocationView;
            break;
        }
        case 2:
        {
            if (![[[DataCenter sharedInstance] changedLocationDic] objectForKey:self.selectedPhone])
            {
                [preButton setBackgroundImage:[UIImage imageNamed:[selectedImageName objectAtIndex:1]] forState:UIControlStateNormal];
                [sender setBackgroundImage:[UIImage imageNamed:[selectedImageName objectAtIndex:0]] forState:UIControlStateNormal];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有更改过" message:@"只有本软件修改过的号码才可以恢复" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [alert show];
                break;
            }
            [preView removeFromSuperview];
            
            if (!resetLocationView)
            {
                resetLocationView = [[[NSBundle mainBundle] loadNibNamed:@"SetLocationView" owner:nil options:nil] objectAtIndex:0];
            }
            
            [resetLocationView setFrame:CGRectMake(28, 175, 265, 210)];
            [resetLocationView setDelegate:self];
            [self.backScrollView addSubview:resetLocationView];
            [resetLocationView.originLabel setText:self.originLabelString];
            [resetLocationView.toChangeLabel setText:[[[DataCenter sharedInstance] changedLocationDic] objectForKey:self.selectedPhone]];
            
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
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    selectedImageName = [[NSArray alloc] initWithObjects:@"info_share.png",@"info_share_hl.png", nil];
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
