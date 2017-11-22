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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.fetchedResultC.sections.count;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fetchedResultC.sections[section].numberOfObjects;
    
//    School *schoolModel = [self.fetchedResultC.fetchedObjects objectAtIndex:section];
//    return schoolModel.student.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StudentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath] ;
//    School *schoolModel = [self.fetchedResultC.fetchedObjects objectAtIndex:indexPath.section];
    cell.studentModel = [self.fetchedResultC objectAtIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

/*
 在删除cell后在tableView代理方法的回调中，调用了MOC的删除方法，使本地持久化存储和UI保持同步，并回调到下面的FRC代理方法中，在代理方法中对UI做删除操作，这样一套由UI的改变引发的删除流程就完成了。
 */

//简单模拟 UI删除cell后，本地持久化区数据和UI同步的操作。在调用下面MOC保存上下文方法后，FRC会回调代理方法并更新UI
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Student *tempModel = [self.fetchedResultC objectAtIndexPath:indexPath];
        [self.context deleteObject:tempModel];
        NSError *error = nil;
        if (![self.context save:&error]) {
             NSLog(@"tableView delete cell error : %@", error);
        }
    }
}


#pragma mark fetched results controller delegate
//cell数据源发生改变会回调此方法
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    switch (type) {
        case NSFetchedResultsChangeInsert:
        {
            [self.mainTable insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            
            break;
           
        case NSFetchedResultsChangeDelete:
        {
            [self.mainTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
            
        case NSFetchedResultsChangeMove:
        {
            
            [self.mainTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.mainTable insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
            
        case NSFetchedResultsChangeUpdate:
        {
            StudentCell *cell = [self.mainTable cellForRowAtIndexPath:indexPath];
            Student *tempModel = [self.fetchedResultC objectAtIndexPath:indexPath];
            cell.studentModel = tempModel;
        }
            break;
            
            
            
        default:
            break;
    }
}

//section的数据源发生改变 回调该方法
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.mainTable insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        default:
            break;
    }
}

//本地数据源发生改变，将要开始回调FRC代理方法
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    if (@available(iOS 11.0, *)) {
        [self.mainTable performBatchUpdates:^{
            
        } completion:^(BOOL finished) {
            
        }];
    } else {
        // Fallback on earlier versions
        
        [self.mainTable beginUpdates];
    }
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.mainTable endUpdates];
}

// 返回section的title，可以在这里对title做进一步处理。这里修改title后，对应section的indexTitle属性会被更新。
- (nullable NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName{
    return sectionName;
}

#pragma mark event
- (IBAction)addData:(UIButton *)sender {
   //创建托管对象，并指明创建的托管对象所属实体名
    School *school = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([School class]) inManagedObjectContext:self.context];
    school.name = @"实验小学";
    school.historyYear = 50;
    
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
    
    //执行获取请求，执行后FRC会从持久化存储区加载数据，其他地方可以通过FRC获取数据
    //调用performFetch:方法第一次获取到数据并不会回调FRC代理方法。
    NSError *error = nil;
    [self.fetchedResultC performFetch:&error];
    if (error) {
        NSLog(@"NSFetchedResultsController init error : %@", error);
    }
    [self.mainTable reloadData];
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
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
        //设置排序规则
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"studentId" ascending:YES];
        request.sortDescriptors = @[descriptor];

        //创建NSFetchedResultsController控制器实例，并绑定MOC
        
        _fetchedResultC = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];//@"teacher.name"
        _fetchedResultC.delegate = self;
        
    }
    return _fetchedResultC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
