-- 1. Management Wants to see all the users that did not login in the past 5 months

-- METHOD 1

SELECT distinct(user_id) 
FROM Logins
WHERE user_id NOT IN (
SELECT distinct(user_id)
FROM Logins
WHERE login_date BETWEEN CURRENT_DATE - INTERVAL '5 MONTHS' AND CURRENT_DATE)

-- METHOD 2

with cte1 as (
SELECT distinct(user_id)
FROM Logins
WHERE login_date BETWEEN CURRENT_DATE - INTERVAL '5 MONTHS' AND CURRENT_DATE)

SELECT u.user_id
FROM Users u
LEFT JOIN cte1 c
ON u.user_id = c.user_id
WHERE c.user_id IS NULL

-----------------------------------------------------------------------------------------------------------------------------------

-- 2. For the business units’ quarterly analysis, calculate how many users and how many sessions were at each quarter order by quarter from newest to oldest.
-- Return: first day of the quarter, user_cnt, session_cnt.

SELECT count(DISTINCT user_id) as user_cnt, count(session_id) as session_cnt, DATETRUNC(quarter, login_timestamp) as quarter_start_date
FROM logins
GROUP BY DATETRUNC(quarter, login_timestamp)

-----------------------------------------------------------------------------------------------------------------------------------

-- 3. Display user id's that log-in in January 2024 and did not log-in on Novemeber 2023.

with jan_login_users as(
   SELECT user_id
   FROM logins
   WHERE date(login_timestamp) BETWEEN '2024-01-01' AND '2024-01-31'
),
 
nov_login_users as (
   SELECT user_id
   FROM logins
   WHERE date(login_timestamp) BETWEEN '2023-11-01' AND '2023-11-31'
)

SELECT jan.user_id
FROM jan_login_users as jan
LEFT JOIN nov_login_users as nov
ON jan.user_id = nov.user_id
WHERE nov.user_id IS NULL

-----------------------------------------------------------------------------------------------------------------------------------

-- 4. Add to the query from 2 the percent change in session from last quarter
-- Return: first day of the quarter, session_cnt, session_cnt_prev, session_pct_change

WTIH cte1 as (
SELECT count(DISTINCT user_id) as user_cnt, count(session_id) as session_cnt, DATETRUNC(quarter, login_timestamp) as quarter_start_date
FROM logins
GROUP BY DATETRUNC(quarter, login_timestamp)
),

cte2 as (
SELECT quarter_start_date, IFNULL(lag(session_cnt) over (order by quarter_start_date), 0) as prev_qtr_session_cnt, session_cnt
FROM cte1
)

SELECT *, session_cnt - prev_qtr_session_cnt / prev_qtr_session_cnt as session_pct_change
FROM cte2

-----------------------------------------------------------------------------------------------------------------------------------

-- 5. Highest session score for each day.

with cte1 as (	
 SELECT user_id, sum(session_score) as session_score, date(login_timestamp) as login_date
 FROM Logins
 GROUP BY user_id, date(login_timestamp)
)

SELECT t1.user_id
FROM
(SELECT *, rank() over (PARTITON BY login_date ORDER BY session_score) as rn
FROM cte1) as t1
WHERE t1.rn = 1

-----------------------------------------------------------------------------------------------------------------------------------

-- 6. To identify our best users - return the users that had a session on every single day since there first login.
-- Return :- user_id 

with cte1 as (
SELECT user_id, CURRENT_DATE - min(date(login_date)) as no_of_login_req, count(DISITNCT(date(login_date))) as logins
FROM Logins
GROUP BY user_id
)

SELECT user_id
FROM cte1 
WHERE no_of_login_req = logins

-----------------------------------------------------------------------------------------------------------------------------------

-- 7. On what dates there were no Log-in at all

with RECURSIVE cte as (
   SELECT min(date(login_date)) as date
   FROM Logins
   UNION ALL 
   SELECT date + 1 as date
   FROM recursive_cte
   WHERE date < CURRENT_DATE
)

SELECT t1.date
FROM recursive_cte t1
LEFT JOIN Logins t2
ON t1.date = t2.login_date
WHERE t2.login_date IS NULL





















