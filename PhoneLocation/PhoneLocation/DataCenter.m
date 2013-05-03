//
//  DataCenter.m
//  SmsManager
//
//  Created by Nana Zhang on 12-2-17.
//  Copyright (c) 2012年 Nana inc. All rights reserved.
//

#import "DataCenter.h"
#define kChangedDicPath @"changed.plist"
#define kRequestedDicPath @"requested.plist"

@implementation DataCenter
@synthesize allContactsDic,documentPath,totalContactCount,addressFinishLoad,commonDic,root,tableDic,waiting,SendSmsTip,locationURLStringPre,whosWaiting,changedLocationDic,changedLocationPath,requestedDic,requestedPath,headImage,idURLStringPre;

static DataCenter *instance;
+(DataCenter *)sharedInstance
{
    if (!instance) 
    {
        instance = [[DataCenter alloc] init];
    }
    return instance;
}

-(id)init
{
    if (self = [super init]) 
    {
        self.totalContactCount = 0;
        self.addressFinishLoad = NO;
        self.documentPath = (NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.commonDic = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/common.plist",documentPath]];
        if (!commonDic) 
        {
            self.commonDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"common" ofType:@"plist"]];
            //第一次初始化,并且保存到用户文档目录
            [self saveCommonDic];
        }
        self.locationURLStringPre = @"http://www.youdao.com/smartresult-xml/search.s?type=mobile&q=";
        self.changedLocationPath = [NSString stringWithFormat:@"%@/%@",documentPath,kChangedDicPath];
        self.changedLocationDic = [NSMutableDictionary dictionaryWithContentsOfFile:self.changedLocationPath];
        if (!self.changedLocationDic)
        {
            self.changedLocationDic = [NSMutableDictionary dictionary];
        }
        self.labelsDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LabelComparison" ofType:@"plist"]];
        if (!self.labelsDic)
        {
            NSLog(@"sth is wrong");
        }
        requestedPath = [NSString stringWithFormat:@"%@/%@",documentPath,kRequestedDicPath];
        self.requestedDic = [NSMutableDictionary dictionaryWithContentsOfFile:self.requestedPath];
        if (!self.requestedDic)
        {
            self.requestedDic = [NSMutableDictionary dictionary];
        }
        self.headImage = [UIImage imageNamed:@"head.png"];
        self.idURLStringPre = @"http://www.youdao.com/smartresult-xml/search.s?type=id&q=";
    }
    return self;
}

-(void)saveCommonDic
{
    if(![self.commonDic writeToFile:[NSString stringWithFormat:@"%@/common.plist",self.documentPath] atomically:YES])
    {
        //should not be able to get here
    }
}
-(void)saveChangedDic
{
    if(![self.changedLocationDic writeToFile:self.changedLocationPath atomically:YES])
    {
        //should not be able to get here
    }
}
-(void)saveRequestedDic
{
    if(![self.requestedDic writeToFile:self.requestedPath atomically:YES])
    {
        //should not be able to get here
    }
}

@end
