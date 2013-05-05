//
//  PersonCenter.m
//  SmsManager
//
//  Created by Nana Zhang on 12-3-20.
//  Copyright (c) 2012年 Nana inc. All rights reserved.
//

#import "PersonCenter.h"
#import "PersonCell.h"
#import "ContactClass.h"
#import "DataCenter.h"
#import "PhonesActionSheet.h"
#import "CommonUse.h"
#import "SetLocationViewController.h"
#import "BackgroundService.h"

#define kIndexPathKey @"indexPath"
#define kLocationStringKey @"location"
#define kStoringKey @"storing"

#define kSMSKey         1
#define kCommonSmsKey   3
#define kCallKey        2

@interface PersonCenter()

@property(nonatomic,retain) IBOutlet UITableView *phoneTableView;
@property(nonatomic,retain) IBOutlet UIImageView *headImageView;
@property(nonatomic,retain) IBOutlet UILabel *nameLabel;
@property(nonatomic,retain) NSString *choosePhoneNum;
@property(nonatomic,retain) IBOutlet UIScrollView *backScrollView;
@property(nonatomic,retain) NSDictionary *parserDic,*configDic;
@property(nonatomic,retain) NSMutableString *sendBody;

@end

@implementation PersonCenter

@synthesize parserDic,phoneTableView,headImageView,nameLabel,choosePhoneNum,backScrollView;

#pragma mark - begining

-(ContactClass *)thisContact
{
    return thisContact;
}

-(void)setThisContact:(ContactClass *)contact
{
    noNetWorkSinceLastCheck = NO;
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
    [self.phoneTableView reloadData];
}

#pragma mark - actions

-(IBAction)backClick:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)showChoices:(int)action
{
    actionsType = action;
    PhonesActionSheet *phoneSheet = [[PhonesActionSheet alloc] initWithArray:self.thisContact.phoneNumbersArray title:@"选择号码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    [phoneSheet showInView:self.view];
}

-(IBAction)sendMessage:(id)sender
{
    if ([thisContact.phoneNumbersArray count] == 1)
    {
        self.choosePhoneNum = [self.thisContact.phoneNumbersArray objectAtIndex:0];
        [self sendToPeople];
    }
    else if ([thisContact.phoneNumbersArray count] > 1)
    {
        [self showChoices:kSMSKey];
    }
}

-(IBAction)simpleMessage:(id)sender
{
    if ([thisContact.phoneNumbersArray count] == 1)
    {
        self.choosePhoneNum = [self.thisContact.phoneNumbersArray objectAtIndex:0];
        [self loadCommonSms];
    }
    else if ([thisContact.phoneNumbersArray count] > 1)
    {
        [self showChoices:kCommonSmsKey];
    }
}

-(IBAction)call:(id)sender
{
    if ([thisContact.phoneNumbersArray count] == 1)
    {
        self.choosePhoneNum = [self.thisContact.phoneNumbersArray objectAtIndex:0];
        [self makeACall];
    }
    else if ([thisContact.phoneNumbersArray count] > 1)
    {
        [self showChoices:kCallKey];
    }
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)changeAvatar:(id)sender
{
    NSURL *avatarURL = [NSURL URLWithString:@"avatar://com.166.avatar?origin=PhoneLocation://app"];
    if ([[UIApplication sharedApplication] canOpenURL:avatarURL])
    {
        [[UIApplication sharedApplication] openURL:avatarURL];
    }
    else
    {//id496226675
        //SKStoreProductViewController
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
        {
            NSDictionary *appParameters = [NSDictionary dictionaryWithObject:@"609365241"                      forKey:SKStoreProductParameterITunesItemIdentifier];
            
            SKStoreProductViewController *productViewController = [[SKStoreProductViewController alloc] init];
            [productViewController setDelegate:self];
            [productViewController loadProductWithParameters:appParameters
                                             completionBlock:^(BOOL result, NSError *error)
            {
                
            }];
            [self presentViewController:productViewController
                               animated:YES
                             completion:^{
                                 
                             }];
        }
        else
        {
            NSURL *downloadURL = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/id609365241?mt=8"];
            [[UIApplication sharedApplication] openURL:downloadURL];
        }
    }
}

-(IBAction)copyAndSend:(id)sender
{
    self.sendBody = [NSMutableString stringWithString:[self.thisContact friendName]];
    //TODO:copy-->string
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
    
    //读取联系人公司信息
    NSString *company = (__bridge NSString *)ABRecordCopyValue(personRef,kABPersonOrganizationProperty);
    if (company)
    {
        [self.sendBody appendFormat:@"\n公司：%@", company];
    }
    
    //读取联系人工作
    NSString *job = (__bridge NSString *)ABRecordCopyValue(personRef,kABPersonJobTitleProperty);
    if (job)
    {
        [self.sendBody appendFormat:@"\n工作：%@", job];
    }
    
    //手机号码
    ABMultiValueRef multiValue = ABRecordCopyValue(personRef,kABPersonPhoneProperty);
    NSArray *valueArray;
    if (ABMultiValueGetCount(multiValue)>0)
    {
        [self.sendBody appendString:@"\n<号码>"];
        valueArray = (__bridge NSArray *)multiValue;
        [self appendStringWithValue:multiValue];
    }
    
    //邮箱
    multiValue = ABRecordCopyValue(personRef, kABPersonEmailProperty);
    if (ABMultiValueGetCount(multiValue)>0)
    {
        [self.sendBody appendString:@"\n<邮箱>"];
        valueArray = (__bridge NSArray *)multiValue;
        [self appendStringWithValue:multiValue];
    }
    
    //地址
    ABMultiValueRef addressTotal = ABRecordCopyValue(personRef, kABPersonAddressProperty);
    if (ABMultiValueGetCount(multiValue)>0) {
        int count = ABMultiValueGetCount(addressTotal);
        [self.sendBody appendString:@"\n地址: "];
        for(int j = 0; j < count; j++)
        {
            NSDictionary* personaddress =(__bridge NSDictionary*) ABMultiValueCopyValueAtIndex(addressTotal, j);
            NSString* country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
            if(country != nil)
                [self.sendBody appendFormat:@"%@",country];
            NSString* city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];
            if(city != nil)
                [self.sendBody appendFormat:@"%@, ",city];
            NSString* state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
            if(state != nil)
                [self.sendBody appendFormat:@"%@, ",state];
            NSString* street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
            if(street != nil)
                [self.sendBody appendFormat:@"%@,",street];
        }
        NSLog(@"now:%@",self.sendBody);
    }
    
    //主页
    multiValue = ABRecordCopyValue(personRef, kABPersonURLProperty);
    if (multiValue)
    {
        [self.sendBody appendString:@"\n<网址>"];
        valueArray = (__bridge NSArray *)multiValue;
        [self appendStringWithValue:multiValue];
    }
    
    //kABPersonEmailProperty
    [[UIPasteboard generalPasteboard] setString:self.sendBody];
    if(!showTips)
    {
        showTips = [[[NSBundle mainBundle] loadNibNamed:@"ShowTips" owner:nil options:nil]objectAtIndex:0];
        [showTips setFrame:CGRectMake(85, 200, 151, 40)];
        UILabel *tipContentLabel = (UILabel *)[showTips viewWithTag:33];
        [tipContentLabel setText:@"内容已复制到剪贴板"];
    }
    else
    {
        [showTips setAlpha:1];
        [showTips setHidden:NO];
    }
    [self.view addSubview:showTips];
    [self performSelector:@selector(removeCopyTip:) withObject:showTips afterDelay:1.0f];
}

-(void)removeCopyTip:(UIView *)tip
{
    [UIView animateWithDuration:0.3
                     animations:^{tip.alpha = 0.0;}
                     completion:^(BOOL finished)
     {
         [tip removeFromSuperview];
         [self sendPeopleInfo];
     }];
}

-(void)appendStringWithValue:(ABMultiValueRef) multiValue
{
    if (!multiValue)
    {
        return;
    }
    CFStringRef perValue;
    NSString *valueString;
    NSMutableString *personInfo = [NSMutableString stringWithString:[self sendBody]];
    for (int i = 0; i < ABMultiValueGetCount(multiValue); i++)
    {
        perValue = ABMultiValueCopyLabelAtIndex(multiValue, i);
        valueString = (__bridge NSString *)perValue;
        if ([[[DataCenter sharedInstance] labelsDic] objectForKey:valueString])
        {
            valueString = [[[DataCenter sharedInstance] labelsDic] objectForKey:valueString];
        }
        else
        {
            valueString = [valueString stringByReplacingOccurrencesOfString:@"_$!<" withString:@""];
            valueString = [valueString stringByReplacingOccurrencesOfString:@">!$_" withString:@""];
        }
        
        [personInfo appendFormat:@"\n%@",valueString];
        perValue = ABMultiValueCopyValueAtIndex(multiValue, i);
        valueString = (__bridge NSString *)perValue;
        [personInfo appendFormat:@": %@",valueString];
        
    }
    NSLog(@"now:%@",personInfo);
    self.sendBody = personInfo;
}

-(void)removeTip:(UIView *)tip
{
    [UIView animateWithDuration:0.3
                     animations:^{tip.alpha = 0.0;}
                     completion:^(BOOL finished)
    {
        [tip removeFromSuperview];
    }];
}

#pragma mark - 辅助

-(void)sendPeopleInfo
{
    MFMessageComposeViewController *messageViewController = [[MFMessageComposeViewController alloc] init];
    messageViewController.messageComposeDelegate = self;
    messageViewController.body = self.sendBody;
    [self presentViewController:messageViewController animated:YES completion:nil];
}

-(void)reloadPhoneTable
{
    [self.phoneTableView reloadData];
}

-(void)sendToPeople
{
    MFMessageComposeViewController *messageViewController = [[MFMessageComposeViewController alloc] init];
    messageViewController.messageComposeDelegate = self;
    NSMutableArray *sendTo = [NSMutableArray array];
    [sendTo addObject:self.choosePhoneNum];
    messageViewController.recipients = sendTo;
    [self presentViewController:messageViewController animated:YES completion:nil];
    
}

-(void)makeACall
{
    NSString *callString = @"telprompt://";
    NSString *phoneURL = [NSString stringWithFormat:@"%@%@",callString,self.choosePhoneNum];
    phoneURL = [phoneURL stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    phoneURL = [phoneURL stringByReplacingOccurrencesOfString:@"+" withString:@""];
    phoneURL = [phoneURL stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneURL]];
}

-(void)loadCommonSms
{
    if (!commonUse)
    {
        commonUse = [[CommonUse alloc] initWithNibName:@"CommonUse" bundle:nil];
    }
    commonUse.choosePhoneNum = self.choosePhoneNum;
    [self.navigationController pushViewController:commonUse animated:YES];
}

#pragma mark - sms delegates

-(void)removeSendTip:(UIView *)tip
{
    [UIView animateWithDuration:0.5
                     animations:^{tip.alpha = 0.0;}
                     completion:^(BOOL finished){ [tip setHidden:YES]; }];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    if(result == MessageComposeResultSent)
    {
        if(!SendSmsTip)
        {
            SendSmsTip = [[[NSBundle mainBundle] loadNibNamed:@"SendSmsTip" owner:nil options:nil]objectAtIndex:0];
            [SendSmsTip setFrame:CGRectMake(100, 160, 120, 35)];
            [self.view addSubview:SendSmsTip];
        }
        else
        {
            SendSmsTip.alpha = 1.0;
            [SendSmsTip setHidden:NO];
        }
        [self performSelector:@selector(removeSendTip:) withObject:SendSmsTip afterDelay:0.7f];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - phone actionsheet delegate

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        return;
    }
    self.choosePhoneNum = [self.thisContact.phoneNumbersArray objectAtIndex:buttonIndex - 1];
    switch (actionsType)
    {
        case kSMSKey:
        {
            if([MFMessageComposeViewController canSendText])
            {
                [self sendToPeople];
            }
            break;
        }
        case kCommonSmsKey:
        {
            [self loadCommonSms];
            break;
        }
        case kCallKey:
        {
            [self makeACall];
            break;
        }
        default:
            break;
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    NSLog(@"cancel");
}

#pragma mark - table actions handler

-(void)setClick:(id)sender
{
    int tag = [sender tag];
    if (!setLocation)
    {
        setLocation = [[SetLocationViewController alloc] initWithNibName:@"SetLocationViewController" bundle:nil];
    }
    
    setLocation.phoneIndex = tag;
    setLocation.parent = self;
    [self presentViewController:setLocation animated:YES completion:nil];
    setLocation.thisContact = self.thisContact;
}

#pragma mark - table datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.thisContact phoneNumbersArray])
        return [[self.thisContact phoneNumbersArray] count];
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID;
    if (!cellID)
    {
        cellID = @"cell";
        UINib *cellNib = [UINib nibWithNibName:@"PersonCell" bundle:nil];
        [tableView registerNib:cellNib forCellReuseIdentifier:cellID];
    }
    
    PersonCell *cell;
    cell = (PersonCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSString *phoneString = [[self.thisContact phoneNumbersArray] objectAtIndex:[indexPath row]];
    [[cell phoneLabel] setText:phoneString];
    [[cell setButton] setTag:[indexPath row]];
    [[cell setButton] addTarget:self action:@selector(setClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *locationString = [[[DataCenter sharedInstance] requestedDic] objectForKey:phoneString];
    if (locationString)
    {
        [[cell locationLabel] setText:locationString];
    }
    else
    {
        BOOL hasNetwork = [BackgroundService connectedToNetwork];
        if (!hasNetwork)
        {
            if (noNetWorkSinceLastCheck)
            {
                //DoNothing
            }
            else
            {
                noNetWorkSinceLastCheck = YES;
                
                if(!netWorkTips)
                {
                    netWorkTips = [[[NSBundle mainBundle] loadNibNamed:@"ShowTips" owner:nil options:nil]objectAtIndex:0];
                    [netWorkTips setFrame:CGRectMake(85, 200, 151, 40)];
                    UILabel *tipContentLabel = (UILabel *)[netWorkTips viewWithTag:33];
                    [tipContentLabel setText:@"未检测到网络连接"];
                }
                else
                {
                    [netWorkTips setAlpha:1];
                    [netWorkTips setHidden:NO];
                }
                [self.view addSubview:netWorkTips];
                [self performSelector:@selector(removeTip:) withObject:netWorkTips afterDelay:1.0f];
            }
        }
        
        [[cell locationLabel] setText:@""];
        NSString *URLString = [NSString stringWithFormat:@"%@%@",[[DataCenter sharedInstance]locationURLStringPre],[BackgroundService getNumeralWith:phoneString]];
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
        
        [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc] init] completionHandler:
         ^(NSURLResponse *response,NSData *data,NSError *error)
        {
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
            NSMutableDictionary *thisCellDic = [NSMutableDictionary dictionary];
            [thisCellDic setObject:@"0" forKey:kStoringKey];
            NSMutableDictionary *tempParserDic = [NSMutableDictionary dictionaryWithDictionary:self.parserDic];
            [tempParserDic setObject:parser forKey:indexPath];
            self.parserDic = tempParserDic;
            
            NSMutableDictionary *tempConfigDic = [NSMutableDictionary dictionaryWithDictionary:self.configDic];
            [tempConfigDic setObject:thisCellDic forKey:indexPath];
            self.configDic = tempConfigDic;
            
            parser.delegate = self;
            [parser parse];
        }
         ];
    }
    return cell;
}

#pragma mark - xml parser delegate

-(id)findDicWith:(NSXMLParser *)parser
{
    NSArray *allKeys = [self.parserDic allKeys];
    NSMutableDictionary *perDicKey;
    NSXMLParser *perParser;
    for (int i = 0; i<[allKeys count]; i++)
    {
        perDicKey = [allKeys objectAtIndex:i];
        perParser = [self.parserDic objectForKey:perDicKey];
        if (parser == perParser)
        {
            break;
        }
    }
    
    return perDicKey;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *) qualifiedName attributes:(NSDictionary *)attributeDict
{//起始标签
    if ([elementName isEqualToString:kLocationLabel])
    {
        id perDicKey = [self findDicWith:parser];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[self.configDic objectForKey:perDicKey]];
        
        NSLog(@"class:%@",[perDicKey class]);
        [tempDic setObject:@"1" forKey:kStoringKey];//bool的yes
        
        NSMutableDictionary *tempConfigDic = [NSMutableDictionary dictionaryWithDictionary:self.configDic];
        [tempConfigDic setObject:tempDic forKey:perDicKey];
        self.configDic = tempConfigDic;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{//结束标签
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{//内容字符
    id perDicKey = [self findDicWith:parser];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[self.configDic objectForKey:perDicKey]];
    
    if ([[tempDic objectForKey:kStoringKey]isEqualToString:@"1"])
    {
        [tempDic setObject:string forKey:kLocationStringKey];
        [tempDic setObject:@"0" forKey:kStoringKey];
        
        NSMutableDictionary *tempConfigDic = [NSMutableDictionary dictionaryWithDictionary:self.configDic];
        [tempConfigDic setObject:tempDic forKey:perDicKey];
        self.configDic = tempConfigDic;
        
        PersonCell *cellToUpdate = (PersonCell *)[self.phoneTableView cellForRowAtIndexPath:(NSIndexPath *)perDicKey];
        if (!string || [string length] == 0)
        {
            string = @"未知";
        }
        [[cellToUpdate locationLabel] performSelectorOnMainThread:@selector(setText:) withObject:string waitUntilDone:NO];
        //手机号为键值
        [[[DataCenter sharedInstance] requestedDic] setObject:string forKey:[[self.thisContact phoneNumbersArray] objectAtIndex:[perDicKey row]]];
        //save
        [[DataCenter sharedInstance] saveRequestedDic];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    // Handle errors as appropriate for your application.
}

#pragma mark - init

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
    [backScrollView setContentSize:CGSizeMake(320, 418)];
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
