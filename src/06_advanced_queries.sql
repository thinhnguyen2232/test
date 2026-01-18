-- Assignment 1: Advanced Queries with Aggregations
-- CS3550 - Advanced Database Systems
-- Student Name: [Your Name]
-- Date: [Date]
-- Database: MySQL 8.0

-- =============================================================================
-- TASK 6: ADVANCED QUERIES (20 POINTS)
-- =============================================================================
-- Write complex queries using GROUP BY, HAVING, aggregate functions, and advanced SQL features.
-- Each query is worth 4 points.

-- =============================================================================
-- QUERY 11: Show course sections with enrollment counts and percentage filled (4 points)
-- =============================================================================
-- TODO: Enrollment Report - Show course sections with enrollment counts and percentage filled
-- - Course code and course name
-- - Section number
-- - Semester and year
-- - Current enrollment count
-- - Maximum capacity
-- - Percentage filled (calculated as current_enrollment / max_capacity * 100)
-- - Status: 'Full' if at 100%, 'High' if >= 80%, 'Medium' if >= 50%, 'Low' if < 50%
-- - Use JOINs between Course_Sections and Courses
-- - Use CASE statement for status
-- - Order by percentage filled descending

SELECT
    c.course_id AS course_code,
    c.course_name,
    cs.section_number,
    cs.semester,
    cs.year,
    COUNT(e.student_id) AS current_enrollment,
    cs.max_capacity,
   ROUND(
    (COUNT(e.student_id) / cs.max_capacity) * 100,
    2
) AS percent_filled,

CASE
    WHEN (COUNT(e.student_id) / cs.max_capacity) * 100 = 100 THEN 'Full'
    WHEN (COUNT(e.student_id) / cs.max_capacity) * 100 >= 80 THEN 'High'
    WHEN (COUNT(e.student_id) / cs.max_capacity) * 100 >= 50 THEN 'Medium'
    ELSE 'Low'
END AS status

FROM Course_Sections cs
JOIN Courses c
    ON cs.course_id = c.course_id
LEFT JOIN Enrollments e
    ON cs.section_id = e.section_id
GROUP BY
    cs.section_id, c.course_id, c.course_name, cs.section_number, cs.semester, cs.year, cs.max_capacity
ORDER BY percent_filled DESC;



-- =============================================================================
-- QUERY 12: Calculate average GPA of students by department (based on their major) (4 points)
-- =============================================================================
-- TODO: Department Analysis - Calculate average GPA of students by department (based on their major)
-- - Department name
-- - Number of students majoring in that department's programs
-- - Average GPA of those students
-- - Highest GPA in the department
-- - Lowest GPA in the department
-- - Use multiple JOINs (Students, Student_Programs, Programs, Departments)
-- - Use AVG(), MAX(), MIN(), COUNT() aggregate functions
-- - GROUP BY department
-- - Order by average GPA descending

SELECT
    d.dept_name,
    COUNT(DISTINCT s.student_id) AS student_count,
    ROUND(AVG(s.gpa), 2) AS avg_gpa,
    MAX(s.gpa) AS highest_gpa,
    MIN(s.gpa) AS lowest_gpa
FROM Departments d
JOIN Programs p
    ON d.dept_id = p.dept_id
JOIN Student_Programs sp
    ON p.program_id = sp.program_id
JOIN Students s
    ON sp.student_id = s.student_id
GROUP BY d.dept_id, d.dept_name
ORDER BY avg_gpa DESC;



-- =============================================================================
-- QUERY 13: Show faculty teaching load (number of sections and total enrolled students) (4 points)
-- =============================================================================
-- TODO: Faculty Workload - Show faculty teaching load (number of sections and total enrolled students)
-- - Faculty first name and last name
-- - Department name
-- - Number of sections teaching
-- - Total number of students across all their sections
-- - Use JOINs between Faculty, Departments, Course_Sections, and Enrollments
-- - Use COUNT() for sections and students
-- - GROUP BY faculty member
-- - Filter to show only faculty teaching at least 1 section (use HAVING)
-- - Order by total students descending

SELECT
    f.first_name,
    f.last_name,
    d.dept_name,
    COUNT(DISTINCT cs.section_id) AS sections_teaching,
    COUNT(e.student_id) AS total_students
FROM Faculty f
JOIN Departments d
    ON f.dept_id = d.dept_id
JOIN Course_Sections cs
    ON f.faculty_id = cs.faculty_id
LEFT JOIN Enrollments e
    ON cs.section_id = e.section_id
GROUP BY f.faculty_id, f.first_name, f.last_name, d.dept_name
HAVING COUNT(DISTINCT cs.section_id) >= 1
ORDER BY total_students DESC;





-- =============================================================================
-- QUERY 14: Find students who have completed all prerequisites for CS3550 (4 points)
-- =============================================================================
-- TODO: Student Progress - Find students who have completed all prerequisites for CS3550
-- - Student first name and last name
-- - List of completed prerequisite courses (if available)
-- - Check that they have passed (grade >= C) all prerequisites
-- - Use JOINs with Course_Prerequisites, Enrollments, Courses
-- - May need subquery or multiple joins
-- - Only include students who have completed ALL prerequisites for CS3550
-- - Order by student last name

SELECT
    s.first_name,
    s.last_name,
    GROUP_CONCAT(DISTINCT cs.course_id ORDER BY cs.course_id SEPARATOR ', ') AS completed_prereqs
FROM students s
JOIN enrollments e
    ON s.student_id = e.student_id
JOIN course_sections cs
    ON e.section_id = cs.section_id
JOIN course_prerequisites cp
    ON cs.course_id = cp.prerequisite_course_id
WHERE cp.course_id = 'CS3550'
  AND e.grade IN ('A','A-','B+','B','B-','C+','C')
GROUP BY s.student_id, s.first_name, s.last_name
HAVING COUNT(DISTINCT cs.course_id) = (
    SELECT COUNT(*)
    FROM course_prerequisites
    WHERE course_id = 'CS3550'
)
ORDER BY s.last_name, s.first_name;



-- =============================================================================
-- QUERY 15: Create a report showing students on Dean's List (GPA ≥ 3.7 and ≥ 12 credits) (4 points)
-- =============================================================================
-- TODO: Academic Standing - Create a report showing students on Dean's List (GPA ≥ 3.7 and ≥ 12 credits)
-- - Student first name, last name, and student number
-- - Total credit hours (use total_credits column)
-- - Current GPA
-- - Program name (if enrolled in a program)
-- - Criteria: GPA >= 3.7 AND total_credits >= 12
-- - Use JOINs between Students and Student_Programs/Programs
-- - Filter for active students
-- - Order by GPA descending

SELECT
    s.student_number,
    s.first_name,
    s.last_name,
    s.total_credits,
    s.gpa,
    p.program_name
FROM Students s
LEFT JOIN Student_Programs sp
    ON s.student_id = sp.student_id
LEFT JOIN Programs p
    ON sp.program_id = p.program_id
WHERE s.gpa >= 3.7
  AND s.total_credits >= 12
-- Uncomment the next line only if your table has a status/active flag:
-- AND s.status = 'active'
ORDER BY s.gpa DESC, s.last_name, s.first_name;
