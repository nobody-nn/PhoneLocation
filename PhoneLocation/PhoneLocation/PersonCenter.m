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

#define kIndexPathKey @"indexPath"
#define kLocationStringKey @"location"
#define kStoringKey @"storing"

@interface PersonCenter()

@property(nonatomic,retain) IBOutlet UITableView *phoneTableView;
@property(nonatomic,retain) IBOutlet UIImageView *headImageView;
@property(nonatomic,retain) IBOutlet UILabel *nameLabel;
@property(nonatomic,retain) IBOutlet UILabel *firstPhoneLabel;

@end

@implementation PersonCenter

@synthesize thisContact = _thisContact,parserDic;

#pragma mark - begining

-(void)viewWillAppear:(BOOL)animated
{
    //
}

#pragma mark - actions

-(IBAction)backClick:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)sendMessage:(id)sender
{
    
}

-(IBAction)simpleMessage:(id)sender
{
    
}

-(IBAction)call:(id)sender
{
    
}

-(IBAction)changeAvatar:(id)sender
{
    
}

-(IBAction)copyAndSend:(id)sender
{
    
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
