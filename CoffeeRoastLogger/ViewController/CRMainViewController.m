//
//  CRMainViewController.m
//  CoffeeRoastLogger
//
//  Created by Hiraku Ohno on 2014/02/13.
//  Copyright (c) 2014年 Hiraku Ohno. All rights reserved.
//

#import "CRMainViewController.h"
#import "CRRoastManager.h"
#import "CRRoastDataSource.h"
#import "CRConfiguration.h"

@interface CRMainViewController ()<CRRoastDataSourceInitialLoadingDelegate, UIAlertViewDelegate>

@end

@implementation CRMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [CRRoastManager sharedManager].dataSource.initialLoadingDelegate = self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [CRRoastManager sharedManager].dataSource.initialLoadingDelegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - InitialLoadingDelegate
- (void)dataSource:(CRRoastDataSource *)dataSource didLoadDataWithCloud:(BOOL)isCloud
{
    if([CRConfiguration sharedConfiguration].iCloudConfigured) {
        if(isCloud || ![CRConfiguration sharedConfiguration].iCloudAvailable) {
            [self performSegueWithIdentifier:@"loadingComplete" sender:nil];
        }
    } else {
        [self showiCloudConfirmationAlertView];
    }
}

- (void)dataSourceCannotUseCloud:(CRRoastDataSource *)dataSource
{
    [self performSegueWithIdentifier:@"loadingComplete" sender:nil];
}

- (void)showiCloudConfirmationAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UseiCloud", nil) message:NSLocalizedString(@"UsingiCloudNotification", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"CancelLabel", nil) otherButtonTitles:NSLocalizedString(@"YES", nil), nil];
    [alertView show];
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [CRConfiguration sharedConfiguration].iCloudConfigured = YES;
    switch (buttonIndex) {
        case 0 :
            [CRRoastManager sharedManager].dataSource.iCloudAvailable = NO;
            [self performSegueWithIdentifier:@"loadingComplete" sender:nil];
            return;
        case 1 :
            [CRRoastManager sharedManager].dataSource.iCloudAvailable = YES;
            return;
        default :
            return;
    }
}

@end