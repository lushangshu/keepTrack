//
//  ShareSNS.h
//  KeepTrack
//
//  Created by lushangshu on 15-1-21.
//  Copyright (c) 2015年 PairProject. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ShareSNS;
@protocol ShareSNSListViewDataSource <NSObject>

@required
- (UITableViewCell *)ShareSNS:(ShareSNS *)ShareSNSListView
                    cellForIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)ShareSNSListView:(ShareSNS *)popoverListView
       numberOfRowsInSection:(NSInteger)section;
@end

@protocol UIShareSNSDelegate <NSObject>
@optional
- (void)ShareSNS:(ShareSNS *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath;

- (void)ShareSNSCancel:(ShareSNS *)popoverListView;

- (CGFloat)ShareSNS:(ShareSNS *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface ShareSNS : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_listView;
    UILabel     *_titleView;
    UIControl   *_overlayView;
    
    id<UIShareSNSDelegate> _delegate;
    id<ShareSNSListViewDataSource> _datasource;
}

@property (nonatomic,assign) id<UIShareSNSDelegate> delegate;
@property (nonatomic,assign) id<ShareSNSListViewDataSource> datasource;
@property (nonatomic,retain) UITableView *listView;

-(void)setTitle:(NSString *)title;
-(void)show;
-(void)dismiss;

@end
