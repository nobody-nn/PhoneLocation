//
//  CommonUse.m
//  SmsManager
//
//  Created by Nana Zhang on 12-2-17.
//  Copyright (c) 2012年 Nana inc. All rights reserved.
//

#import "CommonUse.h"
#import "DataCenter.h"
#import "SectionHeader.h"

@implementation CommonUse
@synthesize listTableView,expandArray;

#pragma mark - actions

-(IBAction)addClick:(id)sender
{
    if(!newCommonItem)
    {
        newCommonItem = [[NewCommonItem alloc] initWithNibName:@"NewCommonItem" bundle:nil];
        [newCommonItem setParent:self];
    }
    [self.navigationController pushViewController:newCommonItem animated:YES];
}

-(IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - sms delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    //MessageComposeResultCancelled,
    //MessageComposeResultSent,
    //MessageComposeResultFailed
    
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
    
    [self dismissModalViewControllerAnimated:NO];
}


#pragma mark - table delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //do sth
    NSDictionary *sectionDic = [tableDic objectForKey:[NSString stringWithFormat:@"%d",[indexPath section]]];
    NSArray *sectionArray = [sectionDic objectForKey:kCommonSectionArray];
    NSString *contentString = [sectionArray objectAtIndex:[indexPath row]];
    
    MFMessageComposeViewController *messageViewController = [[MFMessageComposeViewController alloc] init];
    messageViewController.messageComposeDelegate = self;
    NSMutableArray *sendTo = [NSMutableArray array];
    [sendTo addObject:self.choosePhoneNum];
    messageViewController.recipients = sendTo;
    [messageViewController setBody:contentString];
    [self presentViewController:messageViewController animated:YES completion:nil];
}

//编辑模式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView
          editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//删除
-(void)tableView:(UITableView *)tableView
 commitEditingStyle:(UITableViewCellEditingStyle) editingSytle
  forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *commonDic = [NSMutableDictionary dictionaryWithDictionary: tableDic];
    NSMutableDictionary *sectionDic = [NSMutableDictionary dictionaryWithDictionary:[commonDic objectForKey:[NSString stringWithFormat:@"%d",[indexPath section]]]];
    NSMutableArray *sectionArray = [NSMutableArray arrayWithArray:[sectionDic objectForKey:kCommonSectionArray]];
    [sectionArray removeObjectAtIndex:[indexPath row]];
    [sectionDic setObject:sectionArray forKey:kCommonSectionArray];
    [commonDic setObject:sectionDic forKey:[NSString stringWithFormat:@"%d",[indexPath section]]];
    //保存,刷新
    [[DataCenter sharedInstance] setCommonDic:commonDic];
    [[DataCenter sharedInstance] saveCommonDic];
    [self initTable];
    [listTableView reloadData];
}

- (void)sectionButtonClicked:(UIButton *)sender
{
	int section = sender.tag;
    
    //展开<-->收缩
    BOOL expand = [[expandArray objectAtIndex:section] boolValue];
    [expandArray replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!expand]];
	[listTableView reloadData];
}


#pragma mark - table data source

//分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [tableDic count];
}

//每个分组下数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BOOL expand = [[expandArray objectAtIndex:section] boolValue];
    if(expand)
    {
        NSDictionary *sectionDic = [tableDic objectForKey:[NSString stringWithFormat:@"%d",section]];
        NSArray *sectionArray = [sectionDic objectForKey:kCommonSectionArray];
        if(sectionArray)
            return [sectionArray count];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SectionHeader *sectionHeader = [[[NSBundle mainBundle] loadNibNamed:@"SectionHeader" owner:nil options:nil]objectAtIndex:0];
    
	UIButton *button = [sectionHeader sectionButton];
    [button addTarget:self action:@selector(sectionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setTag:section];

    NSDictionary *sectionDic = [tableDic objectForKey:[NSString stringWithFormat:@"%d",section]];
    NSString *title = [sectionDic objectForKey:kCommonTitleKey];
    [[sectionHeader titleLabel] setText:title];
	return sectionHeader;
}


//单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    NSDictionary *sectionDic = [tableDic objectForKey:[NSString stringWithFormat:@"%d",[indexPath section]]];
    NSArray *sectionArray = [sectionDic objectForKey:kCommonSectionArray];
    [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [[cell textLabel] setMinimumScaleFactor:0.5f];
    [[cell textLabel] setText:[sectionArray objectAtIndex:[indexPath row]]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - others

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

-(void)initTable
{
    tableDic = [[DataCenter sharedInstance] commonDic];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initTable];
    expandArray = [[NSMutableArray alloc] initWithCapacity:[tableDic count]];
    for (int i = 0; i<[tableDic count]; i++)
    {
        [expandArray addObject:[NSNumber numberWithBool:NO]];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

    self.listTableView = nil;
    expandArray = nil;
}

-(void)dealloc
{
    NSLog(@"CommonUse dealloc");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
