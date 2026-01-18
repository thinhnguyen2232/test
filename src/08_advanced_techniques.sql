-- Assignment 1: Basic Queries  
-- CS3550 - Advanced Database Systems
-- Student Name: [Thinh Nguyen]
-- Date: [01/17/2026]
-- Database: MySQL 8.0


-- =============================================================================
-- TASK 6: ADVANCED TECHNIQUES (BONUS - 10 POINTS)
-- =============================================================================
-- This task is optional bonus work for extra credit.
-- Each query is worth 2 points.

-- Instructions:
-- Demonstrate advanced SQL features including:
-- - Window functions (RANK, ROW_NUMBER, DENSE_RANK)
-- - CASE statements for conditional logic
-- - String manipulation functions
-- - Date/time functions
-- - Pivot-style queries using CASE

-- =============================================================================
-- Query 1: Window Functions - Rank students by GPA within their program (2 POINTS)
-- =============================================================================
-- TODO: Write a query using window functions to rank students:
-- - Student first name and last name
-- - Program name
-- - GPA
-- - Rank within program (using RANK())
-- - Row number (using ROW_NUMBER())
-- - Dense rank (using DENSE_RANK())
-- - Partition by program so rankings are within each program
-- - Order by GPA descending within each partition
-- - Overall order by program name, then rank

SELECT
    s.first_name,
    s.last_name,
    p.program_name,
    s.gpa,
    RANK() OVER (
        PARTITION BY p.program_id
        ORDER BY s.gpa DESC
    ) AS gpa_rank_in_program,
    ROW_NUMBER() OVER (
        PARTITION BY p.program_id
        ORDER BY s.gpa DESC
    ) AS row_num_in_program,
    DENSE_RANK() OVER (
        PARTITION BY p.program_id
        ORDER BY s.gpa DESC
    ) AS dense_rank_in_program
FROM student_programs sp
JOIN students s
    ON sp.student_id = s.student_id
JOIN programs p
    ON sp.program_id = p.program_id
ORDER BY p.program_name, gpa_rank_in_program, s.last_name, s.first_name;



-- =============================================================================
-- Query 2: CASE Statements - Create academic standing categories (2 POINTS)
-- =============================================================================
-- TODO: Write a query that categorizes students by academic standing:
-- - Student first name and last name
-- - GPA
-- - Total credits completed
-- - Academic standing (using nested CASE):
--   * "Dean's List" if GPA >= 3.7 and credits >= 12
--   * "Honor Roll" if GPA >= 3.3 and credits >= 12
--   * "Good Standing" if GPA >= 2.0
--   * "Academic Warning" if GPA >= 1.5 and GPA < 2.0
--   * "Academic Probation" if GPA < 1.5
-- - Enrollment status: "Full-time" if credits >= 12, "Part-time" otherwise
-- - Use CASE statements for all categorizations
-- - Order by GPA descending

SELECT
    s.first_name,
    s.last_name,
    s.gpa,
    s.total_credits,
    CASE
        WHEN s.gpa >= 3.7 AND s.total_credits >= 12 THEN "Dean's List"
        WHEN s.gpa >= 3.3 AND s.total_credits >= 12 THEN "Honor Roll"
        WHEN s.gpa >= 2.0 THEN "Good Standing"
        WHEN s.gpa >= 1.5 AND s.gpa < 2.0 THEN "Academic Warning"
        ELSE "Academic Probation"
    END AS academic_standing,
    CASE
        WHEN s.total_credits >= 12 THEN "Full-time"
        ELSE "Part-time"
    END AS enrollment_status
FROM students s
ORDER BY s.gpa DESC, s.last_name, s.first_name;


-- =============================================================================
-- Query 3: String Functions - Format student names and extract email domains (2 POINTS)
-- =============================================================================
-- TODO: Write a query that demonstrates string manipulation:
-- - Full name formatted as "Last, First"
-- - Full name in uppercase
-- - Email username (part before @)
-- - Email domain (part after @)
-- - Initials (first letter of first name + first letter of last name)
-- - Name length (total characters in full name)
-- - Use functions: CONCAT(), UPPER(), LOWER(), SUBSTRING_INDEX(), LEFT(), LENGTH()
-- - Order by last name

SELECT
    s.last_name,
    s.first_name,
    CONCAT(s.last_name, ', ', s.first_name) AS full_name_last_first,
    UPPER(CONCAT(s.first_name, ' ', s.last_name)) AS full_name_upper,
    SUBSTRING_INDEX(s.email, '@', 1) AS email_username,
    SUBSTRING_INDEX(s.email, '@', -1) AS email_domain,
    CONCAT(LEFT(s.first_name, 1), LEFT(s.last_name, 1)) AS initials,
    LENGTH(CONCAT(s.first_name, s.last_name)) AS name_length
FROM students s
ORDER BY s.last_name, s.first_name;



-- =============================================================================
-- Query 4: Date Functions - Calculate student age and years since enrollment (2 POINTS)
-- =============================================================================
-- TODO: Write a query that works with dates:
-- - Student first name and last name
-- - Date of birth
-- - Age in years (calculated from current date)
-- - Enrollment date
-- - Years enrolled (calculated from enrollment date to current date)
-- - Months enrolled (more precise calculation)
-- - Semester they enrolled (Spring, Summer, or Fall based on month)
-- - Use functions: TIMESTAMPDIFF(), YEAR(), MONTH(), CURDATE(), DATE_FORMAT()
-- - Order by age descending

SELECT
    s.first_name,
    s.last_name,
    s.date_of_birth,
    TIMESTAMPDIFF(YEAR, s.date_of_birth, CURDATE()) AS age_years,
    s.enrollment_date,
    TIMESTAMPDIFF(YEAR, s.enrollment_date, CURDATE()) AS years_enrolled,
    TIMESTAMPDIFF(MONTH, s.enrollment_date, CURDATE()) AS months_enrolled,
    CASE
        WHEN MONTH(s.enrollment_date) IN (1, 2, 3, 4) THEN 'Spring'
        WHEN MONTH(s.enrollment_date) IN (5, 6, 7) THEN 'Summer'
        ELSE 'Fall'
    END AS enrollment_semester
FROM students s
ORDER BY age_years DESC, s.last_name, s.first_name;



-- =============================================================================
-- Query 5: Pivot-style Query - Enrollment counts by semester and department (2 POINTS)
-- =============================================================================
-- TODO: Write a pivot-style query showing enrollment distribution:
-- - Department name
-- - Count of enrollments in Spring 2024 semester (using CASE)
-- - Count of enrollments in Summer 2024 semester (using CASE)
-- - Count of enrollments in Fall 2024 semester (using CASE)
-- - Total enrollments across all 2024 semesters
-- - Use CASE statements inside SUM() to pivot the data
-- - GROUP BY department
-- - Order by total enrollments descending
-- 
-- Example output:
-- Department       | Spring | Summer | Fall | Total
-- Computer Science |    45  |   12   |  52  |  109
-- Mathematics      |    38  |    8   |  41  |   87

SELECT
    d.dept_name AS department,
    SUM(CASE WHEN cs.year = 2024 AND cs.semester = 'spring' THEN 1 ELSE 0 END) AS spring_2024,
    SUM(CASE WHEN cs.year = 2024 AND cs.semester = 'summer' THEN 1 ELSE 0 END) AS summer_2024,
    SUM(CASE WHEN cs.year = 2024 AND cs.semester = 'fall' THEN 1 ELSE 0 END) AS fall_2024,
    SUM(CASE WHEN cs.year = 2024 THEN 1 ELSE 0 END) AS total_2024
FROM enrollments e
JOIN course_sections cs
    ON e.section_id = cs.section_id
JOIN courses c
    ON cs.course_id = c.course_id
JOIN departments d
    ON c.dept_id = d.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY total_2024 DESC, d.dept_name;
