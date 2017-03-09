//
//  MainViewController.m
//  view3DforOC
//
//  Created by senyu on 2017/2/10.
//  Copyright © 2017年 senyu. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"login";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:34/255.0 green:156/255.0 blue:143/255.0 alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (IBAction)login:(id)sender {
    if([_account.text isEqualToString:@""] == true){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入账号" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [_account becomeFirstResponder];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else if([_password.text isEqualToString:@""] == true){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入密码" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [_password becomeFirstResponder];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
//        // POST请求
//        NSString *urlString = [NSString stringWithFormat:@"%@", @"http://nowprinter.com/login"];
//        //创建url对象
//        NSURL *url = [NSURL URLWithString:urlString];
//        //创建请求
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
//        //创建参数字符串对象
//        NSString *parmStr = [NSString stringWithFormat:@"phone=%@&pwd=%@",_account.text, _password.text];
//        //将字符串转换为NSData对象
//        NSData *data = [parmStr dataUsingEncoding:NSUTF8StringEncoding];
//        [request setHTTPBody:data];
//        [request setHTTPMethod:@"POST"];
//        
//        //创建异步连接（形式二）
//        [NSURLConnection connectionWithRequest:request delegate:self];
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //创建信号量
        NSURL *url = [NSURL URLWithString:@"http://nowprinter.com/login"];
        
        //2.构造Request
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        //(1)设置为POST请求
        [request setHTTPMethod:@"POST"];
        
        //(2)超时
        [request setTimeoutInterval:60];
        
        //(3)设置请求头
        //[request setAllHTTPHeaderFields:nil];
        
        //(4)设置请求体
        NSString *bodyStr = [NSString stringWithFormat:@"phone=%@&pwd=%@",_account.text, _password.text];
        NSData *bodyData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
        
        //设置请求体
        [request setHTTPBody:bodyData];
        
        //3.构造Session
        NSURLSession *session = [NSURLSession sharedSession];
        
        //4.task
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"dict:%@",dict);
            dispatch_semaphore_signal(semaphore);   //发送信号
        }];
        
        [task resume];
        dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待  
        NSLog(@"数据加载完成！");
    
    }
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

- (IBAction)password:(id)sender {
}
@end
