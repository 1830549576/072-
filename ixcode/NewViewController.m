//
//  NewViewController.m
//  072EatBun
//
//  Created by alnpet on 16/5/26.
//  Copyright © 2016年 alnpet. All rights reserved.
//

#import "NewViewController.h"
#import "i072ViewController.h"

@interface NewViewController ()

@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(100, 100, 100, 50);
    
    [button setTitle:@"吃包子" forState:UIControlStateNormal];
    
    button.backgroundColor = [UIColor redColor];
    
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
}

- (void)buttonAction
{
    i072ViewController *eatBun = [[i072ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:eatBun];
     [self.navigationController pushViewController:eatBun animated:YES];
  //  [self presentViewController:nav animated:YES completion:nil];
    
    //    CollarMainViewController *eatBun = [[CollarMainViewController alloc] init];
   //  [self presentViewController:eatBun animated:YES completion:nil];
    //

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
