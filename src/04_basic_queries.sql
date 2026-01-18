-- Assignment 1: Basic Queries  
-- CS3550 - Advanced Database Systems
-- Student Name: [Thinh Nguyen]
-- Date: [01/17/2026]
-- Database: MySQL 8.0

-- =============================================================================
-- TASK 2: BASIC QUERIES (20 POINTS)
-- =============================================================================
-- Write SQL queries to answer questions using SELECT, WHERE, ORDER BY, and basic filtering.
-- Each query is worth 4 points.

-- Ensure we're using the correct database
USE community_college_db;

-- =============================================================================
-- QUERY 1: List all students with their contact information, ordered by last name (4 points)
-- =============================================================================

-- TODO: List all students with their contact information, ordered by last name
-- Required columns: student_number, first_name, last_name, email, phone
-- Order by: last_name, then first_name


SELECT 
    student_number, first_name, last_name, email, phone
FROM Students
	order by 
		last_name , first_name
;


-- Expected result: All students listed alphabetically by last name

-- =============================================================================
-- QUERY 2: Show all courses offered by the Computer Science department (4 points)
-- =============================================================================

-- TODO: Show all courses offered by the Computer Science department
-- Required columns: course_id, course_name, credit_hours
-- Filter: Only Computer Science department courses (dept_id = 'CS')

SELECT 
    course_id,
    course_name,
    credit_hours
FROM Courses
WHERE dept_id = 'CS';


-- Expected result: All courses with dept_id = 'CS'

-- =============================================================================
-- QUERY 3: Find all faculty members hired in the last 5 years (4 points)
-- =============================================================================

-- TODO: Find all faculty members hired in the last 5 years
-- Required columns: employee_id, first_name, last_name, dept_id, hire_date
-- Filter: Hired on or after January 1, 2019
-- Order by: hire_date (most recent first)

SELECT 
    employee_id,
    first_name,
    last_name,
    dept_id,
    hire_date
FROM Faculty
WHERE hire_date >= '2019-01-01'
ORDER BY hire_date DESC;


-- Expected result: Faculty hired since 2019-01-01

-- =============================================================================
-- QUERY 4: List all students with a GPA above 3.5 (4 points)
-- =============================================================================

-- TODO: List all students with a GPA above 3.5
-- Required columns: student_number, first_name, last_name, gpa, total_credits
-- Filter: GPA > 3.5
-- Order by: GPA (highest first)

SELECT 
    student_number,
    first_name,
    last_name,
    gpa,
    total_credits
FROM Students
WHERE gpa > 3.5
ORDER BY gpa DESC;


-- Expected result: Students with GPA > 3.5, ordered by GPA descending

-- =============================================================================
-- QUERY 5: Show all course sections for Fall 2024 semester (4 points)
-- =============================================================================

-- TODO: Show all course sections for Fall 2024 semester
-- Required columns: section_id, course_id, faculty_id, days_of_week, start_time, room
-- Filter: semester = 'fall' AND year = 2024
-- Order by: course_id, then section_number

SELECT 
    section_id,
    course_id,
    faculty_id,
    days_of_week,
    start_time,
    room
FROM Course_Sections
WHERE semester = 'fall'
  AND year = 2024
ORDER BY course_id, section_number;


-- Expected result: All Fall 2024 course sections

-- =============================================================================
-- NOTES AND TIPS
-- =============================================================================

/*
QUERY WRITING TIPS:
1. Always test your queries with a small dataset first
2. Use LIMIT 5 or LIMIT 10 while developing to see sample results
3. Check that your WHERE conditions are correct
4. Verify that ORDER BY produces the expected sorting
5. Make sure column names match your schema exactly

COMMON MISTAKES TO AVOID:
1. Forgetting the semicolon at the end of queries
2. Using wrong table or column names (case sensitive!)
3. Forgetting to use quotes around string values in WHERE clauses
4. Using = instead of LIKE for partial string matches
5. Not handling NULL values properly in comparisons

TESTING APPROACH:
1. Write the query without WHERE clause first to see all data
2. Add WHERE clause and test with a few expected results  
3. Add ORDER BY and verify the sorting is correct
4. Count the results to make sure they match expectations
*/

-- =============================================================================
-- GRADING RUBRIC REFERENCE
-- =============================================================================

/*
TOTAL POINTS FOR BASIC QUERIES: 10 points

Query 1 (2 points):
- 2 pts: All required columns, correct ORDER BY
- 1 pt: Missing one element or minor syntax issue
- 0 pts: Major errors or wrong results

Query 2 (2 points):
- 2 pts: Correct WHERE clause and all columns
- 1 pt: Correct filter OR correct columns
- 0 pts: Wrong logic or syntax errors

Query 3 (2 points):
- 2 pts: Correct date filtering and DESC ordering
- 1 pt: Either correct filter or correct ordering
- 0 pts: Wrong date logic

Query 4 (2 points):
- 2 pts: Correct GPA comparison and DESC ordering
- 1 pt: Either correct filter or correct ordering
- 0 pts: Wrong comparison or major errors

Query 5 (2 points):
- 2 pts: Correct semester/year filter and ordering
- 1 pt: Correct filter OR reasonable ordering
- 0 pts: Wrong semester logic

BONUS QUERIES (up to 2 extra points):
- Well-structured GROUP BY queries
- Proper handling of NULL values
- Creative but correct approaches
- Additional useful information included

COMMON DEDUCTIONS:
- Missing semicolons: -0.5 points per query
- Case sensitivity errors: -0.5 points per query
- Poor formatting: -1 point overall
- Missing comments: -1 point overall
*/
