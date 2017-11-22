//
//  School+CoreDataProperties.h
//  CoreDataTest
//
//  Created by MXTH on 2017/11/17.
//  Copyright © 2017年 Hannah. All rights reserved.
//
//

#import "School+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface School (CoreDataProperties)

+ (NSFetchRequest<School *> *)fetchRequest;

@property (nonatomic) int64_t historyYear;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<ClassAndGrade *> *classAndGrade;
@property (nullable, nonatomic, retain) NSSet<Student *> *student;
@property (nullable, nonatomic, retain) NSSet<Teacher *> *teacher;

@end

@interface School (CoreDataGeneratedAccessors)

- (void)addClassAndGradeObject:(ClassAndGrade *)value;
- (void)removeClassAndGradeObject:(ClassAndGrade *)value;
- (void)addClassAndGrade:(NSSet<ClassAndGrade *> *)values;
- (void)removeClassAndGrade:(NSSet<ClassAndGrade *> *)values;

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
