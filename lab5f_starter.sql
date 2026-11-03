/* ==========================================================================
   lab5f_starter.sql
   CIS 4720 Database Management and SQL
   In Class Lab 5f, Your First Stored Procedures

   WHAT THIS FILE IS
   Lab 5e finished, plus a numbered heading for every step of Lab 5f waiting
   to be filled in. Starting from this file means it does not matter how
   Lab 5e went. Everyone begins from the same place.

   WHAT IT ALREADY BUILDS
     1. students (5 rows) and test_scores (10 rows)
     2. The student_scores view
     3. The calculate_gpa function, with every gpa filled in
     4. attendance, ids 500 to 503
     5. The two triggers from Lab 5e

   HOW TO RUN IT
   One statement at a time. Put the cursor on it and press Ctrl + E twice.
   Anything that runs from CREATE down to END (a function, a trigger or a
   procedure) is ONE statement, however many semicolons are inside it.
   Select the whole block and run the selection. No DELIMITER lines.

   LABELING AND COMMENTING IS REQUIRED
   Above every statement you write, put a short comment in your own words
   saying what it does. The comments are graded.
   ========================================================================== */


-- =================================================================
-- SETUP. Run these three first, one at a time, while you are still
-- connected to information_schema.
-- =================================================================

-- every schema on this server. cis_students_db will not be in the list yet.
show databases;

-- make yours. IF NOT EXISTS means it is safe to run twice.
create database if not exists cis_students_db;

-- switch into it, so everything below lands in the right place.
use cis_students_db;


-- ==================================================================
-- FROM LAB 5D. students. student_id is a surrogate key the server fills in.
-- ==================================================================
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(40) NOT NULL,
    last_name  VARCHAR(40) NOT NULL,
    gpa        FLOAT(4,2)
);
INSERT INTO students VALUES (NULL,'Jenna','Wilson',NULL);
INSERT INTO students VALUES (NULL,'Robert','Reese',NULL);
INSERT INTO students VALUES (NULL,'Maria Elena','Jimenez',NULL);
INSERT INTO students VALUES (NULL,'Inder','Singh',NULL);
INSERT INTO students (first_name,last_name) VALUES ('Rita','Nunez');
INSERT INTO students (first_name,last_name) VALUES ('James','Toor');

-- ==================================================================
-- James was student 6. Deleting him is why the counter says 7.
-- ==================================================================
DELETE FROM students WHERE first_name = 'James' AND last_name = 'Toor';

-- ==================================================================
-- FROM LAB 5D. test_scores, linked to students by a foreign key.
-- ==================================================================
CREATE TABLE test_scores (
    test_score_id INT AUTO_INCREMENT PRIMARY KEY,
    test_name     VARCHAR(20) NOT NULL,
    student_id    INT NOT NULL,
    score         FLOAT,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);
INSERT INTO test_scores VALUES (NULL,'quiz1',1,90),(NULL,'quiz1',2,85),(NULL,'quiz1',3,95),
 (NULL,'quiz2',1,80),(NULL,'quiz2',2,72),(NULL,'quiz2',3,88),(NULL,'quiz2',4,91),
 (NULL,'quiz3',2,95),(NULL,'quiz3',3,94),(NULL,'quiz3',4,74);

-- ==================================================================
-- FROM LAB 5D. The student_scores view.
-- ==================================================================
CREATE VIEW student_scores AS
SELECT s.student_id,
       CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       t.test_name,
       t.score
FROM students s
LEFT OUTER JOIN test_scores t ON s.student_id = t.student_id;

-- ==================================================================
-- FROM LAB 5D. The calculate_gpa function. Select the whole block from
-- CREATE FUNCTION down to END and run the selection.
-- ==================================================================
CREATE FUNCTION calculate_gpa(p_student_id INT)
RETURNS DECIMAL(4,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_gpa DECIMAL(4,2);

    SELECT ROUND(AVG(score), 2)
    INTO v_gpa
    FROM test_scores
    WHERE student_id = p_student_id
      AND score IS NOT NULL;

    RETURN IFNULL(v_gpa, 0.00);
END;

-- ==================================================================
-- Fill in every gpa using the function.
-- ==================================================================
UPDATE students SET gpa = calculate_gpa(student_id);

-- ==================================================================
-- FROM LAB 5E. attendance, with its surrogate key starting at 500.
-- ==================================================================
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id    INT NOT NULL,
    attended_on   DATE,
    status        VARCHAR(10),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
) AUTO_INCREMENT = 500;
INSERT INTO attendance (student_id, attended_on, status) VALUES (1,'2026-10-05','present');
INSERT INTO attendance (student_id, attended_on, status) VALUES (2,'2026-10-05','absent');
INSERT INTO attendance (student_id, attended_on, status) VALUES (3,'2026-10-06','present');

-- ==================================================================
-- FROM LAB 5E. The BEFORE INSERT trigger. Select the whole block and run the selection.
-- ==================================================================
CREATE TRIGGER trg_attendance_before_insert
BEFORE INSERT ON attendance
FOR EACH ROW
BEGIN
    IF NEW.attended_on IS NULL THEN
        SET NEW.attended_on = CURDATE();
    END IF;
    SET NEW.status = UPPER(NEW.status);
END;

-- ==================================================================
-- FROM LAB 5E. The AFTER DELETE trigger. Select the whole block and run the selection.
-- ==================================================================
CREATE TRIGGER trg_scores_after_delete
AFTER DELETE ON test_scores
FOR EACH ROW
BEGIN
    UPDATE students
    SET gpa = calculate_gpa(OLD.student_id)
    WHERE student_id = OLD.student_id;
END;

-- ==================================================================
-- FROM LAB 5E Step 9. The row the BEFORE trigger filled in. It becomes 503.
-- ==================================================================
INSERT INTO attendance (student_id, status) VALUES (4,'present');


-- ======================================================================
-- CHECKS. These only read, so they are safe to run again any time.
-- gpa should read 85.00, 84.00, 92.33, 82.50 and 0.00.
-- attendance should show ids 500 to 503.
-- ======================================================================

SELECT * FROM students;
SELECT * FROM attendance;


-- ######################################################################
-- YOUR LAB 5F WORK STARTS BELOW THIS LINE
--
-- LABELING AND COMMENTING IS REQUIRED. It is worth a full point.
--
-- You write Steps 5, 6, 7 and 9 yourself. Step 4 is a skeleton with
-- one statement for you to write. Steps 3 and 8 are printed in the
-- handout.
-- ######################################################################


-- =================================================================
-- STEP 3. Your first procedure, list_students
--
-- Copy this one from the handout. Select the whole block and run it.
-- Then CALL it.
-- =================================================================

-- your comment goes here
-- your statements go here


-- =================================================================
-- STEP 4. A procedure with an IN parameter, student_report
--
-- Copy the skeleton from the handout and write the SELECT
-- that goes in the gap.
-- =================================================================

-- your comment goes here
-- your statements go here


-- =================================================================
-- STEP 5. Call student_report three times
-- =================================================================

-- your comment goes here
-- your statements go here


-- =================================================================
-- STEP 6. Change list_students to put the highest gpa first
--
-- Note the 1304 error, then write the DROP and the new CREATE.
-- =================================================================

-- your comment goes here
-- your statements go here


-- =================================================================
-- STEP 7. Write scores_for_test completely on your own
-- =================================================================

-- your comment goes here
-- your statements go here


-- =================================================================
-- STEP 8. Three deliberate mistakes
--
-- Put each error number and message in a comment.
-- =================================================================

-- your comment goes here
-- your statements go here


-- =================================================================
-- STEP 9. See what you have built
-- =================================================================

-- your comment goes here
-- your statements go here


-- =================================================================
-- STEP 10 and 11. Push to GitHub and submit the URL
--
-- Nothing to write here. Follow the handout.
-- =================================================================

-- your comment goes here
-- your statements go here
