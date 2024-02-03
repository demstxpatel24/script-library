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
