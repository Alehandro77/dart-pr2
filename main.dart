import 'dart:io';
import 'dart:collection';

void main() {
  final List<String> students = [
    'Карапетян Ара',
    'Рындухов Глеб',
    'Сивцов Илья',
    'Тупицын Сергей',
    'Москаленко Максим'
  ];

  final List<String> subjects = [
    'Математика',
    'Физика',
    'Программирование',
    'История',
    'Английский язык'
  ];

  final Map<String, Map<String, int>> grades = {
    'Карапетян Ара': {
      'Математика': 5,
      'Физика': 4,
      'Программирование': 5,
      'История': 3,
      'Английский язык': 4
    },
    'Рындухов Глеб': {
      'Математика': 5,
      'Физика': 5,
      'Программирование': 5,
      'История': 5,
      'Английский язык': 5
    },
    'Сивцов Илья': {
      'Математика': 3,
      'Физика': 3,
      'Программирование': 4,
      'История': 3,
      'Английский язык': 2
    },
    'Тупицын Сергей': {
      'Математика': 4,
      'Физика': 4,
      'Программирование': 4,
      'История': 5,
      'Английский язык': 4
    },
    'Москаленко Максим': {
      'Математика': 2,
      'Физика': 3,
      'Программирование': 3,
      'История': 3,
      'Английский язык': 3
    }
  };
  
  while (true) {

    print('\nВведите что вывести: \n' +
    '1. Категории студентов по среднему баллу \n' +
    '2. Статистика оценок в журнале \n' + 
    '3. Студенты получившие 5 по предмету \n' + 
    '4. Предметы без 2 \n' + 
    '5. Предмет с наибольшим количеством двоек \n' + 
    '6. Студенты с наибольшим количеством пятёрок \n' + 
    '7. Предметы с оценкой ниже 4 для каждого студента \n' +
    '8. Пары студент - предмет с оценкой 5');

    int choice = int.parse(stdin.readLineSync()!);

    switch (choice) {
      case 1: categorizeStudentsByAverage(students, grades);
      case 2: countGrades(grades);
      case 3: studentsWithFivesBySubject(subjects, grades);
      case 4: subjectsWithoutTwos(subjects, grades);
      case 5: subjectWithMostTwos(students, grades);
      case 6: studentsWithMostFives(students, grades);
      case 7: subjectsBelowFour(students, subjects, grades);
      case 8: allFivePairs(students, subjects, grades);
    }
  }
}

// 1
void categorizeStudentsByAverage(List<String> students, Map<String, Map<String, int>> grades) {
  final List<String> otlich = [];
  final List<String> good = [];
  final List<String> others = [];
  
  for (var student in students) {
    if (!grades.containsKey(student)) continue;
    
    double average = calculateAverage(grades[student]!);
    
    if (average >= 4.5) {
      otlich.add('$student (${average.toStringAsFixed(2)})');
    } else if (average >= 3.5) {
      good.add('$student (${average.toStringAsFixed(2)})');
    } else {
      others.add('$student (${average.toStringAsFixed(2)})');
    }
  }
  
  print('Отличники:');
  otlich.isEmpty ? print('  Нет отличников') : otlich.forEach((student) => print('$student'));
      
  print('\nХорошисты:');
  good.isEmpty ? print('  Нет хорошистов') : good.forEach((student) => print('$student'));
      
  print('\nОстальные:');
  others.isEmpty ? print('  Нет студентов в этой категории') : others.forEach((student) => print('$student'));
}

double calculateAverage(Map<String, int> studentGrades) {
  if (studentGrades.isEmpty) {
    return 0.0;
  }
  
  int sum = studentGrades.values.reduce((a, b) => a + b);
  return sum / studentGrades.length;
}

// 2
void countGrades(Map<String, Map<String, int>> grades) {
  final Map<int, int> gradeCount = {2: 0, 3: 0, 4: 0, 5: 0};
  
  grades.forEach((student, subjects) {
    subjects.forEach((subject, grade) {
      gradeCount[grade] = (gradeCount[grade] ?? 0) + 1;
    });
  });
  
  gradeCount.forEach((grade, count) {
    print('Оценка $grade: $count раз(а)');
  });
}

// 3
void studentsWithFivesBySubject(List<String> subjects, Map<String, Map<String, int>> grades) {
  for (var subject in subjects) {
    List<String> studentsWithFive = [];
    
    grades.forEach((student, studentGrades) {
      if (studentGrades.containsKey(subject) && studentGrades[subject] == 5) {
        studentsWithFive.add(student);
      }
    });
    
    print('$subject:');
    studentsWithFive.isEmpty ? print('  Нет студентов с оценкой 5') : studentsWithFive.forEach((s) => print('$s'));
  }
}

// 4
void subjectsWithoutTwos(List<String> subjects, Map<String, Map<String, int>> grades) {
  final List<String> withoutTwos = [];
  
  for (var subject in subjects) {
    bool hasTwo = false;
    
    for (var studentGrades in grades.values) {
      if (studentGrades.containsKey(subject) && studentGrades[subject] == 2) {
        hasTwo = true;
        break;
      }
    }
    
    if (!hasTwo) {
      withoutTwos.add(subject);
    }
  }
  
  withoutTwos.isEmpty ? print('Нет предметов без двоек') : withoutTwos.forEach((s) => print('$s'));
}

// 5
void subjectWithMostTwos(List<String> subjects, Map<String, Map<String, int>> grades) {
  final Map<String, int> twoCounts = {};
  
  for (var subject in subjects) {
    twoCounts[subject] = 0;
  }
  
  grades.forEach((student, studentGrades) {
    studentGrades.forEach((subject, grade) {
      if (grade == 2) {
        twoCounts[subject] = (twoCounts[subject] ?? 0) + 1;
      }
    });
  });
  
  int maxTwos = 0;
  twoCounts.forEach((subject, count) {
    if (count > maxTwos) {
      maxTwos = count;
    }
  });
  
  if (maxTwos == 0) {
    print('Двоек нет ни по одному предмету');
    return;
  }
  
  print('Предмет с наибольшим количеством двоек ($maxTwos шт):');
  twoCounts.forEach((subject, count) {
    if (count == maxTwos) {
      print('$subject');
    }
  });
}

// 6
void studentsWithMostFives(List<String> students, Map<String, Map<String, int>> grades) {
  final Map<String, int> fiveCounts = {};
  
  for (var student in students) {
    
    int count = 0;
    grades[student]!.forEach((subject, grade) {
      if (grade == 5) count++;
    });
    fiveCounts[student] = count;
  }
  
  int maxFives = 0;
  fiveCounts.forEach((student, count) {
    if (count > maxFives) {
      maxFives = count;
    }
  });
  
  if (maxFives == 0) {
    print('Нет студентов с пятерками');
    return;
  }
  
  print('Студент с наибольшим количеством пятерок ($maxFives шт):');
  fiveCounts.forEach((student, count) {
    if (count == maxFives) {
      print('$student');
    }
  });
}

// 7
void subjectsBelowFour(List<String> students, List<String> subjects, Map<String, Map<String, int>> grades) {
  for (var student in students) {
    
    final List<String> lowGradeSubjects = [];
    
    grades[student]!.forEach((subject, grade) {
      if (grade < 4) {
        lowGradeSubjects.add('$subject Балл - $grade');
      }
    });
    
    print('$student:');
    if (lowGradeSubjects.isEmpty) {
      print('Нет предметов с оценкой ниже 4');
    } else {
      print('Количество: ${lowGradeSubjects.length}');
      print('Предметы: ${lowGradeSubjects.join(', ')}');
    }
  }
}

// 8
void allFivePairs(List<String> students, List<String> subjects, Map<String, Map<String, int>> grades) {
  bool hasFives = false;
  
  for (var student in students) {
    
    grades[student]!.forEach((subject, grade) {
      if (grade == 5) {
        print('$student — $subject');
        hasFives = true;
      }
    });
  }
  
  if (!hasFives) {
    print('Нет пар с оценкой 5');
  }
}
