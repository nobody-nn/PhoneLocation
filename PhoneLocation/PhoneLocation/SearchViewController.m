//
//  SearchViewController.m
//  PhoneLocation
//
//  Created by girl on 13-4-17.
//  Copyright (c) 2013年 NanaZhang. All rights reserved.
//

#import "SearchViewController.h"
#import "BackgroundService.h"
#import "DataCenter.h"

@interface UIScrollView (touch)

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@implementation UIScrollView (touch)

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.nextResponder touchesBegan:touches withEvent:event];
}

@end

@interface SearchViewController ()
@property(nonatomic,retain) IBOutlet UITextField *searchLocationField,*searchIDField;
@property(nonatomic,retain) IBOutlet UILabel *locationLabel,*IDLocationLabel,*IDBirthdayLabel,*IDGenderLabel,*tipLabel;
@property(nonatomic,retain) IBOutlet UIScrollView *myScrollView;
@property(nonatomic,retain) NSMutableString *lastElement;
@end

@implementation SearchViewController
@synthesize searchLocationField,searchIDField,locationLabel,myScrollView,lastElement,IDBirthdayLabel,IDGenderLabel,IDLocationLabel,tipLabel;

#pragma mark - touch

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.searchLocationField resignFirstResponder];
    [self.searchIDField resignFirstResponder];
}

- (IBAction)editBegin:(id)sender
{
    switch ([sender tag])
    {
        case 0:
        {
            [self.myScrollView setContentSize:CGSizeMake(320, 419)];
            [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
        }
        case 1:
        {
            [self.myScrollView setContentSize:CGSizeMake(320, 551)];
            [self.myScrollView setContentOffset:CGPointMake(0, 133) animated:YES];
            break;
        }
        default:
            break;
    }
}

-(IBAction)editEnd:(id)sender
{
    switch ([sender tag])
    {
        case 0:
        {
            [self searchPhoneClick:nil];
            break;
        }
        case 1:
        {
            [self searchIDClick:nil];
            break;
        }
        default:
            break;
    }
}

#pragma mark - parse delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *) qualifiedName attributes:(NSDictionary *)attributeDict
{//起始标签
    storing = YES;
    [self.lastElement setString:@""];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{//结束标签
    if (type == SearchID)
    {
        if ([elementName isEqualToString:kLocationLabel])
        {
            [self.IDLocationLabel setText:lastElement];
        }
        else if ([elementName isEqualToString:kBirthdayLabel])
        {
            [self.IDBirthdayLabel setText:lastElement];
        }
        else if ([elementName isEqualToString:kGenderLabel])
        {
            if ([lastElement isEqualToString:@"f"])
            {
                [self.IDGenderLabel setText:@"女"];
            }
            else if ([lastElement isEqualToString:@"m"])
            {
                [self.IDGenderLabel setText:@"男"];
            }
        }
    }
    else if (type == SearchPhone)
    {
        if ([elementName isEqualToString:kLocationLabel])
        {
            if (self.lastElement && [self.lastElement length] > 0)
            {
                [self.locationLabel setText:[NSString stringWithFormat:@"卡号归属地:%@",self.lastElement]];
            }
            else
            {
                [self.locationLabel setText:@"请检查号码输入是否有误"];
            }
        }
    }
    storing = NO;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{//内容字符
    
    if (storing)
    {
        [self.lastElement appendString:string];
    }
}


#pragma mark - actions

-(void)addWaiting
{
    [self.view setUserInteractionEnabled:NO];
    
    [self.myScrollView setContentSize:CGSizeMake(320, 419)];
    [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    Waiting *waiting = [[DataCenter sharedInstance] waiting];
    if(!waiting)
    {
        waiting = [[Waiting alloc] initWithNibName:@"Waiting" bundle:nil];
        [waiting.view setFrame:CGRectMake(141, 211, 37, 37)];
        [[DataCenter sharedInstance] setWaiting:waiting];
    }
    [self.view addSubview:waiting.view];
}

-(void)removeWaiting
{
    Waiting *waiting = [[DataCenter sharedInstance] waiting];
    if (waiting)
    {
        [waiting.view removeFromSuperview];
    }
    [self.view setUserInteractionEnabled:YES];
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

-(BOOL)hasNetWorkOrNot
{
    BOOL hasNetwork = [BackgroundService connectedToNetwork];
    if (!hasNetwork)
    {
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
    return hasNetwork;
}

-(IBAction)searchIDClick:(id)sender
{
    if (![self hasNetWorkOrNot])
    {
        return;
    }
    [self.searchIDField resignFirstResponder];
    [self.searchLocationField resignFirstResponder];
    type = SearchID;
    [self.tipLabel setText:@""];
    [self.IDLocationLabel setText:@""];
    [self.IDBirthdayLabel setText:@""];
    [self.IDGenderLabel setText:@""];
    
    NSString *inputID = [searchIDField text];
    inputID = [BackgroundService getNumeralWith:inputID];
    if ([inputID length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入身份证号" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        if ([inputID length] == 18 && [[[inputID substringToIndex:[inputID length] - 1] lowercaseString] isEqualToString:@"x"])
        {
            inputID = [BackgroundService getNumeralWith:inputID];
            if ([inputID length] != 17)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入合法的身份证号" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [alert show];
            }
            else
            {
                inputID = [NSString stringWithFormat:@"%@x",inputID];
            }
        }
        else
        {
            inputID = [BackgroundService getNumeralWith:inputID];
            if ([inputID length] != 15 && [inputID length] !=18)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入合法的身份证号" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [alert show];
            }
        }
        
        NSString *correctID = [BackgroundService getCorrectIDWith:inputID];//修正过
        if (![correctID isEqualToString:inputID])
        {
            [self.tipLabel setText:@"提示:该18位身份证号校验位不正确"];
        }
        
        [self addWaiting];
        
        NSString *URLString = [NSString stringWithFormat:@"%@%@",[[DataCenter sharedInstance] idURLStringPre],correctID];
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
        
        [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc] init] completionHandler:
         ^(NSURLResponse *response,NSData *data,NSError *error)
         {
             [self performSelectorOnMainThread:@selector(removeWaiting) withObject:nil waitUntilDone:NO];
             NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
             
             parser.delegate = self;
             [parser performSelectorOnMainThread:@selector(parse) withObject:nil waitUntilDone:NO];
             //[parser parse];
         }
         ];
    }
}

-(IBAction)searchPhoneClick:(id)sender
{
    if (![self hasNetWorkOrNot])
    {
        return;
    }
    [self.searchIDField resignFirstResponder];
    [self.searchLocationField resignFirstResponder];
    type = SearchPhone;
    [self.locationLabel setText:@""];
    NSString *inputPhone = [searchLocationField text];
    inputPhone = [BackgroundService getNumeralWith:inputPhone];
    if ([inputPhone length] != 11)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入合法手机号" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        [self addWaiting];
        
        //TODO:请求，解析
        NSString *URLString = [NSString stringWithFormat:@"%@%@",[[DataCenter sharedInstance]locationURLStringPre],[BackgroundService getNumeralWith:inputPhone]];
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
        
        [NSURLConnection sendAsynchronousRequest:req queue:[[NSOperationQueue alloc] init] completionHandler:
         ^(NSURLResponse *response,NSData *data,NSError *error)
         {
             [self performSelectorOnMainThread:@selector(removeWaiting) withObject:nil waitUntilDone:NO];
             NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
             parser.delegate = self;
             [parser performSelectorOnMainThread:@selector(parse) withObject:nil waitUntilDone:NO];
         }
         ];
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
    self.lastElement = [NSMutableString string];
    [self.myScrollView setContentSize:CGSizeMake(320, 419)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
