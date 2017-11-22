//
//  ClassAndGrade+CoreDataProperties.h
//  CoreDataTest
//
//  Created by MXTH on 2017/11/17.
//  Copyright © 2017年 Hannah. All rights reserved.
//
//

#import "ClassAndGrade+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ClassAndGrade (CoreDataProperties)

+ (NSFetchRequest<ClassAndGrade *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *grade;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) School *school;
@property (nullable, nonatomic, retain) NSSet<Student *> *student;
@property (nullable, nonatomic, retain) NSSet<Teacher *> *teacher;

@end

@interface ClassAndGrade (CoreDataGeneratedAccessors)

- (void)addStudentObject:(Student *)value;
- (void)removeStudentObject:(Student *)value;
- (void)addStudent:(NSSet<Student *> *)values;
- (void)removeStudent:(NSSet<Student *> *)values;

- (void)addTeacherObject:(Teacher *)value;
- (void)removeTeacherObject:(Teacher *)value;
- (void)addTeacher:(NSSet<Teacher *> *)values;
- (void)removeTeacher:(NSSet<Teacher *> *)values;

@end

NS_ASSUME_NONNULL_END
