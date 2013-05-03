//
//  PhonesActionSheet.m
//  DialTool
//
//  Created by 艾文 李 on 11-12-17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "PhonesActionSheet.h"

@implementation PhonesActionSheet

-(id) initWithArray:(NSArray *)phonesArray 
              title:(NSString *)title
           delegate:(id <UIActionSheetDelegate>)delegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle 
destructiveButtonTitle:(NSString *)destructiveButtonTitle 
 otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    /*
    //可变长参数
    va_list args;
    va_start(args, otherButtonTitles);
    NSString *str = [[NSString alloc] initWithFormat:otherButtonTitles arguments:args];
    va_end(args);
    
    
    依此读取所有参数
    id eachObject;
    while ((eachObject = va_arg(args, id))) // As many times as we can get an argument of type "id"
        NSLog(@"%@",eachObject);              // that isn't nil, add it to self's contents.
    va_end(args);
     */
    
    self = [super initWithTitle:title delegate:delegate 
                        cancelButtonTitle:cancelButtonTitle 
                   destructiveButtonTitle:destructiveButtonTitle 
                        otherButtonTitles:otherButtonTitles,nil];
    //[str release];
    if (self) 
    {
        //添加tableView
        tableDataArray = phonesArray;
        NSLog(@"phones count:%d",[tableDataArray count]);
        UITableView *phonesTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        [phonesTable setDelegate:self];
        [phonesTable setDataSource:self];
        [phonesTable setRowHeight:40];
        [phonesTable setBackgroundColor:[UIColor clearColor]];
        [phonesTable setBackgroundView:nil];
        for (UIView *subView in self.subviews)
        {          
            if ([subView isKindOfClass:[UIButton class]]) 
            {
               [self insertSubview:phonesTable aboveSubview:subView];
                break;
            }
        }
    }
    return self;
}

//布局
-(void) layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = [self frame];
    int tableHeight = [tableDataArray count]<5? ([tableDataArray count] *40+20):180;
    int buttonY = frame.size.height +tableHeight - 40;
    for(UIView *view in self.subviews)
    {
        if (![view isKindOfClass:[UILabel class]]) 
        {    
            if([view isKindOfClass:[UITableView class]])
            {
                
                CGRect viewFrame = CGRectMake(23, 50, 274, tableHeight);
                [view setFrame:viewFrame];   
                frame.origin.y -= tableHeight + 30.0;//上移
                frame.size.height += tableHeight + 30.0;//添加
            } 
            else if(![view isKindOfClass:[UITableView class]]) 
            {
                CGRect viewFrame = [view frame];
                viewFrame.origin.y = buttonY;
                [view setFrame:viewFrame];
            }
        }
    }
    /*
    frame.origin.y -= tableHeight + 2.0;//上移
    frame.size.height += tableHeight + 2.0;//添加
    NSLog(@"y:%f,height:%f",frame.origin.y, frame.size.width);
     */
    [self setFrame:frame];
}

#pragma mark - table delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //do sth
    [self dismissWithClickedButtonIndex:[indexPath row]+1 animated:YES];
}

#pragma mark - table data source

//每个分组下数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"table begin load data");
    if(tableDataArray)
        return [tableDataArray count];
    return 0;
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
    }
    [[cell textLabel] setText:[tableDataArray objectAtIndex:[indexPath row]]];
    return cell;
}

- (void)dealloc 
{
    NSLog(@"PhonesActionSheet dealloc");
}

@end