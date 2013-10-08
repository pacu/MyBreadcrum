//
//  MyBreadcrumsViewController.h
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/6/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface MyBreadcrumsViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate> {
    @private
    BOOL    _showLoading;
}


@property (nonatomic,strong)    IBOutlet UICollectionView   *collectionView;
@property (nonatomic,strong)             User               *user;
@property (nonatomic,strong)    IBOutlet UIView             *loadingView;
@property (nonatomic,strong)             NSMutableArray     *breadcrums;
@end
