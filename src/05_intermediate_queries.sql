-- Assignment 1: Basic Queries  
-- CS3550 - Advanced Database Systems
-- Student Name: [Thinh Nguyen]
-- Date: [01/17/2026]
-- Database: MySQL 8.0

-- =============================================================================
-- TASK 3: INTERMEDIATE QUERIES (20 POINTS)
-- =============================================================================
-- Write SQL queries using various types of joins (INNER, LEFT, RIGHT) and intermediate-level filtering.
-- Each query is worth 4 points.

-- =============================================================================
-- QUERY 6: Show all students and their enrolled courses for Spring 2024 (4 points)
-- =============================================================================
-- TODO: Show all students and their enrolled courses for Spring 2024
-- - Student first name and last name
-- - Course code and course name
-- - Grade received (if available)
-- - Use JOINs between Students, Enrollments, Course_Sections, and Courses
-- - Filter for semester = 'spring' AND year = 2024
-- - Order by student last name, then course code

SELECT
    s.first_name,
    s.last_name,
    c.course_id AS course_code,
    c.course_name,
    e.grade
FROM Students s
JOIN Enrollments e
    ON s.student_id = e.student_id
JOIN Course_Sections cs
    ON e.section_id = cs.section_id
JOIN Courses c
    ON cs.course_id = c.course_id
WHERE cs.semester = 'spring'
  AND cs.year = 2024
ORDER BY s.last_name, s.first_name, c.course_id;


-- =============================================================================
-- QUERY 7: List all faculty members and the courses they are teaching (4 points)
-- =============================================================================
-- TODO: List all faculty members and the courses they are teaching
-- - Faculty first name and last name
-- - Course code and course name
-- - Semester and year
-- - Use appropriate JOINs between Faculty, Course_Sections, and Courses
-- - Include faculty even if they're not currently teaching (use LEFT JOIN)
-- - Order by faculty last name

SELECT
    f.first_name,
    f.last_name,
    c.course_id AS course_code,
    c.course_name,
    cs.semester,
    cs.year
FROM Faculty f
LEFT JOIN Course_Sections cs
    ON f.employee_id = cs.faculty_id
LEFT JOIN Courses c
    ON cs.course_id = c.course_id
ORDER BY f.last_name, f.first_name, cs.year DESC, cs.semester, c.course_id;



-- =============================================================================
-- QUERY 8: Find all courses that have no enrollments (4 points)
-- =============================================================================
-- TODO: Find all courses that have no enrollments
-- - Show course code, course name, and department
-- - Use LEFT JOIN between Courses and Enrollments
-- - Filter for courses with NULL enrollment records
-- - Order by department, then course code

SELECT
    c.course_id AS course_code,
    c.course_name,
    c.dept_id AS department
FROM Courses c
LEFT JOIN Course_Sections cs
    ON c.course_id = cs.course_id
LEFT JOIN Enrollments e
    ON cs.section_id = e.section_id
WHERE e.section_id IS NULL
ORDER BY c.dept_id, c.course_id;



-- =============================================================================
-- QUERY 9: Show all students who are not enrolled in any courses (4 points)
-- =============================================================================
-- TODO: Show all students who are not enrolled in any courses
-- - Student first name, last name, and email
-- - Use LEFT JOIN between Students and Enrollments
-- - Filter for NULL enrollment records
-- - Order by last name

SELECT
    s.first_name,
    s.last_name,
    s.email
FROM Students s
LEFT JOIN Enrollments e
    ON s.student_id = e.student_id
WHERE e.student_id IS NULL
ORDER BY s.last_name, s.first_name;



-- =============================================================================
-- QUERY 10: Display all departments with their faculty count and average salary (4 points)
-- =============================================================================
-- TODO: Display all departments with their faculty count and average salary
-- - Department name
-- - Total number of faculty members
-- - Average faculty salary (formatted to 2 decimal places)
-- - Use JOIN between Departments and Faculty
-- - Use GROUP BY to aggregate by department
-- - Order by average salary in descending order

SELECT
    d.dept_name,
    COUNT(f.employee_id) AS faculty_count,
    ROUND(AVG(f.salary), 2) AS avg_salary
FROM Departments d
LEFT JOIN Faculty f
    ON d.dept_id = f.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY avg_salary DESC;
