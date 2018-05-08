connect to cs348

-- QUESTION 1
SELECT DISTINCT S.snum,S.sname \
FROM student S \
WHERE (S.year = 2) \
     AND EXISTS ( \
         SELECT * \
         FROM mark M, mark M1 \
         WHERE (M.grade < 65) \
         AND M.snum = S.snum \
         AND M.cnum LIKE 'CS1__' \
         AND (M1.grade < 65) \
         AND M1.snum = S.snum \
         AND M1.cnum LIKE 'CS1__')


-- QUESTION 2
SELECT DISTINCT P.pnum,P.pname \
FROM professor P \
WHERE (P.dept != 'PM') \
     AND EXISTS ( \
         SELECT * \
         FROM class C \
         WHERE (C.cnum = 'CS245') \
         AND C.pnum = P.pnum \
         AND NOT EXISTS ( \
             SELECT * \
             FROM mark M \
             WHERE M.cnum = C.cnum \
             AND M.section = C.section \
             AND M.term = C.term ) )



--QUESTION 3 --  NEEDS fix
SELECT DISTINCT S.snum,S.sname,S.year \
FROM student S \
WHERE EXISTS ( \
     SELECT * \
     FROM  enrollment E, mark M \
     WHERE  E.cnum = M.cnum \
         AND E.snum = S.snum \
         AND M.cnum = 'CS240' \
         AND E.term = M.term \
         AND E.section = M.section \
         AND EXISTS ( \
              SELECT * \
              FROM mark M1 \
              WHERE M1.cnum = 'CS240' \ 
              AND M1.grade BETWEEN M.grade AND (M.grade + 5 ) ) )



-- QUESTION 4
SELECT DISTINCT S.snum,S.sname \
FROM student S \
WHERE (S.year > 2) \
     AND EXISTS ( \
         SELECT * \
         FROM mark M \
         WHERE M.snum = S.snum \
         AND M.cnum LIKE 'CS%' \
         AND NOT EXISTS ( \
            SELECT * \
            FROM professor P \
            WHERE M.grade < 85 \
            AND P.dept != 'CO' ) )


-- QUESTION 5 -- ASSUMING THE TIME is 24 Hour format 
SELECT DISTINCT P.dept \
FROM professor P \
WHERE EXISTS ( \
     SELECT * \
     FROM class C \
     where C.pnum = P.pnum \
     AND EXISTS ( \
        SELECT * \
        FROM schedule S \
        WHERE ( \
            (S.day = 'Monday' \
             AND (S.time LIKE "0%" \
             OR S.time LIKE "10%"  \
             OR S.time LIKE "11%") ) \
         OR \
           (S.day = 'FRIDAY' \
             AND (S.time LIKE "1%" \
             AND S.time != "11:00"  \
             AND S.time != "11:30"  \
             AND S.time != "12:00" ) ) ) ) )
        


-- QUESTION 6

SELECT DISTINCT \
   SUM(case when p.dept = 'PM' then 1 else 0 end) / count (*) as "Ratio of Profssors" \
FROM professor P \
WHERE ( P.dept = 'PM' OR P.dept = 'CS' ) \
AND EXISTS ( \
      SELECT * \
      FROM class C, mark M \
      WHERE C.pnum = P.pnum \
      AND C.cnum = M.cnum \
      AND C.section = M.section \
      AND C.term = M.term \
      AND M.grade < 65 )



-- QUESTION 7
SELECT DISTINCT P.dept, C.cnum, C.term, ( SELECT COUNT(*) \
                                          FROM enrollment E \
                                          WHERE E.cnum = C.cnum \
                                          AND E.term = C.term ) AS "ENROLL COUNT" \
FROM professor P, class C \
WHERE EXISTS ( \
      SELECT * \
      FROM professor P1, class C1 \
      WHERE C1.pnum = P1.pnum \
      AND (P1.dept = "CS" OR P1.dept = "PM") )
      ORDER BY "ENROLL COUNT" DESC

-- QUESTION 8

SELECT DISTINCT (COUNT(*)/(SELECT COUNT(*) FROM professor WHERE dept = 'CS')) * 100 AS "Percent CS professor not teaching" \
FROM professor P \
WHERE P.dept = 'CS' \
AND NOT EXISTS ( \
         SELECT * \
         FROM class C, class C1 \
         WHERE C.pnum = P.pnum \
         AND C1.pnum = P.pnum \
         AND C.term = C1.term \
         AND C.pnum != C1.pnum )

