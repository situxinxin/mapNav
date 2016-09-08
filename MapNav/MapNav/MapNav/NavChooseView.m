//
//  NavChooseView.m
//  jiaolian
//
//  Created by hlj on 15/2/5.
//  Copyright (c) 2015年 脑洞 ios. All rights reserved.
//

#import "NavChooseView.h"
#import <MapKit/MapKit.h>


//导航type
typedef NS_ENUM(NSInteger, NavType)
{
    BaiduNav = 1,
    TencentNav = 2,
    GaodeNav= 3,
    SystemNav = 4
};

@interface NavChooseView()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray * _itemArray;
    int     * navTypeArray;
}

@property (nonatomic,strong) IBOutlet UICollectionView * navCollectionView;

@property (nonatomic,strong) IBOutlet UIView * contrainerView;

@property (nonatomic, strong) NSString * DetailedAddress;   //商店地址
@property (nonatomic, strong) NSString * lat;               //精度
@property (nonatomic, strong) NSString * lng;               //维度
@property (nonatomic, strong) NSString * shopName;          //商店名字
@property (nonatomic, strong) NSArray  * itemArray;         //数据array

@end


@implementation NavChooseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(NavChooseView *)getChooseNavView
{
    NavChooseView * navChoose =[[NSBundle mainBundle]loadNibNamed:@"NavChooseView" owner:nil options:nil][0];
    
    [navChoose.navCollectionView registerNib:[UINib nibWithNibName:@"NavStyleCell" bundle:nil] forCellWithReuseIdentifier:@"NavStyleCell"];
    
    navChoose.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0];
    
    return navChoose;
}


- (void)startLat:(NSString * )lat lng:(NSString *)lng detailedAddress:(NSString *)detailedAddress shopName:(NSString *)shopName
{
    self.lat = lat;
    self.lng = lng;
    self.DetailedAddress = detailedAddress;
    self.shopName = shopName;
    
    [self jumpToNav];
}


-(NSArray *)itemArray
{
    if (_itemArray) {
        return _itemArray;
    }
    _itemArray =[@[] copy];
    return _itemArray;
}


-(void)setItemArray:(NSArray *)itemArray
{
    _itemArray = itemArray;
    
    [self.navCollectionView reloadData];
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self jumpToNavWithItemINfo:self.itemArray[indexPath.row]];
    
    [self hidden];
}

-(void)show
{
    self.hidden = NO;

    [UIView animateWithDuration:0.25 animations:^{
        
        self.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.7];
        
        self.contrainerView.frame = CGRectMake(10, self.frame.size.height - (60 + 50 * _itemArray.count), self.frame.size.width - 20, 50 + 50 * _itemArray.count);
    }];
}


-(void)hidden
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0];
        
        self.contrainerView.frame = CGRectMake(10, self.frame.size.height, self.frame.size.width - 20, 50 + 50 * _itemArray.count);
        
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
    //显示View 下去
    
    //背景渐渐隐藏
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"NavStyleCell" forIndexPath:indexPath];
    
    UIImageView * imgView =(UIImageView *)[cell viewWithTag:1001];
   
    UILabel * label =(UILabel *)[cell viewWithTag:1002];
    
    NSDictionary * itemDic =self.itemArray[indexPath.row];
    
    NSString * navImgName =[itemDic objectForKey:@"NavImg"];
    
    NSString * navTitle = [itemDic objectForKey:@"NavTitle"];
    
    [imgView setImage:[UIImage imageNamed:navImgName]];
    [label setText:navTitle];
    
    return cell;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hidden];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    CGFloat itemWidth = collectionView.frame.size.height;  // [UIScreen mainScreen].bounds.size.width / 5;
    //    CGFloat collectionItemHeight = itemWidth *(200.0f/300.0f);
    return CGSizeMake(self.frame.size.width - 20 , 50);
}



#pragma mark - 点击导航

- (void) baiduMapNav
{
    NSString *stringURL = [NSString stringWithFormat:@"baidumap://map/direction?origin=%.8f,%.8f&destination=%.8f,%.8f&&mode=driving&src=vjifen",111.1,341.112,[self.lat floatValue],[self.lng floatValue]];
    
    
    NSURL *url = [NSURL URLWithString:[stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
}

-(void)gaoDeNav
{
    NSString * stringUrl= [NSString stringWithFormat:@"iosamap://navi?sourceApplication=broker&backScheme=openbroker2&poiname=%@&poiid=BGVIS&lat=%.8f&lon=%.8f&dev=1&style=2",self.shopName,[self.lat floatValue],[self.lng floatValue]];
    
    
    NSURL *url = [NSURL URLWithString:[stringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
    
}

- (void)systemMapNav
{
    CLLocationCoordinate2D to ;
    
    to.latitude = [self.lat floatValue] ;// lat;
    
    to.longitude = [self.lng floatValue]; // lng;
    
    MKMapItem * currentAction = [MKMapItem mapItemForCurrentLocation];
    //    currentAction.name = @"您的位置";
    
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
    
    toLocation.name = self.DetailedAddress;// target location name;
    
    [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentAction, toLocation, nil] launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil] forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
    
}



#pragma mark - 跳到导航页面
-(void)jumpToNavWithItemINfo:(NSDictionary *)info
{
    NSString * navType = [info objectForKey:@"NavTitle"];
    
    if([navType isEqualToString:@"高德导航"])
    {
        [self gaoDeNav];
    }else if ([navType isEqualToString:@"百度导航"])
    {
        [self baiduMapNav];
    }else
    {
        [self systemMapNav];
    }
    
}

-(void)jumpToNav
{
    
    self.frame = [UIScreen mainScreen].bounds;
    
    int i = 0;
    NSMutableArray * titleArray = [@[] mutableCopy];
    if (navTypeArray==Nil) {
        navTypeArray=malloc(sizeof(int)*4);
        
    }
    //检测 可以选择的导航软件
    NSString *stringURLBaidu = [NSString stringWithFormat:@"baidumap://"];
    BOOL canUseBaidu = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:stringURLBaidu]];
    if (canUseBaidu) {
        navTypeArray[i]=BaiduNav;
        [titleArray addObject:@{@"NavTitle":@"百度导航",@"NavImg":@"baidu"}];
        i++;
    }
    
    //高德地图
    NSString *stringURLGaode = [NSString stringWithFormat:@"iosamap://"];
    BOOL canUseGaode = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:stringURLGaode]];
    if (canUseGaode) {
        navTypeArray[i]=BaiduNav;
        [titleArray addObject:@{@"NavTitle":@"高德导航",@"NavImg":@"gaode"}];
        i++;
    }
    
    
    
    if (i<1) {
        
//        [titleArray addObject:@{@"NavTitle":@"系统导航",@"NavImg":@"system"}];
//        
//        self.itemArray = titleArray;
//        [self.navCollectionView reloadData];
//
//        [self show];
        
        [self systemMapNav];
    }else
    {
        self.itemArray = titleArray;
        
        _contrainerView.layer.cornerRadius = 5;
        
        _contrainerView.layer.masksToBounds = YES;
        
        _navCollectionView.frame = CGRectMake(0, 50, _contrainerView.frame.size.width, self.itemArray.count * 50);
        
        [self.navCollectionView reloadData];
        
        [self show];

    }

    
}




@end
