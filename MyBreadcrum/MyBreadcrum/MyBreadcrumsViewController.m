//
//  MyBreadcrumsViewController.m
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/6/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import "MyBreadcrumsViewController.h"
#import "ACAppDelegate.h"
#import <CoreData/CoreData.h>
#import "BreadcrumbCell.h"
#import "Breadcrumb.h"
#import <QuartzCore/QuartzCore.h>
#import "NewBreadcrumViewController.h"
@interface MyBreadcrumsViewController ()


-(void)showLoadingView;
-(void)hideLoadingView;
@end

@implementation MyBreadcrumsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.breadcrums = [NSMutableArray array]; // create an empty array so that collection view does not crash
	// Do any additional setup after loading the view.
    
    if ([self.breadcrums count]>0){
    // set up operation to do all sorting and heavy stuff
        
    
        NSBlockOperation * operation = [NSBlockOperation blockOperationWithBlock:^{
            
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
            NSArray   *sortedArray = [[self.user.breadcrum allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
            
            self.breadcrums        = [NSMutableArray arrayWithArray:sortedArray];
            
        }];
        
            // Discussion: a time interval should be tracked so that the animations look good and do not
            // show or hide to quick that they can't be read or appreciated as a feature and not as a glitch
        [operation setCompletionBlock:^{
            [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            [self performSelectorOnMainThread:@selector(hideLoadingView) withObject:nil waitUntilDone:YES];
            
        }];
        [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
        [[NSOperationQueue currentQueue] addOperation:operation];
        _showLoading = YES;
        
    
    }else {
        _showLoading = NO; // this is default, but makes it easier to understand
    }
    
    // default initalization for loading view
    
    self.loadingView.layer.cornerRadius = 30;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_showLoading){
        [self showLoadingView];
    }
    
}


-(void)dealloc {
    self.user       = nil;
    self.breadcrums = nil;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - animations 

-(void)showLoadingView{
    [self.view setUserInteractionEnabled:NO];
    self.loadingView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.loadingView.hidden = NO;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.loadingView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        
    }];

}
-(void)hideLoadingView{
    
    self.loadingView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.loadingView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){
        [self.view setUserInteractionEnabled:YES];
        self.loadingView.hidden = YES;
    }];

    
}

#pragma mark - UICollectionView data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.breadcrums count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BreadcrumbCell * cell   = [collectionView dequeueReusableCellWithReuseIdentifier:@"BreadcrumCell" forIndexPath:indexPath];
    
    Breadcrumb  * crumb     = [self.breadcrums objectAtIndex:indexPath.row];
    cell.thumb.image        = crumb.location.thumb;
    cell.title.text         = crumb.title;
    
    
    return cell;
}
#pragma mark - UICollecitonView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"NewBreadcrumb"]) {
        
        NewBreadcrumViewController * nextVC = segue.destinationViewController;
        nextVC.delegate = self;
        
    }
    
    
}

#pragma  mark - NewBreadcrumb delegate 
-(void)newBreadCrumbController:(NewBreadcrumViewController *)controller failedWithError:(NSError *)error{
    [self.navigationController popViewControllerAnimated:YES];
    
    [[[UIAlertView alloc]initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil]show];

    
}

-(void) newBreadCrumbControllerCancelled:(NewBreadcrumViewController *)controller {
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void) newBreadcrumController:(NewBreadcrumViewController *)controller didCreateBreadCrumb:(Breadcrumb *)breadcrumb {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

@end
