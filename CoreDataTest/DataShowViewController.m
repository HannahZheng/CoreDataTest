//
//  DataShowViewController.m
//  CoreDataTest
//
//  Created by MXTH on 2017/11/17.
//  Copyright © 2017年 Hannah. All rights reserved.
//

#import "DataShowViewController.h"
#import <CoreData/CoreData.h>
#import "School+CoreDataClass.h"
#import "Student+CoreDataClass.h"
#import "Teacher+CoreDataClass.h"
#import "ClassAndGrade+CoreDataClass.h"
#import "StudentCell.h"

#import "StudentCell.h"

@interface DataShowViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;

@property (nonatomic, copy) NSArray *dataArr;

@end

@implementation DataShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.mainTable.dataSource = self;
//    self.mainTable.delegate = self;
    
//    [self.mainTable registerNib: [UINib nibWithNibName:@"StudentCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.mainTable registerClass:[StudentCell class] forCellReuseIdentifier:@"cell"];
//
    self.mainTable.rowHeight = 130;
    
    [self getData];
    
}

//数据查询
- (void)getData{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"School"];
    
    NSError *error = nil;
    NSArray<School *> *schoolData = [self.context executeFetchRequest:request error:&error];
   __block NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
    [schoolData enumerateObjectsUsingBlock:^(School * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSSortDescriptor *descp = [[NSSortDescriptor alloc] initWithKey:@"studentId" ascending:YES];
        NSArray *descpArr = [NSArray arrayWithObject:descp];
        NSArray *sortArr = [obj.student sortedArrayUsingDescriptors:descpArr];
        [tempArr addObjectsFromArray:sortArr];
        self.dataArr = [NSArray arrayWithArray:tempArr];
        [self.mainTable reloadData];
        
       
    }];
    
}
- (IBAction)goBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark load lazy
- (NSManagedObjectContext *)context{
    if (_context == nil) {
        //创建上下文修辞昂，并发队列设置为主队列
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];//NSPrivateQueueConcurrencyType
        
        //创建托管对象模型，并使用 CoreDataTest.momd路径作为初始化参数
        NSURL *modelPath = [[NSBundle mainBundle] URLForResource:@"CoreDataTest" withExtension:@"momd"];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelPath];
        
        //创建持久化存储调度器
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        //创建并关联SQLite数据库文件
        NSString *dataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        dataPath = [dataPath stringByAppendingString:@"/CoreDataTest.sqlite"];
        //返回一个NSPersistentStore对象，该对象负责具体持久化存储的实现
        [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dataPath] options:nil error:nil];
        
        context.persistentStoreCoordinator = coordinator;
        
        _context = context;
    }
    return _context;
}

#pragma mark tableViewDataSource and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StudentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath] ;

    cell.studentModel = self.dataArr[indexPath.row];
    return cell;
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
