-- USER TABLE VALIDATION --

-- validate that users table is distinct by id
-- this is TRUE
select count(distinct id), count(1)
from `reach-vote`.`reach_txpatel24_share`.`users`;

-- RELATIONSHIP TABLE VALIDATION --

-- validate that relationships table is distinct by user id x relationship id
-- this is NOT TRUE
select count(distinct user_id || ' ' || reach_id), count(1)
from `reach-vote`.`reach_txpatel24_share`.`relationships`;

-- when are relationships not uniquely identified by user id x relationship id?
-- observe that this happens when some have the status 'archived'
select *
from `reach-vote`.`reach_txpatel24_share`.`relationships`
qualify count(1) over (partition by user_id, reach_id) > 1;

-- validate that relationships table is distinct by user id x relationship id for *active* relationships
-- this is TRUE
select count(distinct user_id || ' ' || reach_id), count(1)
from `reach-vote`.`reach_txpatel24_share`.`relationships`
where status = 'active';

-- RELATIONSHIP_TYPES VALIDATION --

-- validate that relationship_types is a lookup table and distinct by either id or name
-- this is TRUE
select count(distinct id), count(distinct name), count(1)
from `reach-vote`.`reach_txpatel24_share`.`relationship_types`;

-- see all options for names
select distinct name
from `reach-vote`.`reach_txpatel24_share`.`relationship_types`;

-- QUESTIONS TABLE VALIDATION --

-- validate that questions table is one row per distinct question
-- this is TRUE
select count(1), count(distinct id), count(distinct name), count(distinct display_name)
from `reach-vote`.`reach_txpatel24_share`.`questions`;

-- see all options for questions 
-- the ID for the primary question (support) is 5W9GPQ6G
select *
from `reach-vote`.`reach_txpatel24_share`.`questions`;

-- RESPONSES TABLE VALIDATION --

-- validate that responses are unique to a question x user x voter combo
-- this is NOT TRUE
select count(1), count(distinct recorded_by_user_id || ' ' || reach_id || ' ' || question_id)
from `reach-vote`.`reach_txpatel24_share`.`responses`;

-- when are responses not uniquely identified by user id x voter id x question id?
-- observe that this happens when someone perhaps changes their answer with a different updated-on date, 
-- so we would need to dedupe on that
select *
from `reach-vote`.`reach_txpatel24_share`.`responses`
qualify count(1) over (partition by recorded_by_user_id, reach_id, question_id) > 1
order by recorded_by_user_id, reach_id, question_id, updated_on;


