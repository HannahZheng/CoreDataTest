//
//  StudentCell.h
//  CoreDataTest
//
//  Created by MXTH on 2017/11/13.
//  Copyright © 2017年 Hannah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student+CoreDataClass.h"

@interface StudentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *age;

@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *studentId;
@property (weak, nonatomic) IBOutlet UILabel *schoolYear;
@property (weak, nonatomic) IBOutlet UILabel *teacher;

@property (weak, nonatomic) IBOutlet UILabel *gradeAndClass;
@property (weak, nonatomic) IBOutlet UILabel *school;


@property (nonatomic, strong) Student *studentModel;


@end
