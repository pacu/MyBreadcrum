//
//  BreadcrumbCell.h
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/6/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Breadcrumb.h"
@interface BreadcrumbCell : UICollectionViewCell
@property (nonatomic,strong)    IBOutlet UIImageView    *thumb;
@property (nonatomic,strong)    IBOutlet UILabel        *title;
@property (nonatomic,weak)               Breadcrumb     *breadcrumb;


@end
