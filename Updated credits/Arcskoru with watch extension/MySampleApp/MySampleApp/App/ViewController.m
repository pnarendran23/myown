//
//  ViewController.m
//  plaque
//
//  Created by Group X on 11/01/16.
//  Copyright © 2016 own. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
int widt,heigh;
BOOL clicked=NO;
-(void)viewDidAppear:(BOOL)animated{
    [self.spinner.layer setCornerRadius:5];
    [self.spinner.layer setMasksToBounds: YES];
    self.navigationController.delegate = self;
    self.navigationController.navigationBar.backItem.title = @"Back";
    NSString *plaquebaseURL = @"https://stg.app.arconline.io";
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"building_details"]];
    NSString *urlstring = [NSString stringWithFormat:@"%@/plaque/%@/%@",plaquebaseURL,dict[@"leed_id"],dict[@"key"]];
    NSLog(@"%@",urlstring);
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlstring]];
    [self.navigationController setNavigationBarHidden:YES];
    [_wview loadRequest:request];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    self.spinner.hidden = NO;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.spinner.hidden = YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.spinner.hidden = YES;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //self.navigationController?.setNavigationBarHidden[(true, animated: false)
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if([[viewController restorationIdentifier]isEqualToString:@"more"]){
        self.navigationController.hidesBarsOnTap = NO;
        self.navigationController.hidesBarsOnSwipe = NO;
        self.navigationController.hidesBarsWhenKeyboardAppears = NO;
        self.navigationController.hidesBarsWhenVerticallyCompact = NO;
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIView setAnimationsEnabled:YES];
    self.navigationController.hidesBarsOnTap = YES;
    self.navigationController.hidesBarsOnSwipe = YES;
    self.navigationController.hidesBarsWhenKeyboardAppears = YES;
    self.navigationController.hidesBarsWhenVerticallyCompact = YES;
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"building_details"]];    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans" size:17], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@",dict[@"name"]]];
    
    //The event handling method
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //    [self connect];
    
}




-(void)connect{
    
    // this .csv file is seperated with new line character
    // if .csv is seperated by comma use "," instesd of "\n"
    //NSLog(@"%@",leedarray[0]);
    
    //  NSString *url=[NSString stringWithFormat:@"http://%@/%@/performance/?key=%@",leedarray[0],leedarray[1],leedarray[2]];
    //   //NSLog(@"%@",url);
    @try {
        
    }@catch(NSException *e){
        [self.bigplaque removeFromSuperview];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                        message:@"Unable to connect to server" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction= [UIAlertAction actionWithTitle:@"Reload"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       {
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                           [self connect];
                                           
                                       }];
        UIAlertAction *noAction= [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                  {
                                      exit(0);
                                      
                                  }];
        [alert addAction:defaultAction];
        [alert addAction:noAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}

-(BOOL)shouldAutorotate{
    return  YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [UIView setAnimationsEnabled:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [UIView setAnimationsEnabled:YES];
}

- (void)handleTapGestur:(UITapGestureRecognizer *)sender {
    NSLog(@"Hello");
    self.plaquesuperview.alpha=0.1;
    self.bigplaque.hidden=NO;
    self.bigplaque.alpha=1;
    self.gback.hidden=NO;
}



/*
 -(void)viewDidAppear:(BOOL)animated{
 UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Choose"
 message:@"Answer the question" preferredStyle:UIAlertControllerStyleAlert];
 UIAlertAction *defaultAction= [UIAlertAction actionWithTitle:@"YES"
 style:UIAlertActionStyleDefault
 handler:nil];
 UIAlertAction *noAction= [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
 {
 NSLog(@"NO");
 [alert dismissViewControllerAnimated:YES completion:nil];
 
 }];
 [alert addAction:defaultAction];
 [alert addAction:noAction];
 [self presentViewController:alert animated:YES completion:nil];
 
 
 }*/



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    self.plaquesuperview.alpha=1;
    self.bigplaque.hidden=YES;
    self.bigplaque.alpha=0;
    self.gback.hidden=YES;
}

-(void)hidespinner
{
    self.spinnerview.hidden=YES;
}
- (IBAction)closeit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
