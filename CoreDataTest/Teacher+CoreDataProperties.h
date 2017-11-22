//
//  Teacher+CoreDataProperties.h
//  CoreDataTest
//
//  Created by MXTH on 2017/11/17.
//  Copyright © 2017年 Hannah. All rights reserved.
//
//

#import "Teacher+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Teacher (CoreDataProperties)

+ (NSFetchRequest<Teacher *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *subject;
@property (nonatomic) int16_t teachYear;
@property (nullable, nonatomic, copy) NSString *teacherId;
@property (nullable, nonatomic, retain) ClassAndGrade *classAndGrade;
@property (nullable, nonatomic, retain) School *school;
@property (nullable, nonatomic, retain) NSSet<Student *> *student;

@end

@interface Teacher (CoreDataGeneratedAccessors)

- (void)addStudentObject:(Student *)value;
- (void)removeStudentObject:(Student *)value;
- (void)addStudent:(NSSet<Student *> *)values;
- (void)removeStudent:(NSSet<Student *> *)values;

@end

NS_ASSUME_NONNULL_END
