//
//  ViewController.m
//  CoreDataTest
//
//  Created by MXTH on 2017/11/7.
//  Copyright © 2017年 Hannah. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>

#import "School+CoreDataProperties.h"
#import "Student+CoreDataProperties.h"
#import "Teacher+CoreDataProperties.h"
#import "ClassAndGrade+CoreDataProperties.h"

#import "StudentCell.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, nullable, strong) NSFetchedResultsController *fetchedResultC;

@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (nonatomic, copy) NSArray *dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.mainTable registerClass:[StudentCell class] forCellReuseIdentifier:@"cell"];
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


- (IBAction)addData:(UIButton *)sender {
   //创建托管对象，并指明创建的托管对象所属实体名
    School *school = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([School class]) inManagedObjectContext:self.context];
    school.name = @"实验小学";
    
    
    ClassAndGrade *grade = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ClassAndGrade class])  inManagedObjectContext:self.context];
    grade.grade = @"五年级";
    grade.name = @"二班";
    grade.school = school;
    
    
    Teacher *teacher = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Teacher class]) inManagedObjectContext:self.context];
    teacher.name = @"阿花老师";
    teacher.age = 25;
    teacher.teachYear = 1;
    teacher.school = school;
    teacher.classAndGrade = grade;
    teacher.teacherId = @"050201";
    
    Teacher *teacher2 = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Teacher class]) inManagedObjectContext:self.context];
    teacher2.name = @"test老师";
    teacher2.age = 30;
    teacher2.teachYear = 5;
    teacher2.school = school;
    teacher2.classAndGrade = grade;
    teacher2.teacherId = @"050202";
    
    for (int i = 0; i < 5; i++) {
        Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.context];
        student.name = [NSString stringWithFormat:@"%@ 's %d",teacher.name, i];
        student.age = 10+i%2;
        student.sex = i%2 == 1;
        student.classAndGrade = grade;
        student.teacher = teacher;
        student.school = teacher.school;
        student.schoolYear = 5;
        student.studentId = [NSString stringWithFormat:@"20110502%4d",i];
        
        Student *student2 = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.context];
        student2.name = [NSString stringWithFormat:@"%@ 's %d",teacher2.name, i];
        student2.age = 15+i%2;
        student2.sex = i%2 == 1;
        student2.classAndGrade = grade;
        student2.school = teacher2.school;
        student2.schoolYear = 5;
        student2.studentId = [NSString stringWithFormat:@"201105021%3d",i];
        [teacher2 addStudentObject:student2];
    }
    
   
   
    
    //通过上下文保存对象，并在保存前判断是否有更改
    NSError *error = nil;
    if (self.context.hasChanges) {
        [self.context save:&error];
    }
    if (error) {
         NSLog(@"CoreData Insert Data Error : %@", error);
    }
    
    
}


- (IBAction)getAllData:(id)sender {
    //NSFetchedResultsController使用
    
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

- (IBAction)deleteData:(id)sender {
    //建立获取数据的请求对象，指明对哪一实体进行删除操作
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"School"];
    
//    //创建谓词对象，过滤出符合要求的对象，也就是要删除的对象
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",@"lxz"];
//    request.predicate = predicate;
    
    //执行获取操作，找到要删除的对象
    NSError *error = nil;
   NSArray<School *> *tempArr =  [self.context executeFetchRequest:request error:&error];
    
    
    
    [tempArr enumerateObjectsUsingBlock:^(School * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.context deleteObject:obj];
    }];
    
    // 保存上下文
    if ([self.context hasChanges]) {
        [self.context save:nil];
    }
    
    // 错误处理
    if (error) {
        NSLog(@"CoreData Delete Data Error : %@", error);
    }
}


- (IBAction)changeData:(id)sender {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Teacher"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"teacherId = %@",@"050202"];
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray<Teacher *> *tempArr = [self.context executeFetchRequest:request error:&error];
    [tempArr enumerateObjectsUsingBlock:^(Teacher * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.name = @"二货老师";
    }];
    
    if ([self.context hasChanges]) {
        [self.context save:nil];
    }
    
    if (error) {
         NSLog(@"CoreData Update Data Error : %@", error);
    }
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

- (NSFetchedResultsController *)fetchedResultC{
    if (_fetchedResultC == nil) {
        //创建请求对象，并指明操作的表
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"School"];
        //设置排序规则
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"student.studentId" ascending:YES];
        request.sortDescriptors = @[descriptor];
        
        //创建NSFetchedResultsController控制器实例，并绑定MOC
        NSError *error = nil;
        _fetchedResultC = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:@"teacher.name" cacheName:nil];
        _fetchedResultC.delegate = self;
        //执行获取请求，执行后FRC会从持久化存储区加载数据，其他地方可以通过FRC获取数据
        [_fetchedResultC performFetch:&error];
        if (error) {
             NSLog(@"NSFetchedResultsController init error : %@", error);
        }
    }
    return _fetchedResultC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
