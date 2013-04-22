//
//  NewCommonItem.m
//  SmsManager
//
//  Created by Nana Zhang on 12-2-21.
//  Copyright (c) 2012年 Nana inc. All rights reserved.
//

#import "NewCommonItem.h"
#import "DataCenter.h"

@implementation NewCommonItem
@synthesize parent,classifyPicker,contentTextView,scrollView;

#pragma mark - textView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [scrollView setContentSize:CGSizeMake(320, 651)];
    [scrollView setContentOffset:CGPointMake(0, 235) animated:YES];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [scrollView setContentSize:CGSizeMake(320, 416)];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textView resignFirstResponder];
}

#pragma mark - actions

-(IBAction)cancel:(id)sender
{
    [contentTextView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)Confirm:(id)sender
{
    //row
    //追加,保存文件,并且刷新
    NSString *contentString = [contentTextView text];
    if ([contentString length] == 0) 
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写要添加的内容" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [contentTextView resignFirstResponder];
    int index = [classifyPicker selectedRowInComponent:0];
    NSMutableDictionary *commonDic = [NSMutableDictionary dictionaryWithDictionary: [[DataCenter sharedInstance] commonDic]];
    NSMutableDictionary *sectionDic = [NSMutableDictionary dictionaryWithDictionary:[commonDic objectForKey:[NSString stringWithFormat:@"%d",index]]];
    NSMutableArray *sectionArray = [NSMutableArray arrayWithArray:[sectionDic objectForKey:kCommonSectionArray]];
    [sectionArray addObject:contentString];
    [sectionDic setObject:sectionArray forKey:kCommonSectionArray];
    [commonDic setObject:sectionDic forKey:[NSString stringWithFormat:@"%d",index]];
    //保存,刷新
    [[DataCenter sharedInstance] setCommonDic:commonDic];
    [[DataCenter sharedInstance] saveCommonDic];
    [parent initTable];
    [[parent expandArray] replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:YES]];
    [[parent listTableView] reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - picker delegate


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [classifyArray objectAtIndex:row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [classifyArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    classifyArray = [[NSArray alloc] initWithObjects:@"常用短语",@"邮箱",@"银行帐号",@"游戏帐号",@"地址",@"其他", nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.classifyPicker = nil;
    self.contentTextView = nil;
    self.scrollView = nil;
    classifyArray = nil;
}

-(void)dealloc
{
    NSLog(@"NewCommonItem dealloc");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
