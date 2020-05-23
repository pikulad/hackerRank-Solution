SELECT CON.CONTEST_ID,
       CON.HACKER_ID,
       CON.NAME,
       SUM(TOTAL_SUBMISSIONS),
       SUM(TOTAL_ACCEPTED_SUBMISSIONS),
       SUM(TOTAL_VIEWS),
       SUM(TOTAL_UNIQUE_VIEWS)
FROM CONTESTS CON
JOIN COLLEGES COL ON CON.CONTEST_ID = COL.CONTEST_ID
JOIN CHALLENGES CHA ON COL.COLLEGE_ID = CHA.COLLEGE_ID
LEFT JOIN
  (SELECT CHALLENGE_ID,
          SUM(TOTAL_VIEWS) AS TOTAL_VIEWS,
          SUM(TOTAL_UNIQUE_VIEWS) AS TOTAL_UNIQUE_VIEWS
   FROM VIEW_STATS
   GROUP BY CHALLENGE_ID) VS ON CHA.CHALLENGE_ID = VS.CHALLENGE_ID
LEFT JOIN
  (SELECT CHALLENGE_ID,
          SUM(TOTAL_SUBMISSIONS) AS TOTAL_SUBMISSIONS,
          SUM(TOTAL_ACCEPTED_SUBMISSIONS) AS TOTAL_ACCEPTED_SUBMISSIONS
   FROM SUBMISSION_STATS
   GROUP BY CHALLENGE_ID) SS ON CHA.CHALLENGE_ID = SS.CHALLENGE_ID
GROUP BY CON.CONTEST_ID,
         CON.HACKER_ID,
         CON.NAME
HAVING SUM(TOTAL_SUBMISSIONS) != 0
OR SUM(TOTAL_ACCEPTED_SUBMISSIONS) != 0
OR SUM(TOTAL_VIEWS) != 0
OR SUM(TOTAL_UNIQUE_VIEWS) != 0
ORDER BY CONTEST_ID;