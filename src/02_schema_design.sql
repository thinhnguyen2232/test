-- Assignment 1: Database Schema (PROVIDED - DO NOT MODIFY)
-- CS3550 - Advanced Database Systems  
-- Database: MySQL 8.0

-- =============================================================================
-- COMMUNITY COLLEGE MANAGEMENT SYSTEM - DATABASE SCHEMA
-- =============================================================================
-- 
-- ⚠️ THIS FILE IS PROVIDED FOR YOU - DO NOT MODIFY
-- 
-- This schema creates all necessary tables for the Community College
-- Management System. You will use this database to write queries in
-- the following files:
--   - 04_basic_queries.sql (Task 2.1)
--   - 05_intermediate_queries.sql (Task 2.2)
--   - 06_advanced_queries.sql (Task 2.3)
--   - 07_subqueries_ctes.sql (Task 2.4)
--   - 08_advanced_techniques.sql (Bonus)
-- 
-- =============================================================================

-- Setup: Create and use the database
CREATE DATABASE IF NOT EXISTS community_college_db;
USE community_college_db;

-- Set SQL mode for strict data validation
SET SQL_MODE = 'STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO';

-- =============================================================================
-- TABLE CREATION
-- =============================================================================

-- Drop tables in reverse order to avoid foreign key conflicts
-- (Uncomment these when testing schema changes)

DROP TABLE IF EXISTS Enrollments;
DROP TABLE IF EXISTS Student_Programs;
DROP TABLE IF EXISTS Course_Sections;
DROP TABLE IF EXISTS Course_Prerequisites;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Programs;
DROP TABLE IF EXISTS Faculty;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Departments;


-- -----------------------------------------------------------------------------
-- Departments Table
-- -----------------------------------------------------------------------------
CREATE TABLE Departments (
    dept_id VARCHAR(10) PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL UNIQUE,
    dept_head_id INT NULL,  -- Will reference Faculty table (added later)
    building VARCHAR(50),
    room_number VARCHAR(10),
    phone VARCHAR(15),
    email VARCHAR(100),
    budget DECIMAL(12,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_budget_positive CHECK (budget >= 0),
    CONSTRAINT chk_dept_email_format CHECK (email LIKE '%@%.%'),
    
    -- Indexes for performance
    INDEX idx_dept_name (dept_name),
    INDEX idx_dept_head (dept_head_id),
    INDEX idx_dept_building (building)
) COMMENT = 'Academic departments within the college';

-- -----------------------------------------------------------------------------
-- Faculty Table
-- -----------------------------------------------------------------------------
CREATE TABLE Faculty (
    faculty_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id VARCHAR(20) NOT NULL UNIQUE,
    dept_id VARCHAR(10) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15),
    office_building VARCHAR(50),
    office_room VARCHAR(10),
    hire_date DATE NOT NULL,
    employment_status ENUM('full-time', 'part-time', 'adjunct', 'emeritus', 'sabbatical') DEFAULT 'full-time',
    salary DECIMAL(10,2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    
    -- Constraints
    CONSTRAINT chk_salary_positive CHECK (salary > 0),
    CONSTRAINT chk_faculty_email_format CHECK (email LIKE '%@%.%'),
    
    -- Indexes
    INDEX idx_faculty_dept (dept_id),
    INDEX idx_faculty_name (last_name, first_name),
    INDEX idx_faculty_email (email),
    INDEX idx_faculty_employee_id (employee_id),
    INDEX idx_faculty_status (employment_status, is_active)
) COMMENT = 'Faculty and staff members';

-- Add foreign key for department head after Faculty table exists
ALTER TABLE Departments 
ADD CONSTRAINT fk_dept_head 
FOREIGN KEY (dept_head_id) REFERENCES Faculty(faculty_id) ON DELETE SET NULL;

-- -----------------------------------------------------------------------------
-- Students Table
-- -----------------------------------------------------------------------------
CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_number VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15),
    address_line1 VARCHAR(100),
    address_line2 VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    date_of_birth DATE,
    enrollment_date DATE NOT NULL,
    graduation_date DATE NULL,
    academic_standing ENUM('excellent', 'good', 'probation', 'suspension', 'dismissed') DEFAULT 'good',
    gpa DECIMAL(3,2) DEFAULT 0.00,
    total_credits INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_gpa_range CHECK (gpa >= 0.00 AND gpa <= 4.00),
    CONSTRAINT chk_credits_positive CHECK (total_credits >= 0),
    CONSTRAINT chk_graduation_after_enrollment CHECK (graduation_date IS NULL OR graduation_date >= enrollment_date),
    CONSTRAINT chk_student_email_format CHECK (email LIKE '%@%.%'),
    CONSTRAINT chk_state_format CHECK (state REGEXP '^[A-Z]{2}$'),
    
    -- Indexes
    INDEX idx_student_number (student_number),
    INDEX idx_student_name (last_name, first_name),
    INDEX idx_student_email (email),
    INDEX idx_student_standing (academic_standing),
    INDEX idx_student_gpa (gpa),
    INDEX idx_student_enrollment (enrollment_date),
    INDEX idx_student_active (is_active)
) COMMENT = 'Student information and academic records';

-- -----------------------------------------------------------------------------
-- Programs Table
-- -----------------------------------------------------------------------------
CREATE TABLE Programs (
    program_id INT AUTO_INCREMENT PRIMARY KEY,
    program_code VARCHAR(10) NOT NULL UNIQUE,
    program_name VARCHAR(100) NOT NULL,
    dept_id VARCHAR(10) NOT NULL,
    degree_type ENUM('certificate', 'associate', 'bachelor', 'master') NOT NULL,
    credit_hours_required INT NOT NULL,
    description TEXT,
    min_gpa_required DECIMAL(3,2) DEFAULT 2.00,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    
    -- Constraints
    CONSTRAINT chk_program_credit_hours_positive CHECK (credit_hours_required > 0),
    CONSTRAINT chk_min_gpa_range CHECK (min_gpa_required >= 0.00 AND min_gpa_required <= 4.00),
    
    -- Indexes
    INDEX idx_program_code (program_code),
    INDEX idx_program_dept (dept_id),
    INDEX idx_program_type (degree_type),
    INDEX idx_program_active (is_active)
) COMMENT = 'Academic programs and degrees offered';

-- -----------------------------------------------------------------------------
-- Student_Programs Table (Many-to-Many relationship)
-- -----------------------------------------------------------------------------
CREATE TABLE Student_Programs (
    student_id INT,
    program_id INT,
    enrollment_date DATE NOT NULL,
    completion_date DATE NULL,
    is_primary_major BOOLEAN DEFAULT FALSE,
    status ENUM('active', 'completed', 'withdrawn', 'transferred') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Primary Key
    PRIMARY KEY (student_id, program_id),
    
    -- Foreign Keys
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (program_id) REFERENCES Programs(program_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_completion_after_enrollment CHECK (completion_date IS NULL OR completion_date >= enrollment_date),
    
    -- Indexes
    INDEX idx_student_programs_student (student_id),
    INDEX idx_student_programs_program (program_id),
    INDEX idx_student_programs_status (status),
    INDEX idx_student_programs_primary (is_primary_major)
) COMMENT = 'Student enrollment in academic programs (supports multiple majors)';

-- TODO: Add remaining tables
-- 1. Courses table
-- 2. Course_Prerequisites table  
-- 3. Course_Sections table
-- 4. Enrollments table
-- 5. Grades table (optional - could be part of Enrollments)

-- =============================================================================
-- EXAMPLE TABLE STRUCTURE (COMPLETE THIS SECTION)
-- =============================================================================
-- -----------------------------------------------------------------------------
-- Courses Table
-- -----------------------------------------------------------------------------
CREATE TABLE Courses (
    course_id VARCHAR(10) PRIMARY KEY,  -- e.g., 'CS3550'
    dept_id VARCHAR(10) NOT NULL,
    course_number VARCHAR(10) NOT NULL, -- e.g., '3550'
    course_name VARCHAR(100) NOT NULL,
    course_description TEXT,
    credit_hours INT NOT NULL,
    lab_hours INT DEFAULT 0,
    lecture_hours INT DEFAULT 0,
    is_lab_required BOOLEAN DEFAULT FALSE,
    difficulty_level ENUM('introductory', 'intermediate', 'advanced', 'graduate') DEFAULT 'intermediate',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    
    -- Constraints  
    CONSTRAINT chk_course_credit_hours_positive CHECK (credit_hours > 0 AND credit_hours <= 6),
    CONSTRAINT chk_lab_hours_nonnegative CHECK (lab_hours >= 0),
    CONSTRAINT chk_lecture_hours_nonnegative CHECK (lecture_hours >= 0),
    CONSTRAINT chk_total_hours_logical CHECK (credit_hours <= (lecture_hours + lab_hours)),
    
    -- Indexes
    INDEX idx_course_dept (dept_id),
    INDEX idx_course_number (course_number),
    INDEX idx_course_name (course_name),
    INDEX idx_course_level (difficulty_level),
    INDEX idx_course_active (is_active)
) COMMENT = 'Course catalog information';

-- -----------------------------------------------------------------------------
-- Course_Prerequisites Table (Self-referencing Many-to-Many)
-- -----------------------------------------------------------------------------
CREATE TABLE Course_Prerequisites (
    course_id VARCHAR(10),
    prerequisite_course_id VARCHAR(10),
    min_grade ENUM('A', 'B', 'C', 'D') DEFAULT 'D',
    is_corequisite BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Primary Key
    PRIMARY KEY (course_id, prerequisite_course_id),
    
    -- Foreign Keys
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (prerequisite_course_id) REFERENCES Courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Note: CHECK constraint for self-prerequisite removed due to MySQL 8.0 limitation
    -- with foreign key CASCADE actions. This should be enforced at application level.
    
    -- Indexes
    INDEX idx_prereq_course (course_id),
    INDEX idx_prereq_required (prerequisite_course_id),
    INDEX idx_prereq_coreq (is_corequisite)
) COMMENT = 'Course prerequisite and corequisite relationships';

-- -----------------------------------------------------------------------------
-- Course_Sections Table
-- -----------------------------------------------------------------------------
CREATE TABLE Course_Sections (
    section_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id VARCHAR(10) NOT NULL,
    section_number VARCHAR(10) NOT NULL, -- e.g., '001', '002', 'LAB1'
    faculty_id INT NOT NULL,
    semester ENUM('spring', 'summer', 'fall', 'winter') NOT NULL,
    year YEAR NOT NULL,
    days_of_week VARCHAR(10), -- e.g., 'MWF', 'TTH'
    start_time TIME,
    end_time TIME,
    building VARCHAR(50),
    room VARCHAR(10),
    max_capacity INT DEFAULT 30,
    current_enrollment INT DEFAULT 0,
    status ENUM('scheduled', 'active', 'completed', 'cancelled') DEFAULT 'scheduled',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_section_capacity_positive CHECK (max_capacity > 0),
    CONSTRAINT chk_current_enrollment_valid CHECK (current_enrollment >= 0 AND current_enrollment <= max_capacity),
    CONSTRAINT chk_time_logical CHECK (start_time IS NULL OR end_time IS NULL OR start_time < end_time),
    CONSTRAINT chk_year_reasonable CHECK (year >= 2020 AND year <= 2030),
    
    -- Unique constraint for section numbering per course per semester
    UNIQUE KEY uk_section (course_id, section_number, semester, year),
    
    -- Indexes
    INDEX idx_section_course (course_id),
    INDEX idx_section_faculty (faculty_id),
    INDEX idx_section_semester (semester, year),
    INDEX idx_section_time (days_of_week, start_time),
    INDEX idx_section_capacity (current_enrollment, max_capacity),
    INDEX idx_section_status (status)
) COMMENT = 'Specific course section offerings with schedule and enrollment info';

-- -----------------------------------------------------------------------------
-- Enrollments Table
-- -----------------------------------------------------------------------------
CREATE TABLE Enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    section_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    withdrawal_date DATE NULL,
    status ENUM('enrolled', 'withdrawn', 'completed', 'incomplete', 'audit') DEFAULT 'enrolled',
    grade ENUM('A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'D-', 'F', 'I', 'W', 'AU') NULL,
    grade_points DECIMAL(3,2) NULL, -- Calculated field for GPA computation
    credit_hours INT NOT NULL, -- Copied from course for historical accuracy
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign Keys
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (section_id) REFERENCES Course_Sections(section_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_withdrawal_after_enrollment CHECK (withdrawal_date IS NULL OR withdrawal_date >= enrollment_date),
    CONSTRAINT chk_grade_points_range CHECK (grade_points IS NULL OR (grade_points >= 0.00 AND grade_points <= 4.00)),
    CONSTRAINT chk_enrollment_credit_hours_positive CHECK (credit_hours > 0),
    
    -- Unique constraint - student can't enroll in same section twice
    UNIQUE KEY uk_student_section (student_id, section_id),
    
    -- Indexes
    INDEX idx_enrollment_student (student_id),
    INDEX idx_enrollment_section (section_id),
    INDEX idx_enrollment_date (enrollment_date),
    INDEX idx_enrollment_status (status),
    INDEX idx_enrollment_grade (grade),
    INDEX idx_enrollment_semester (section_id, status) -- For semester-based queries
) COMMENT = 'Student enrollments in specific course sections';


-- =============================================================================
-- SCHEMA VALIDATION
-- =============================================================================

-- Show all tables created
SHOW TABLES;

-- Show the structure of key tables
DESCRIBE Students;
DESCRIBE Faculty;
DESCRIBE Departments;

-- =============================================================================
-- NOTES AND DESIGN DECISIONS
-- =============================================================================

/*
DESIGN DECISIONS:
1. [Document your key design decisions here]
2. [Explain why you chose certain data types]
3. [Justify your normalization approach]

ASSUMPTIONS:
1. [List any assumptions you made]
2. [Explain business rules you implemented]

FUTURE ENHANCEMENTS:
1. [Ideas for additional features]
2. [Performance optimization opportunities]
*/
