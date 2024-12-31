
CREATE DATABASE IF NOT EXISTS Quiz;
USE Quiz;


-- Users Table
CREATE TABLE Users (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  role ENUM('student', 'teacher') NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Quizzes Table
CREATE TABLE Quizzes (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  teacher_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (teacher_id) REFERENCES Users(id)
);

-- Questions Table
CREATE TABLE Questions (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  quiz_id INT UNSIGNED NOT NULL,
  text TEXT NOT NULL,
  FOREIGN KEY (quiz_id) REFERENCES Quizzes(id)
);

-- Options Table
CREATE TABLE Options (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  question_id INT UNSIGNED NOT NULL,
  text TEXT NOT NULL,
  is_correct BOOLEAN NOT NULL,
  FOREIGN KEY (question_id) REFERENCES Questions(id)
);

-- Student_Answers Table
CREATE TABLE Student_Answers (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  student_id INT UNSIGNED NOT NULL,
  quiz_id INT UNSIGNED NOT NULL,
  question_id INT UNSIGNED NOT NULL,
  option_id INT UNSIGNED DEFAULT NULL,  -- Allow for open ended questions
  FOREIGN KEY (student_id) REFERENCES Users(id),
  FOREIGN KEY (quiz_id) REFERENCES Quizzes(id),
  FOREIGN KEY (question_id) REFERENCES Questions(id),
  FOREIGN KEY (option_id) REFERENCES Options(id)
);


-- Insert sample data into Users table
INSERT INTO Users (name, role) VALUES
    ('MD rahim', 'teacher'),
    ('MD rahaman', 'teacher'),
    ('Tanvir', 'student'),
    ('Sadman', 'student');
    
-- Insert sample data into Quizzes table
INSERT INTO Quizzes (title, teacher_id) VALUES
    ('History Quiz 1', 1),
    ('Math Quiz', 2);
    
-- Insert sample data into Questions table
INSERT INTO Questions (quiz_id, text) VALUES
    (1, 'Who was the first president of the United States?'),
    (1, 'When did World War II begin?'),
    (2, 'What is the square root of 144?'),
    (2, 'Solve for x: 2x + 5 = 11');

-- Insert sample data into Options table
INSERT INTO Options (question_id, text, is_correct) VALUES
    (1, 'George Washington', 1),
    (1, 'Thomas Jefferson', 0),
    (1, 'Abraham Lincoln', 0),
    (2, '1914', 0),
    (2, '1939', 1),
    (2, '1945', 0),
    (3, '10', 1),
    (3, '12', 0),
    (3, '14', 0),
    (4, '2', 1),
    (4, '3', 0),
    (4, '4', 0);
    
    
-- Insert sample data into Student_Answers table
INSERT INTO Student_Answers (student_id, quiz_id, question_id, option_id) VALUES
    (3, 1, 1, 1),  
    (3, 1, 2, 2),  
    (4, 2, 3, 1),  
    (4, 2, 4, 2);  
    
    
-- View all questions and their correct answers:    
SELECT
    q.text AS Question,
    GROUP_CONCAT(IF(o.is_correct, o.text, NULL)) AS Correct_Answer
FROM
    Questions q
JOIN
    Options o ON q.id = o.question_id
GROUP BY
    q.id;
    
    
-- View student answers for a specific quiz:
SELECT
    u.name AS Student,
    q.text AS Question,
    o.text AS Student_Answer,
    CASE
        WHEN o.is_correct THEN 'Correct'
        ELSE 'Incorrect'
    END AS Result
FROM
    Student_Answers sa
JOIN
    Users u ON sa.student_id = u.id
JOIN
    Questions q ON sa.question_id = q.id
JOIN
    Options o ON sa.option_id = o.id
WHERE
    sa.quiz_id = 1;  -- Replace  quiz ID
    
    
