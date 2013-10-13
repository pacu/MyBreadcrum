//
//  MyBreadcrumsViewController.h
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/6/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "NewBreadcrumViewController.h"
#import "EditProfileViewController.h"
#import "BreadcrumDetailViewController.h"
@interface MyBreadcrumsViewController : UIViewController   <UICollectionViewDataSource,
                                                            UICollectionViewDelegate,
                                                            NewBreadcrumDelegate,
                                                            BreadcrumbDetailDelegate,
                                                            EditViewControllerDelegate> {
    @private
   BOOL         _showLoading;                                                                

}



@property (nonatomic,strong)    IBOutlet UICollectionView   *collectionView;
@property (nonatomic,strong)             User               *user;
@property (nonatomic,strong)    IBOutlet UIView             *loadingView;
@property (nonatomic,strong)             NSMutableArray     *breadcrums;
@end
