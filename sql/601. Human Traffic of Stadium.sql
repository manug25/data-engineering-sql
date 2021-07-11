/*
select d.id, d.visit_date, d.people
from
(
    SELECT id, visit_date, people,
    CASE
    WHEN IFNULL(lag(people,2) over() >= 100, FALSE) AND IFNULL(lag(people,1) over() >= 100,FALSE) AND people>=100 THEN 1
    WHEN IFNULL(lag(people,1) over() >= 100, FALSE) AND IFNULL(LEAD(people,1) over() >= 100,FALSE) AND people>=100 THEN 1
    WHEN IFNULL(LEAD(people,2) over() >= 100, FALSE) AND IFNULL(LEAD(people,1) over() >= 100,FALSE) AND people>=100 THEN 1
    ELSE 0
    END as valid
    FROM stadium
) d
WHERE d.valid = 1 order by visit_date asc;
*/
select distinct t1.*
from stadium t1, stadium t2, stadium t3
where t1.people >= 100 and t2.people >= 100 and t3.people >= 100
and
(
    (t1.id - t2.id = 1 and t1.id - t3.id = 2 and t2.id - t3.id =1)  -- t1, t2, t3
    or
    (t2.id - t1.id = 1 and t2.id - t3.id = 2 and t1.id - t3.id =1) -- t2, t1, t3
    or
    (t3.id - t2.id = 1 and t2.id - t1.id =1 and t3.id - t1.id = 2) -- t3, t2, t1
)
order by t1.id
;