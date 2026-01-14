-- Assignment 1: Sample Data (PROVIDED - DO NOT MODIFY)
-- CS3550 - Advanced Database Systems
-- Database: MySQL 8.0

-- =============================================================================
-- COMMUNITY COLLEGE MANAGEMENT SYSTEM - SAMPLE DATA
-- =============================================================================
-- 
-- ⚠️ THIS FILE IS PROVIDED FOR YOU - DO NOT MODIFY
-- 
-- This file populates the database with realistic sample data for a
-- community college management system. You will query this data in
-- your assignment tasks.
-- 
-- =============================================================================

-- Ensure we're using the correct database
USE community_college_db;

-- Disable foreign key checks temporarily for data loading
SET FOREIGN_KEY_CHECKS = 0;

-- Clear existing data in proper order
DELETE FROM Enrollments;
DELETE FROM Course_Sections;
DELETE FROM Course_Prerequisites;
DELETE FROM Courses;
DELETE FROM Student_Programs;
DELETE FROM Programs;
DELETE FROM Faculty;
DELETE FROM Students;
DELETE FROM Departments;

-- Reset auto-increment counters
ALTER TABLE Faculty AUTO_INCREMENT = 1;
ALTER TABLE Students AUTO_INCREMENT = 1;
ALTER TABLE Programs AUTO_INCREMENT = 1;
ALTER TABLE Course_Sections AUTO_INCREMENT = 1;
ALTER TABLE Enrollments AUTO_INCREMENT = 1;

-- =============================================================================
-- DEPARTMENTS DATA
-- =============================================================================

INSERT INTO Departments (dept_id, dept_name, building, room_number, phone, email, budget) VALUES
('CS', 'Computer Science', 'Science Building', '201', '555-0101', 'cs@mountainview.edu', 750000.00),
('MATH', 'Mathematics', 'Science Building', '301', '555-0102', 'math@mountainview.edu', 450000.00),
('ENG', 'English', 'Liberal Arts', '101', '555-0103', 'english@mountainview.edu', 320000.00),
('BUS', 'Business', 'Business Center', '200', '555-0104', 'business@mountainview.edu', 580000.00),
('HIST', 'History', 'Liberal Arts', '205', '555-0105', 'history@mountainview.edu', 280000.00);

-- =============================================================================
-- FACULTY DATA
-- =============================================================================

INSERT INTO Faculty (employee_id, dept_id, first_name, last_name, email, phone, office_building, office_room, hire_date, employment_status, salary) VALUES
-- Computer Science Faculty (3 members)
('EMP001', 'CS', 'Sarah', 'Johnson', 'sjohnson@mountainview.edu', '555-1001', 'Science Building', '202', '2018-08-15', 'full-time', 85000.00),
('EMP002', 'CS', 'Michael', 'Chen', 'mchen@mountainview.edu', '555-1002', 'Science Building', '203', '2020-01-10', 'full-time', 78000.00),
('EMP003', 'CS', 'Lisa', 'Rodriguez', 'lrodriguez@mountainview.edu', '555-1003', 'Science Building', '204', '2019-08-20', 'full-time', 82000.00),

-- Mathematics Faculty (2 members)
('EMP004', 'MATH', 'Robert', 'Smith', 'rsmith@mountainview.edu', '555-1004', 'Science Building', '302', '2015-09-01', 'full-time', 72000.00),
('EMP005', 'MATH', 'Emily', 'Davis', 'edavis@mountainview.edu', '555-1005', 'Science Building', '303', '2021-01-15', 'full-time', 68000.00),

-- English Faculty (2 members)
('EMP006', 'ENG', 'James', 'Wilson', 'jwilson@mountainview.edu', '555-1006', 'Liberal Arts', '102', '2016-08-25', 'full-time', 65000.00),
('EMP007', 'ENG', 'Maria', 'Garcia', 'mgarcia@mountainview.edu', '555-1007', 'Liberal Arts', '103', '2022-01-10', 'full-time', 62000.00),

-- Business Faculty (2 members)
('EMP008', 'BUS', 'David', 'Brown', 'dbrown@mountainview.edu', '555-1008', 'Business Center', '201', '2017-09-05', 'full-time', 88000.00),
('EMP009', 'BUS', 'Jennifer', 'Taylor', 'jtaylor@mountainview.edu', '555-1009', 'Business Center', '202', '2020-08-15', 'full-time', 84000.00),

-- History Faculty (1 member)
('EMP010', 'HIST', 'Christopher', 'Martinez', 'cmartinez@mountainview.edu', '555-1010', 'Liberal Arts', '206', '2019-01-20', 'full-time', 66000.00),

-- Additional adjunct faculty for variety
('EMP011', 'CS', 'Amanda', 'Lee', 'alee@mountainview.edu', '555-1011', 'Science Building', '205', '2023-01-15', 'adjunct', 45000.00),
('EMP012', 'MATH', 'Thomas', 'Anderson', 'tanderson@mountainview.edu', '555-1012', 'Science Building', '304', '2022-08-20', 'part-time', 35000.00);

-- Update department heads
UPDATE Departments SET dept_head_id = 1 WHERE dept_id = 'CS';    -- Sarah Johnson
UPDATE Departments SET dept_head_id = 4 WHERE dept_id = 'MATH';  -- Robert Smith
UPDATE Departments SET dept_head_id = 6 WHERE dept_id = 'ENG';   -- James Wilson
UPDATE Departments SET dept_head_id = 8 WHERE dept_id = 'BUS';   -- David Brown
UPDATE Departments SET dept_head_id = 10 WHERE dept_id = 'HIST'; -- Christopher Martinez

-- =============================================================================
-- PROGRAMS DATA
-- =============================================================================

INSERT INTO Programs (program_code, program_name, dept_id, degree_type, credit_hours_required, description, min_gpa_required) VALUES
('CSAS', 'Computer Science', 'CS', 'associate', 60, 'Associate of Science in Computer Science focusing on programming, algorithms, and system fundamentals', 2.00),
('CSBS', 'Computer Science', 'CS', 'bachelor', 120, 'Bachelor of Science in Computer Science with advanced topics in software engineering and system design', 2.50),
('MATHBS', 'Mathematics', 'MATH', 'bachelor', 120, 'Bachelor of Science in Mathematics with emphasis on pure and applied mathematics', 2.25),
('BUSAS', 'Business Administration', 'BUS', 'associate', 64, 'Associate of Science in Business Administration covering management, finance, and marketing basics', 2.00),
('BUSBS', 'Business Administration', 'BUS', 'bachelor', 128, 'Bachelor of Science in Business Administration with concentrations in management or finance', 2.50);

-- =============================================================================
-- STUDENTS DATA
-- =============================================================================

INSERT INTO Students (student_number, first_name, last_name, email, phone, address_line1, city, state, zip_code, date_of_birth, enrollment_date, academic_standing, gpa, total_credits) VALUES
-- Computer Science Students
('STU001', 'John', 'Doe', 'jdoe@student.mountainview.edu', '555-2001', '123 Main St', 'Mountain View', 'CA', '94041', '2003-05-15', '2022-09-01', 'good', 3.45, 32),
('STU002', 'Jane', 'Smith', 'jsmith@student.mountainview.edu', '555-2002', '456 Oak Ave', 'Mountain View', 'CA', '94041', '2002-11-20', '2021-09-01', 'excellent', 3.89, 58),
('STU003', 'Carlos', 'Mendoza', 'cmendoza@student.mountainview.edu', '555-2003', '789 Pine St', 'Palo Alto', 'CA', '94301', '2004-02-10', '2023-01-15', 'good', 3.22, 18),
('STU004', 'Amanda', 'White', 'awhite@student.mountainview.edu', '555-2004', '321 Elm St', 'Mountain View', 'CA', '94041', '2001-08-30', '2020-09-01', 'excellent', 3.92, 89),

-- Mathematics Students  
('STU005', 'Kevin', 'Lee', 'klee@student.mountainview.edu', '555-2005', '654 Maple Dr', 'Sunnyvale', 'CA', '94085', '2003-12-05', '2022-09-01', 'good', 3.67, 45),
('STU006', 'Rachel', 'Johnson', 'rjohnson@student.mountainview.edu', '555-2006', '987 Cedar Ln', 'Mountain View', 'CA', '94043', '2002-04-18', '2021-09-01', 'good', 3.78, 52),

-- Business Students
('STU007', 'Marcus', 'Williams', 'mwilliams@student.mountainview.edu', '555-2007', '147 Birch Ave', 'Los Altos', 'CA', '94022', '2004-07-22', '2023-09-01', 'good', 3.12, 15),
('STU008', 'Elena', 'Gonzalez', 'egonzalez@student.mountainview.edu', '555-2008', '258 Spruce St', 'Mountain View', 'CA', '94041', '2003-09-14', '2022-01-15', 'probation', 2.45, 28),

-- High performing students
('STU009', 'Thomas', 'Anderson', 'tanderson@student.mountainview.edu', '555-2009', '369 Willow Way', 'Cupertino', 'CA', '95014', '2001-06-03', '2020-09-01', 'excellent', 3.96, 85),
('STU010', 'Sophie', 'Chen', 'schen@student.mountainview.edu', '555-2010', '741 Redwood Rd', 'Mountain View', 'CA', '94041', '2004-01-28', '2023-09-01', 'good', 3.88, 12),

-- Additional diverse students
('STU011', 'Daniel', 'Kim', 'dkim@student.mountainview.edu', '555-2011', '852 Ash St', 'Palo Alto', 'CA', '94301', '2002-03-12', '2021-01-15', 'good', 3.34, 62),
('STU012', 'Isabella', 'Lopez', 'ilopez@student.mountainview.edu', '555-2012', '963 Poplar Ave', 'Mountain View', 'CA', '94043', '2003-10-07', '2022-09-01', 'good', 3.61, 41),
('STU013', 'Alex', 'Thompson', 'athompson@student.mountainview.edu', '555-2013', '159 Hickory Dr', 'Sunnyvale', 'CA', '94085', '2004-05-25', '2023-01-15', 'good', 3.03, 22),
('STU014', 'Maya', 'Patel', 'mpatel@student.mountainview.edu', '555-2014', '357 Walnut Ln', 'Los Altos', 'CA', '94022', '2001-12-16', '2020-09-01', 'excellent', 3.87, 95),
('STU015', 'Jacob', 'Miller', 'jmiller@student.mountainview.edu', '555-2015', '468 Cherry St', 'Mountain View', 'CA', '94041', '2003-07-09', '2022-01-15', 'probation', 2.78, 25),
('STU016', 'Olivia', 'Davis', 'odavis@student.mountainview.edu', '555-2016', '579 Beech Ave', 'Cupertino', 'CA', '95014', '2002-08-31', '2021-09-01', 'good', 3.52, 48),
('STU017', 'Nathan', 'Wilson', 'nwilson@student.mountainview.edu', '555-2017', '681 Sycamore Way', 'Palo Alto', 'CA', '94301', '2004-04-14', '2023-09-01', 'good', 3.76, 8),
('STU018', 'Zoe', 'Garcia', 'zgarcia@student.mountainview.edu', '555-2018', '792 Magnolia Dr', 'Mountain View', 'CA', '94043', '2001-11-29', '2020-01-15', 'excellent', 3.91, 98),
('STU019', 'Ethan', 'Martinez', 'emartinez@student.mountainview.edu', '555-2019', '143 Dogwood Ln', 'Sunnyvale', 'CA', '94085', '2003-02-21', '2022-09-01', 'good', 3.29, 35),
('STU020', 'Grace', 'Taylor', 'gtaylor@student.mountainview.edu', '555-2020', '254 Palm Ave', 'Los Altos', 'CA', '94022', '2002-09-08', '2021-01-15', 'excellent', 3.94, 67),

-- Additional students for variety in academic standing
('STU021', 'Ryan', 'Chang', 'rchang@student.mountainview.edu', '555-2021', '365 Elm Dr', 'Mountain View', 'CA', '94041', '2003-11-03', '2022-09-01', 'good', 3.15, 29),
('STU022', 'Samantha', 'Brown', 'sbrown@student.mountainview.edu', '555-2022', '476 Oak Ln', 'Cupertino', 'CA', '95014', '2004-06-17', '2023-01-15', 'probation', 2.67, 19);


-- =============================================================================
-- STUDENT PROGRAMS (MAJORS) DATA  
-- =============================================================================

INSERT INTO Student_Programs (student_id, program_id, enrollment_date, is_primary_major, status) VALUES
-- Primary majors for CS students
(1, 1, '2022-09-01', TRUE, 'active'),   -- John Doe -> CS Associate
(2, 2, '2021-09-01', TRUE, 'active'),   -- Jane Smith -> CS Bachelor  
(3, 1, '2023-01-15', TRUE, 'active'),   -- Carlos Mendoza -> CS Associate
(4, 2, '2020-09-01', TRUE, 'active'),   -- Amanda White -> CS Bachelor

-- Primary majors for Math students
(5, 3, '2022-09-01', TRUE, 'active'),   -- Kevin Lee -> Math Bachelor
(6, 3, '2021-09-01', TRUE, 'active'),   -- Rachel Johnson -> Math Bachelor

-- Primary majors for Business students
(7, 4, '2023-09-01', TRUE, 'active'),   -- Marcus Williams -> Business Associate
(8, 4, '2022-01-15', TRUE, 'active'),   -- Elena Gonzalez -> Business Associate

-- High performers in various programs
(9, 2, '2020-09-01', TRUE, 'active'),   -- Thomas Anderson -> CS Bachelor
(10, 1, '2023-09-01', TRUE, 'active'),  -- Sophie Chen -> CS Associate
(11, 3, '2021-01-15', TRUE, 'active'),  -- Daniel Kim -> Math Bachelor
(12, 5, '2022-09-01', TRUE, 'active'),  -- Isabella Lopez -> Business Bachelor
(13, 4, '2023-01-15', TRUE, 'active'),  -- Alex Thompson -> Business Associate
(14, 2, '2020-09-01', TRUE, 'active'),  -- Maya Patel -> CS Bachelor
(15, 1, '2022-01-15', TRUE, 'active'),  -- Jacob Miller -> CS Associate
(16, 3, '2021-09-01', TRUE, 'active'),  -- Olivia Davis -> Math Bachelor
(17, 4, '2023-09-01', TRUE, 'active'),  -- Nathan Wilson -> Business Associate
(18, 2, '2020-01-15', TRUE, 'active'),  -- Zoe Garcia -> CS Bachelor
(19, 5, '2022-09-01', TRUE, 'active'),  -- Ethan Martinez -> Business Bachelor
(20, 3, '2021-01-15', TRUE, 'active'),  -- Grace Taylor -> Math Bachelor
(21, 1, '2022-09-01', TRUE, 'active'),  -- Ryan Chang -> CS Associate
(22, 4, '2023-01-15', TRUE, 'active'),  -- Samantha Brown -> Business Associate

-- Double majors (secondary majors)
(4, 3, '2021-01-15', FALSE, 'active'),  -- Amanda White -> Math as second major
(2, 3, '2022-01-15', FALSE, 'active'),  -- Jane Smith -> Math as second major
(6, 5, '2022-01-15', FALSE, 'active'),  -- Rachel Johnson -> Business Bachelor as second major
(9, 5, '2021-01-15', FALSE, 'active'),  -- Thomas Anderson -> Business Bachelor as second major
(14, 3, '2021-01-15', FALSE, 'active'); -- Maya Patel -> Math as second major


-- =============================================================================
-- COURSES DATA
-- =============================================================================

INSERT INTO Courses (course_id, dept_id, course_number, course_name, course_description, credit_hours, lab_hours, lecture_hours, difficulty_level) VALUES
-- Computer Science Courses
('CS1400', 'CS', '1400', 'Introduction to Programming', 'Fundamentals of programming using Java. Problem solving, algorithms, and object-oriented programming concepts.', 4, 2, 3, 'introductory'),
('CS1410', 'CS', '1410', 'Object-Oriented Programming', 'Advanced programming concepts including inheritance, polymorphism, and data structures.', 4, 2, 3, 'introductory'),
('CS2420', 'CS', '2420', 'Data Structures and Algorithms', 'Analysis and implementation of fundamental data structures and algorithms.', 4, 2, 3, 'intermediate'),
('CS2550', 'CS', '2550', 'Database Design', 'Introduction to database concepts, SQL, normalization, and database design principles.', 3, 2, 2, 'intermediate'),
('CS3550', 'CS', '3550', 'Advanced Database Systems', 'Advanced database topics including NoSQL, optimization, and distributed systems.', 3, 2, 2, 'advanced'),
('CS3700', 'CS', '3700', 'Software Engineering', 'Software development lifecycle, project management, and team collaboration.', 3, 1, 3, 'advanced'),

-- Mathematics Courses
('MATH1050', 'MATH', '1050', 'College Algebra', 'Algebraic concepts, functions, and problem solving techniques.', 3, 0, 3, 'introductory'),
('MATH1210', 'MATH', '1210', 'Calculus I', 'Differential calculus, limits, derivatives, and applications.', 4, 0, 4, 'intermediate'),
('MATH1220', 'MATH', '1220', 'Calculus II', 'Integral calculus, sequences, series, and applications.', 4, 0, 4, 'intermediate'),
('MATH2210', 'MATH', '2210', 'Calculus III', 'Multivariable calculus, partial derivatives, and multiple integrals.', 4, 0, 4, 'advanced'),
('MATH2280', 'MATH', '2280', 'Linear Algebra', 'Vector spaces, matrices, eigenvalues, and linear transformations.', 3, 0, 3, 'intermediate'),

-- English Courses
('ENG1010', 'ENG', '1010', 'English Composition', 'Writing skills, composition techniques, and critical thinking.', 3, 0, 3, 'introductory'),
('ENG2010', 'ENG', '2010', 'Technical Writing', 'Professional and technical communication skills.', 3, 0, 3, 'intermediate'),

-- Business Courses
('BUS1050', 'BUS', '1050', 'Introduction to Business', 'Overview of business principles, ethics, and organizational behavior.', 3, 0, 3, 'introductory'),
('BUS2200', 'BUS', '2200', 'Accounting Principles', 'Fundamental accounting concepts and financial statement preparation.', 3, 0, 3, 'intermediate'),
('BUS3300', 'BUS', '3300', 'Business Finance', 'Corporate finance, investment analysis, and financial management.', 3, 0, 3, 'advanced'),

-- History Course
('HIST1700', 'HIST', '1700', 'American History', 'Survey of American history from colonial period to present.', 3, 0, 3, 'introductory');

-- =============================================================================
-- COURSE PREREQUISITES DATA
-- =============================================================================

INSERT INTO Course_Prerequisites (course_id, prerequisite_course_id, min_grade) VALUES
-- CS Prerequisites
('CS1410', 'CS1400', 'C'),        -- OOP requires Intro Programming
('CS2420', 'CS1410', 'C'),        -- Data Structures requires OOP
('CS2550', 'CS1400', 'C'),        -- Database Design requires Intro Programming
('CS3550', 'CS2550', 'C'),        -- Advanced Database requires Database Design
('CS3700', 'CS2420', 'C'),        -- Software Engineering requires Data Structures

-- Math Prerequisites
('MATH1210', 'MATH1050', 'C'),    -- Calculus I requires College Algebra
('MATH1220', 'MATH1210', 'C'),    -- Calculus II requires Calculus I
('MATH2210', 'MATH1220', 'C'),    -- Calculus III requires Calculus II
('MATH2280', 'MATH1210', 'C'),    -- Linear Algebra requires Calculus I

-- Business Prerequisites
('BUS3300', 'BUS2200', 'C'),      -- Business Finance requires Accounting Principles
('BUS2200', 'BUS1050', 'C'),      -- Accounting requires Intro to Business

-- Technical Writing Prerequisites
('ENG2010', 'ENG1010', 'C');      -- Technical Writing requires English Composition

-- =============================================================================
-- COURSE SECTIONS DATA
-- =============================================================================

INSERT INTO Course_Sections (course_id, section_number, faculty_id, semester, year, days_of_week, start_time, end_time, building, room, max_capacity) VALUES
-- Fall 2024 Sections
('CS1400', '001', 1, 'fall', 2024, 'MWF', '09:00:00', '09:50:00', 'Science Building', '101', 35),
('CS1400', '002', 2, 'fall', 2024, 'TTH', '10:30:00', '11:45:00', 'Science Building', '102', 35),
('CS1410', '001', 1, 'fall', 2024, 'MWF', '11:00:00', '11:50:00', 'Science Building', '101', 30),
('CS2420', '001', 3, 'fall', 2024, 'TTH', '14:00:00', '15:15:00', 'Science Building', '103', 25),
('CS2550', '001', 2, 'fall', 2024, 'MWF', '13:00:00', '13:50:00', 'Science Building', '102', 30),
('CS3550', '001', 1, 'fall', 2024, 'TTH', '15:30:00', '16:45:00', 'Science Building', '103', 25),

('MATH1050', '001', 4, 'fall', 2024, 'MWF', '08:00:00', '08:50:00', 'Science Building', '201', 40),
('MATH1050', '002', 5, 'fall', 2024, 'TTH', '09:00:00', '10:15:00', 'Science Building', '202', 40),
('MATH1210', '001', 4, 'fall', 2024, 'MWF', '10:00:00', '10:50:00', 'Science Building', '201', 35),
('MATH1220', '001', 5, 'fall', 2024, 'TTH', '11:30:00', '12:45:00', 'Science Building', '202', 30),

('ENG1010', '001', 6, 'fall', 2024, 'MWF', '09:00:00', '09:50:00', 'Liberal Arts', '101', 25),
('ENG1010', '002', 7, 'fall', 2024, 'TTH', '13:00:00', '14:15:00', 'Liberal Arts', '102', 25),
('ENG2010', '001', 6, 'fall', 2024, 'TTH', '10:30:00', '11:45:00', 'Liberal Arts', '101', 20),

('BUS1050', '001', 8, 'fall', 2024, 'MWF', '14:00:00', '14:50:00', 'Business Center', '101', 35),
('BUS2200', '001', 9, 'fall', 2024, 'TTH', '15:30:00', '16:45:00', 'Business Center', '102', 30),

-- Spring 2024 Sections (some completed courses)
('CS1400', '001', 1, 'spring', 2024, 'MWF', '09:00:00', '09:50:00', 'Science Building', '101', 35),
('CS1410', '001', 2, 'spring', 2024, 'TTH', '10:30:00', '11:45:00', 'Science Building', '102', 30),
('CS2420', '001', 3, 'spring', 2024, 'MWF', '11:00:00', '11:50:00', 'Science Building', '103', 25),
('CS2550', '001', 1, 'spring', 2024, 'TTH', '14:00:00', '15:15:00', 'Science Building', '101', 30),

('MATH1050', '001', 4, 'spring', 2024, 'MWF', '08:00:00', '08:50:00', 'Science Building', '201', 40),
('MATH1210', '001', 5, 'spring', 2024, 'TTH', '09:00:00', '10:15:00', 'Science Building', '202', 35),
('MATH1220', '001', 4, 'spring', 2024, 'MWF', '10:00:00', '10:50:00', 'Science Building', '201', 30),

('ENG1010', '001', 6, 'spring', 2024, 'TTH', '11:30:00', '12:45:00', 'Liberal Arts', '101', 25),
('BUS1050', '001', 8, 'spring', 2024, 'MWF', '13:00:00', '13:50:00', 'Business Center', '101', 35),

-- Additional Summer 2024 sections
('CS1400', '001', 11, 'summer', 2024, 'MTWTH', '10:00:00', '11:30:00', 'Science Building', '101', 20),
('MATH1050', '001', 12, 'summer', 2024, 'MTWTH', '08:00:00', '09:30:00', 'Science Building', '201', 25);

-- =============================================================================
-- ENROLLMENTS DATA  
-- =============================================================================

INSERT INTO Enrollments (student_id, section_id, enrollment_date, status, grade, credit_hours) VALUES
-- Fall 2024 Current Enrollments (active)
(1, 1, '2024-08-15', 'enrolled', NULL, 4),     -- John Doe in CS1400
(1, 11, '2024-08-15', 'enrolled', NULL, 3),    -- John Doe in ENG1010
(2, 6, '2024-08-15', 'enrolled', NULL, 3),     -- Jane Smith in CS3550
(2, 10, '2024-08-15', 'enrolled', NULL, 4),    -- Jane Smith in MATH1220
(3, 1, '2024-08-15', 'enrolled', NULL, 4),     -- Carlos in CS1400
(4, 6, '2024-08-15', 'enrolled', NULL, 3),     -- Amanda in CS3550
(4, 10, '2024-08-15', 'enrolled', NULL, 4),    -- Amanda in MATH1220
(5, 9, '2024-08-15', 'enrolled', NULL, 4),     -- Kevin in MATH1210
(5, 14, '2024-08-15', 'enrolled', NULL, 3),    -- Kevin in BUS1050
(6, 9, '2024-08-15', 'enrolled', NULL, 4),     -- Rachel in MATH1210
(7, 14, '2024-08-15', 'enrolled', NULL, 3),    -- Marcus in BUS1050
(8, 8, '2024-08-15', 'enrolled', NULL, 4),     -- Elena in MATH1050
(9, 6, '2024-08-15', 'enrolled', NULL, 3),     -- Thomas in CS3550
(10, 2, '2024-08-15', 'enrolled', NULL, 4),    -- Sophie in CS1400

-- Spring 2024 Completed Enrollments (with grades)
(1, 16, '2024-01-15', 'completed', 'B+', 4),   -- John completed CS1400
(1, 23, '2024-01-15', 'completed', 'A-', 3),   -- John completed ENG1010
(2, 17, '2024-01-15', 'completed', 'A', 4),    -- Jane completed CS1410
(2, 21, '2024-01-15', 'completed', 'A-', 4),   -- Jane completed MATH1210
(3, 16, '2024-01-15', 'completed', 'C+', 4),   -- Carlos completed CS1400
(4, 18, '2024-01-15', 'completed', 'A', 4),    -- Amanda completed CS2420
(4, 22, '2024-01-15', 'completed', 'A-', 4),   -- Amanda completed MATH1220
(5, 20, '2024-01-15', 'completed', 'B', 4),    -- Kevin completed MATH1050
(6, 21, '2024-01-15', 'completed', 'A-', 4),   -- Rachel completed MATH1210
(7, 24, '2024-01-15', 'completed', 'C', 3),    -- Marcus completed BUS1050
(8, 20, '2024-01-15', 'completed', 'C-', 4),   -- Elena completed MATH1050
(9, 19, '2024-01-15', 'completed', 'A', 3),    -- Thomas completed CS2550
(10, 16, '2024-01-15', 'completed', 'A-', 4),  -- Sophie completed CS1400

-- Additional historical enrollments for GPA calculation
(11, 16, '2024-01-15', 'completed', 'B-', 4),
(12, 17, '2024-01-15', 'completed', 'B+', 4),
(13, 20, '2024-01-15', 'completed', 'C+', 4),
(14, 18, '2024-01-15', 'completed', 'A', 4),
(15, 16, '2024-01-15', 'completed', 'C', 4),
(16, 21, '2024-01-15', 'completed', 'B+', 4),
(17, 24, '2024-01-15', 'completed', 'A-', 3),
(18, 19, '2024-01-15', 'completed', 'A+', 3),
(19, 24, '2024-01-15', 'completed', 'B', 3),
(20, 22, '2024-01-15', 'completed', 'A-', 4),

-- Summer 2024 enrollments
(21, 25, '2024-06-01', 'completed', 'B-', 4),  -- Ryan in Summer CS1400
(22, 26, '2024-06-01', 'completed', 'D+', 4),  -- Samantha in Summer MATH1050

-- Some withdrawn enrollments for variety
(8, 23, '2024-01-15', 'withdrawn', 'W', 3),    -- Elena withdrew from ENG1010
(15, 24, '2024-01-15', 'withdrawn', 'W', 3);   -- Jacob withdrew from BUS1050


-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================================
-- DATA VALIDATION QUERIES
-- =============================================================================

-- Verify data was inserted correctly

SELECT 'Table' as table_name, 'Count' as record_count
UNION ALL
SELECT 'Departments', CAST(COUNT(*) AS CHAR) FROM Departments
UNION ALL
SELECT 'Faculty', CAST(COUNT(*) AS CHAR) FROM Faculty  
UNION ALL
SELECT 'Students', CAST(COUNT(*) AS CHAR) FROM Students
UNION ALL
SELECT 'Programs', CAST(COUNT(*) AS CHAR) FROM Programs
UNION ALL
SELECT 'Student_Programs', CAST(COUNT(*) AS CHAR) FROM Student_Programs
UNION ALL
SELECT 'Courses', CAST(COUNT(*) AS CHAR) FROM Courses
UNION ALL
SELECT 'Course_Prerequisites', CAST(COUNT(*) AS CHAR) FROM Course_Prerequisites
UNION ALL
SELECT 'Course_Sections', CAST(COUNT(*) AS CHAR) FROM Course_Sections
UNION ALL
SELECT 'Enrollments', CAST(COUNT(*) AS CHAR) FROM Enrollments;
-- =============================================================================
-- NOTES
-- =============================================================================

/*
DATA NOTES:
1. All students have realistic California addresses
2. GPAs range from 2.45 to 3.94 showing variety in academic performance  
3. Total credits vary to show students at different stages
4. Phone numbers use 555 prefix to avoid real numbers
5. Email addresses follow institutional pattern

EXPANSION NEEDED:
1. Complete the Courses table with realistic course offerings
2. Add Course_Prerequisites to show prerequisite chains
3. Create Course_Sections for Fall 2024 and Spring 2024 semesters
4. Add Enrollments data showing student registrations
5. Include some completed courses with letter grades

BUSINESS RULES DEMONSTRATED:
1. Students can have multiple majors (double major examples included)
2. Faculty are assigned to departments
3. Programs belong to departments
4. Student data includes academic standing tracking
*/
