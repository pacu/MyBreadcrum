//
//  ACLoginViewController.m
//  MyBreadcrum
//
//  Created by Francisco Gindre on 10/5/13.
//  Copyright (c) 2013 AppCrafter. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController (Private)

@end

@implementation LoginViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions
-(IBAction)login:(id)sender{
    
}

#pragma mark - segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewUser"]){
        
        UINavigationController * nc     = segue.destinationViewController;
        CreateUserViewController * c    = [[nc viewControllers]objectAtIndex:0];
        c.delegate                      = self;
        
    }
}

#pragma mark - Create user VC Delegate
-(void)didCreateUser:(CreateUserViewController*)controller {
    
    self.userField.text =controller.userField.text;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)createUserFailedWith:(NSError*)error{
    self.errorLabel.text = [error localizedDescription];
    [self.errorLabel setHidden:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)createUserCancelled {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
