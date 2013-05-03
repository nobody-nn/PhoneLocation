//
//  ViewController.m
//  PhoneLocation
//
//  Created by NanaZhang on 4/15/13.
//  Copyright (c) 2013 NanaZhang. All rights reserved.
//

#import "ViewController.h"
#import "DataCenter.h"
#import "ContactClass.h"
#import "FriendTableCell.h"
#import "PersonCenter.h"
#import "SearchViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize myTableView = _myTableView;

#pragma mark - actions

-(IBAction)moreClick:(id)sender
{
    
}

-(IBAction)searchClick:(id)sender
{
    if (!searchViewController)
    {
        searchViewController = [[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
    }
    [self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma mark - table delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!personCenter)
    {
        personCenter = [[PersonCenter alloc] initWithNibName:@"PersonCenter" bundle:nil];
    }

    ContactClass *contactForCell = [[contactsDic objectForKey:[keys objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]];
    [self.navigationController pushViewController:personCenter animated:YES];
    [personCenter setThisContact:contactForCell];
}

#pragma mark - table datasource

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    if(keys)
        return [keys count];
    return 0;
}

//分组标题名字
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *letter = [keys objectAtIndex:section];
    if (!letter)
    {
        return @"未知";
    }
    return letter;
}

//右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(keys)
        return keys;
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //此字母对应的分组下的联系人数量
    NSArray *sectionArray = [contactsDic objectForKey:[keys objectAtIndex:section]];
    int rowCount = [sectionArray count];
    return rowCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID;
    if (!cellID)
    {
        cellID = @"cell";
        UINib *cellNib = [UINib nibWithNibName:@"FriendTableCell" bundle:nil];
        [tableView registerNib:cellNib forCellReuseIdentifier:cellID];
    }
    FriendTableCell *cell;
    cell = (FriendTableCell *)[tableView dequeueReusableCellWithIdentifier:cellID];

    ContactClass *contactForCell = [[contactsDic objectForKey:[keys objectAtIndex:[indexPath section]]] objectAtIndex:[indexPath row]];
    [[cell nameLabel] setText:[contactForCell friendName]];
    [[cell phoneNumberLabel] setText:[contactForCell firstPhoneNumber]];
    if ([contactForCell headImage])
    {
        [[cell headImageView] setImage:[contactForCell headImage]];
    }
    else
    {
        [[cell headImageView] setImage:[[DataCenter sharedInstance] headImage]];
    }
    
    [[cell nameLabel] setBackgroundColor:[UIColor clearColor]];
    [[cell phoneNumberLabel] setBackgroundColor:[UIColor clearColor]];
    return cell;
}

#pragma mark - Data
-(void)setKeys:(NSArray *)keysArray
{
    NSArray *sortedKeys = [keysArray sortedArrayUsingSelector:@selector(compare:)];
    keys = sortedKeys;
}

//tableDataSource setter + 排序
-(void)setAllDataSource:(NSDictionary *)allDicData
{
    //按字母分组,下一级是数组
    NSMutableDictionary *tempDataSource = [NSMutableDictionary dictionaryWithCapacity:[allDicData count]];
    NSArray *sectionArray;
    for (NSString *key in [allDicData allKeys])
    {
        sectionArray = [allDicData objectForKey:key];
        sectionArray = [sectionArray sortedArrayUsingComparator:^(id obj1, id obj2)
                        {
                            NSString *friendName1,*friendName2;
                            friendName1 = [(ContactClass *)obj1 friendName];
                            friendName2 = [(ContactClass *)obj2 friendName];
                            //全部比较完，说明相同
                            return [friendName1 compare:friendName2];
                        }];
        [tempDataSource setObject:sectionArray forKey:key];
    }
    
    //字典还是没有顺序的，返回的keys排序
    contactsDic = tempDataSource;
    [self setKeys:[contactsDic allKeys]];
}

-(void)updateViewWithNewLoadData
{
    Waiting *waiting = [[DataCenter sharedInstance] waiting];
    if (waiting)
    {
        [waiting.view removeFromSuperview];
    }
    [self setAllDataSource:[[DataCenter sharedInstance] allContactsDic]];
    [self.myTableView setDelegate:self];
    [self.myTableView setDataSource:self];
    [self.myTableView reloadData];
}

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if ([[DataCenter sharedInstance] addressFinishLoad])
    {
        [self updateViewWithNewLoadData];
    }
    else
    {
        Waiting *waiting = [[DataCenter sharedInstance] waiting];
        if(!waiting)
        {
            waiting = [[Waiting alloc] initWithNibName:@"Waiting" bundle:nil];
            [waiting.view setFrame:CGRectMake(141, 211, 37, 37)];
            [[DataCenter sharedInstance] setWaiting:waiting];
        }
        [self.view addSubview:waiting.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
