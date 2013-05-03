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
#define kLocationLabel @"location"
#define kBirthdayLabel @"birthday"
#define kGenderLabel @"gender"

#define H_CONTROL_ORIGIN CGPointMake(20, 70)

@interface DataCenter : NSObject

@property(nonatomic,retain) NSDictionary *allContactsDic,*commonDic,*tableDic;
@property(nonatomic,retain) NSString *documentPath,*locationURLStringPre,*changedLocationPath,*requestedPath,*idURLStringPre;
@property(nonatomic,assign) int totalContactCount,TMobileIndex,currentFaceType;
@property(nonatomic,assign) BOOL addressFinishLoad;
@property(nonatomic,retain) ViewController *root;
@property(nonatomic,retain) Waiting *waiting;
@property(nonatomic,retain) UIView *SendSmsTip;
@property(nonatomic,retain) UIViewController *whosWaiting;
@property(nonatomic,retain) NSMutableDictionary *changedLocationDic;
@property(nonatomic,retain) NSDictionary *labelsDic;
@property(nonatomic,retain) NSMutableDictionary *requestedDic;
@property(nonatomic,retain) UIImage *headImage;//默认头像

+(DataCenter *)sharedInstance;
-(void)saveCommonDic;
-(void)saveChangedDic;
-(void)saveRequestedDic;

@end
