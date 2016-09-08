//
//  NavChooseView.h
//  jiaolian
//
//  Created by hlj on 15/2/5.
//  Copyright (c) 2015年 脑洞 ios. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NavChooseView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

/**
 *使用该方法创建本视图
 */
+(NavChooseView *)getChooseNavView;

//使用该方法传入所需要的值   顺序分别是：
/**
 * lat                          精度
 * lng                          维度
 * detailedAddress              详细地址
 * shopName                     商店名字
 */

- (void)startLat:(NSString * )lat lng:(NSString *)lng detailedAddress:(NSString *)detailedAddress shopName:(NSString *)shopName;

@end
