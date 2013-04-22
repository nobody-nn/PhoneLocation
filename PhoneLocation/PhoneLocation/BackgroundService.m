//
//  BackgroundService.m
//  DialTool
//
//  Created by 张 娜娜 on 11-12-7.
//  Copyright (c) 2011年 纵横万维. All rights reserved.
//

#import "BackgroundService.h"
#import "ContactClass.h"
#import "DataCenter.h"
//#import "hzpyDicCode.h"
#import "ViewController.h"

@implementation BackgroundService

-(id)init
{
    if(self = [super init])
    {
        //words = [hzpyDicCode getHzpyDic];
        
        words = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wordsDic" ofType:@"plist"]];
    }
    return self;
}


//获取联系人的姓名
-(NSString *)getNameOfRecord:(ABRecordRef) record
{
    NSString *friendName = nil;
    NSString *firstName = nil;
    NSString *lastName = nil;
    
    firstName = (__bridge NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
    if(firstName)
    {
        friendName = firstName;
    }
    
    lastName = (__bridge NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
    if(lastName && friendName)
    {
        friendName = [lastName stringByAppendingString:friendName];
    }
    else if(lastName)
    {
        friendName = lastName;
    }

    if(!friendName || [friendName length]<=0)
    {
        //什么都没有
        friendName = @"";
    }
    
    return friendName;
}
 
//读取通讯录
-(void)readLocalAddress
{
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
    
    if (!addressRef)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通讯录访问被禁止" message:@"请在系统->设置->隐私->通讯录里开启访问权限" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
        return;
    }

    NSArray *personArray = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressRef);
    //26字母+#
    NSMutableDictionary *tempContactDic = [NSMutableDictionary dictionaryWithCapacity:27];

    NSString *friendName;
    ContactClass *contact;
    NSMutableArray *perLetterArray;

    NSString *word;
    NSString *wordSpell;
    int unicodeValue;
    int recordID;
    
    NSString *firstLetter;
    CFDataRef cfdata;
    UIImage *headImage;
    
    ABMultiValueRef phones;
    CFStringRef eachPhoneNumRef;
    NSString *eachPhoneNum;
    
    int noImageCount = 0;
    
    for (id personRef in personArray)
    {
        recordID = ABRecordGetRecordID((__bridge ABRecordRef)(personRef));
        
        contact = [[ContactClass alloc] init];
        [contact setRecordID:recordID];
        
        phones = ABRecordCopyValue((__bridge ABRecordRef)(personRef),kABPersonPhoneProperty);
        int phoneCount = ABMultiValueGetCount(phones);
        if (phoneCount > 0)
        {
            NSMutableArray *phoneArray = [NSMutableArray arrayWithCapacity:phoneCount];
            for (int i = 0; i<phoneCount; i++)
            {
                eachPhoneNumRef = ABMultiValueCopyValueAtIndex(phones, 0);
                eachPhoneNum = (__bridge NSString *)eachPhoneNumRef;
                [phoneArray addObject:eachPhoneNum];
                if (![contact firstPhoneNumber])
                {
                    [contact setFirstPhoneNumber:eachPhoneNum];
                }
                CFRelease(eachPhoneNumRef);
            }
            [contact setPhoneNumbersArray:phoneArray];//全部手机号
        }
        
        CFRelease(phones);
        //--------名字--------
        friendName = [self getNameOfRecord:(__bridge ABRecordRef)(personRef)];
        [contact setFriendName:friendName];
        
        //--------头像--------
        if(ABPersonHasImageData((__bridge ABRecordRef)(personRef)))
        {
            cfdata=ABPersonCopyImageData((__bridge ABRecordRef)(personRef));
            headImage = [UIImage imageWithData:(__bridge NSData *)cfdata];
            [contact setHeadImage:headImage];
            CFRelease(cfdata);
        }
        else
        {
            noImageCount++;
        }
        
        firstLetter = nil;

        if (friendName.length>0)
        {
            word = [friendName substringToIndex:1];
            unicodeValue = [word cStringUsingEncoding:NSUnicodeStringEncoding][1];
            if(unicodeValue==0)
            {
                //字母或数字的话...
                firstLetter = [[word substringToIndex:1] capitalizedString];
                [contact setFirstLetter:firstLetter];
            }
            else
            {
                //常用拼音
                wordSpell = [words objectForKey:word];
                if(!firstLetter)
                    firstLetter = [wordSpell substringToIndex:1];
            }
        }
        if(!firstLetter)
        {
            //无名称的分类的＃栏
            firstLetter = @"#";
        }
        
        perLetterArray = [tempContactDic objectForKey:firstLetter];
        if(!perLetterArray)
        {
            //如果不存在，初始化
            perLetterArray = [NSMutableArray array];
        }
        [perLetterArray addObject:contact];
        //以首字母做为键值，保存数组
        [tempContactDic setObject:perLetterArray forKey:firstLetter];
    }
    [[DataCenter sharedInstance] setTotalContactCount:noImageCount];
    [[DataCenter sharedInstance] setAllContactsDic:tempContactDic];
    
    ViewController *viewController = [[DataCenter sharedInstance] root];
    if(viewController)
    {
        [viewController performSelectorOnMainThread:@selector(updateViewWithNewLoadData) withObject:nil waitUntilDone:NO];//对应更新全部联系人
    }

    [[DataCenter sharedInstance] setAddressFinishLoad:YES];
    
    CFRelease(addressRef);
}

@end
