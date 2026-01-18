-- Assignment 1: Basic Queries  
-- CS3550 - Advanced Database Systems
-- Student Name: [Thinh Nguyen]
-- Date: [01/17/2026]
-- Database: MySQL 8.0

-- =============================================================================
-- TASK 5: SUBQUERIES AND CTEs (20 POINTS)
-- =============================================================================
-- Write queries using subqueries and Common Table Expressions to solve complex problems.
-- Each query is worth 4 points.

-- =============================================================================
-- QUERY 16: Find students with GPA higher than the average GPA of their program (4 points)
-- =============================================================================
-- TODO: Find students with GPA higher than the average GPA of their program
-- - Student first name and last name
-- - Their GPA
-- - Program name
-- - Program average GPA
-- - Only show students whose GPA is above their program's average
-- - Use a CTE to calculate program averages first
-- - Then join with Students to compare
-- - Order by GPA descending

WITH program_avg AS (
    SELECT
        sp.program_id,
        AVG(s.gpa) AS avg_gpa
    FROM student_programs sp
    JOIN students s
        ON sp.student_id = s.student_id
    GROUP BY sp.program_id
)
SELECT
    s.first_name,
    s.last_name,
    s.gpa,
    p.program_name,
    ROUND(pa.avg_gpa, 2) AS program_avg_gpa
FROM student_programs sp
JOIN students s
    ON sp.student_id = s.student_id
JOIN programs p
    ON sp.program_id = p.program_id
JOIN program_avg pa
    ON sp.program_id = pa.program_id
WHERE s.gpa > pa.avg_gpa
ORDER BY s.gpa DESC;



-- =============================================================================
-- QUERY 17: List courses that have above-average enrollment across all sections (4 points)
-- =============================================================================
-- TODO: List courses that have above-average enrollment across all sections
-- - Course code and course name
-- - Total enrollment count across all sections
-- - Overall average enrollment per course
-- - Only show courses above the average
-- - Use a subquery or CTE to calculate the average enrollment
-- - Then filter courses above that average
-- - Order by enrollment count descending

WITH course_enrollment AS (
    SELECT
        c.course_id,
        c.course_name,
        COUNT(e.student_id) AS total_enrollment
    FROM courses c
LEFT JOIN course_sections cs
        ON c.course_id = cs.course_id
LEFT JOIN enrollments e
        ON cs.section_id = e.section_id
    GROUP BY c.course_id, c.course_name
),
overall_avg AS (
    SELECT AVG(total_enrollment) AS avg_enrollment
    FROM course_enrollment
)
SELECT
    ce.course_id AS course_code,
    ce.course_name,
    ce.total_enrollment,
    ROUND(oa.avg_enrollment, 2) AS overall_avg_enrollment
FROM course_enrollment ce
CROSS JOIN overall_avg oa
WHERE ce.total_enrollment > oa.avg_enrollment
ORDER BY ce.total_enrollment DESC;



-- =============================================================================
-- QUERY 18: Using CTE, find faculty who teach more sections than the department average (4 points)
-- =============================================================================
-- TODO: Using CTE, find faculty who teach more sections than the department average
-- - Faculty first name and last name
-- - Department name
-- - Number of sections they're teaching
-- - Department average sections per faculty
-- - Only show faculty teaching more than their department average
-- - Use WITH clause to create a CTE for department averages
-- - Join with faculty data to compare
-- - Order by number of sections descending

WITH faculty_sections AS (
    SELECT
        f.faculty_id,
        f.first_name,
        f.last_name,
        f.dept_id,
        COUNT(cs.section_id) AS sections_teaching
    FROM faculty f
    LEFT JOIN course_sections cs
        ON f.faculty_id = cs.faculty_id
    GROUP BY f.faculty_id, f.first_name, f.last_name, f.dept_id
),
dept_avg AS (
    SELECT
        dept_id,
        AVG(sections_teaching) AS avg_sections_per_faculty
    FROM faculty_sections
    GROUP BY dept_id
)
SELECT
    fs.first_name,
    fs.last_name,
    d.dept_name,
    fs.sections_teaching,
    ROUND(da.avg_sections_per_faculty, 2) AS dept_avg_sections
FROM faculty_sections fs
JOIN dept_avg da
    ON fs.dept_id = da.dept_id
JOIN departments d
    ON fs.dept_id = d.dept_id
WHERE fs.sections_teaching > da.avg_sections_per_faculty
ORDER BY fs.sections_teaching DESC;



-- =============================================================================
-- QUERY 19: Show all prerequisite chains for CS3550 (recursive relationship) (4 points)
-- =============================================================================
-- TODO: Show all prerequisite chains for CS3550 (recursive relationship)
-- - Course code
-- - Course name
-- - Level in the prerequisite chain (1 = direct, 2 = prerequisite of prerequisite, etc.)
-- - Use a recursive CTE with UNION ALL
-- - Start with CS3550
-- - Recursively join to find prerequisites of prerequisites
-- - Show the full chain from CS3550 back to foundational courses
-- - Order by level, then course code

WITH RECURSIVE prereq_chain AS (
    -- Level 1: direct prerequisites of CS3550
    SELECT
        cp.course_id,
        cp.prerequisite_course_id AS prereq_course_id,
        1 AS level
    FROM course_prerequisites cp
    WHERE cp.course_id = 'CS3550'

    UNION ALL

    -- Next levels: prerequisites of prerequisites
    SELECT
        pc.prereq_course_id AS course_id,
        cp2.prerequisite_course_id AS prereq_course_id,
        pc.level + 1 AS level
    FROM prereq_chain pc
    JOIN course_prerequisites cp2
        ON cp2.course_id = pc.prereq_course_id
)
SELECT
    pr.course_id AS course_code,
    c.course_name,
    pr.level
FROM prereq_chain pr
JOIN courses c
    ON pr.course_id = c.course_id
ORDER BY pr.level, pr.course_id;



-- =============================================================================
-- QUERY 20: Find students who have completed ≥ 60 credits with GPA ≥ 2.0 (4 points)
-- =============================================================================
-- TODO: Find students who have completed ≥ 60 credits with GPA ≥ 2.0
-- - Student first name and last name
-- - Program name
-- - Total credits completed
-- - Program required credits
-- - Current GPA
-- - Criteria: Completed credits >= program requirements AND GPA >= 2.0
-- - Use subqueries or CTEs to calculate completed credits per student
-- - Join with program requirements
-- - Filter for students meeting all criteria
-- - Order by GPA descending

WITH student_progress AS (
    SELECT
        sp.student_id,
        sp.program_id,
        s.first_name,
        s.last_name,
        s.total_credits,
        s.gpa
    FROM student_programs sp
    JOIN students s
        ON sp.student_id = s.student_id
)
SELECT
    st.first_name,
    st.last_name,
    p.program_name,
    st.total_credits AS credits_completed,
    p.credit_hours_required AS program_required_credits,
    st.gpa
FROM student_progress st
JOIN programs p
    ON st.program_id = p.program_id
WHERE st.gpa >= 2.0
  AND st.total_credits >= 60
ORDER BY st.gpa DESC;

-- =============================================================================
-- PERFORMANCE NOTE:
-- =============================================================================
-- After writing your queries, compare execution times between:
-- - Subquery approach
-- - CTE approach  
-- - JOIN-only approach
-- Use EXPLAIN to analyze query plans and understand performance differences