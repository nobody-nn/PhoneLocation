//
//  DataCenter.h
//  SmsManager
//
//  Created by Nana Zhang on 12-2-17.
//  Copyright (c) 2012年 Nana inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "Waiting.h"

#define kCommonTitleKey @"title"
#define kCommonSectionArray @"sectionArray"
#define kTitleKey @"title"
#define kContentKey @"content"
#define kSendToKey @"sendTo"

#define H_CONTROL_ORIGIN CGPointMake(20, 70)

@interface DataCenter : NSObject

@property(nonatomic,retain) NSDictionary *allContactsDic,*commonDic,*tableDic;
@property(nonatomic,retain) NSString *documentPath,*locationURLStringPre;
@property(nonatomic,assign) int totalContactCount,TMobileIndex,currentFaceType;
@property(nonatomic,assign) BOOL addressFinishLoad;
@property(nonatomic,retain) ViewController *root;
@property(nonatomic,retain) Waiting *waiting;
@property(nonatomic,retain) UIView *SendSmsTip;
@property(nonatomic,retain) UIViewController *whosWaiting;

+(DataCenter *)sharedInstance;
-(void)saveCommonDic;

@end
