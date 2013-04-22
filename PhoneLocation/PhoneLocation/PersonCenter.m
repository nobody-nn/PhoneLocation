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

@end

@implementation PersonCenter

@synthesize parserDic,phoneTableView,headImageView,nameLabel,choosePhoneNum;

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
    PhonesActionSheet *phoneSheet = [[PhonesActionSheet alloc] initWithArray:self.thisContact.phoneNumbersArray title:@"选择号码" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:nil];
    [phoneSheet showInView:self.view];
}

-(IBAction)sendMessage:(id)sender
{
    if ([thisContact.phoneNumbersArray count] == 1)
    {
        self.choosePhoneNum = [self.thisContact.phoneNumbersArray objectAtIndex:0];
        [self loadDetailView];
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

-(IBAction)changeAvatar:(id)sender
{
    NSURL *avatarURL = [NSURL URLWithString:@"avatar://com.166.avatar?origin=PhoneLocation://app"];
    if ([[UIApplication sharedApplication] canOpenURL:avatarURL])
    {
        [[UIApplication sharedApplication] openURL:avatarURL];
    }
    else
    {
        NSURL *downloadURL = [NSURL URLWithString:@"http://itunes.apple.com/cn/app/id496226675?mt=8"];
        [[UIApplication sharedApplication] openURL:downloadURL];
    }
}

-(IBAction)copyAndSend:(id)sender
{
    //TODO:copy-->string
}

#pragma mark - 辅助

-(void)loadDetailView
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
    
    [self.navigationController pushViewController:commonUse animated:YES];
}

#pragma mark - sms delegates

-(void)removeTip:(UIView *)tip
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
        [self performSelector:@selector(removeTip:) withObject:SendSmsTip afterDelay:0.7f];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - phone actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.choosePhoneNum = [self.thisContact.phoneNumbersArray objectAtIndex:buttonIndex];
    switch (actionsType)
    {
        case kSMSKey:
        {
            if([MFMessageComposeViewController canSendText])
            {
                [self loadDetailView];
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

#pragma mark - table actions handler

-(void)setClick:(id)sender
{
    int tag = [sender tag];
    if (!setLocation)
    {
        setLocation = [[SetLocationViewController alloc] initWithNibName:@"SetLocationViewController" bundle:nil];
    }
    
    NSString *selectedPhone = [[self.thisContact phoneNumbersArray] objectAtIndex:tag];
    setLocation.selectedPhone = selectedPhone;
    [self presentViewController:setLocation animated:YES completion:nil];
    setLocation.thisContact = self.thisContact;
}

#pragma mark - table datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.parserDic)
    {
        [parserDic removeAllObjects];
        self.parserDic = [NSMutableDictionary dictionary];
    }
    if([self.thisContact phoneNumbersArray])
        return [[self.thisContact phoneNumbersArray] count];
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    PersonCell *cell;
    cell = (PersonCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    NSString *phoneString = [[self.thisContact phoneNumbersArray] objectAtIndex:[indexPath row]];
    [[cell phoneLabel] setText:phoneString];
    [[cell setButton] setTag:[indexPath row]];
    [[cell setButton] addTarget:self action:@selector(setClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *URLString = [NSString stringWithFormat:@"%@%@",[[DataCenter sharedInstance]locationURLStringPre],phoneString];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc] init] completionHandler:
     ^(NSURLResponse *response,NSData *data,NSError *error)
    {
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        parser.delegate = self;
        NSMutableDictionary *thisCellDic = [NSMutableDictionary dictionary];
        [thisCellDic setObject:indexPath forKey:kIndexPathKey];
        [thisCellDic setObject:[NSMutableString string] forKey:kLocationStringKey];
        [thisCellDic setObject:@"" forKey:kStoringKey];
        [self.parserDic setObject:parser forKey:thisCellDic];
    }
     ];
    
    return cell;
}

#pragma mark - xml parser delegate

#define kLocationLabel @"location"

-(NSMutableDictionary *)findDicWith:(NSXMLParser *)parser
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
{
    if ([elementName isEqualToString:kLocationLabel])
    {
        NSMutableDictionary *perDicKey = [self findDicWith:parser];
        [perDicKey setObject:@"1" forKey:kStoringKey];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:kLocationLabel])
    {
        NSMutableDictionary *perDicKey = [self findDicWith:parser];
        [perDicKey setObject:@"" forKey:kStoringKey];
        //TODO:更新cell
        PersonCell *cellTpUpdate = (PersonCell *)[self.phoneTableView cellForRowAtIndexPath:[perDicKey objectForKey:kIndexPathKey]];
        [[cellTpUpdate locationLabel] setText:[perDicKey objectForKey:kLocationStringKey]];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSMutableDictionary *perDicKey = [self findDicWith:parser];
    if ([[perDicKey objectForKey:kStoringKey]length]>0)
    {
        NSMutableString *currentString = [perDicKey objectForKey:kLocationStringKey];
        [currentString appendString:string];
        [perDicKey setObject:currentString forKey:kLocationStringKey];
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
