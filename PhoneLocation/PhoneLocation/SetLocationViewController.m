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

@end

@implementation SetLocationViewController
@synthesize setLocation,custom,reset,thisContact,headImageView,nameLabel,phoneIndex,backScrollView,selectedPhone,originLabelString,parent;

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
    
    selectedPhone = [[self.thisContact phoneNumbersArray] objectAtIndex:self.phoneIndex];
    [self.phoneLabel setText:selectedPhone];
    
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
    self.originLabelString = (__bridge NSString *)originRef;
    CFRelease(originRef);
    CFRelease(phones);
    CFRelease(addressRef);
    
    [setLocation setImage:[UIImage imageNamed:[selectedImageName objectAtIndex:0]] forState:UIControlStateNormal];
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
        [[[DataCenter sharedInstance] changedLocationDic] setObject:self.originLabelString forKey:self.selectedPhone];
        [[DataCenter sharedInstance] saveChangedDic];
        ABAddressBookSave(addressRef, nil);
    }
    else
    {
        CFStringRef reason = CFErrorCopyFailureReason(error);
        NSLog((__bridge NSString *)(reason));
        CFRelease(reason);
    }
    CFRelease(toChangeValue);
    CFRelease(phones);
    CFRelease(addressRef);
    
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
            
            [setLocationView setFrame:CGRectMake(28, 195, 265, 190)];
            [setLocationView setDelegate:self];
            [self.backScrollView addSubview:setLocationView];
            [setLocationView.originLabel setText:self.originLabelString];
            [setLocationView.toChangeLabel setText:[self.thisContact.locationDic objectForKey:self.selectedPhone]];
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
            
            [customLocationView setFrame:CGRectMake(28, 195, 265, 190)];
            [customLocationView setDelegate:self];
            [customLocationView setParent:self];
            [self.backScrollView addSubview:customLocationView];
            [customLocationView.originLabel setText:self.originLabelString];
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
            
            [resetLocationView setFrame:CGRectMake(28, 195, 265, 190)];
            [resetLocationView setDelegate:self];
            [self.backScrollView addSubview:resetLocationView];
            [resetLocationView.originLabel setText:self.originLabelString];
            
            
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
