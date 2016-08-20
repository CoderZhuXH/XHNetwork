//
//  ViewController.m
//  XHNetworkExample
//
//  Created by xiaohui on 16/8/20.
//  Copyright © 2016年 returnoc.com. All rights reserved.
//

#import "ViewController.h"
#import "XHNetwork.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [XHNetwork POST:@"https://www.myeevy.com/https.php" parameters:nil success:^(id responseObject) {
        
        
        NSLog(@"res=%@",responseObject);
        
    } failure:^(NSError *error) {
        
        
    }];
    
    // Do any additional setup after loading the view from its nib.
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
