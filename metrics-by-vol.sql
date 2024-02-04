/*
Metrics by Volunteer

The goal of this script is to compute the number of relationships and contacts for each volunteer

Currently, the following metrics are implemented:
- number of relationships (total / self / neighbor / friend)
- number of completed surveys on the question of candidate support
*/

with

users as (

  select 
    id as id_reach_user,
    name as nm_reach_user,
    created_on as dt_joined_reach_user
  from `reach-vote`.`reach_txpatel24_share`.`users`

),

relat as (

  select 
    user_id as id_reach_user,
    relationship_type_id as id_relat_type,
    source,
    reach_id as id_reach_voter,
    voterfile_van_id as id_van_voter
  from `reach-vote`.`reach_txpatel24_share`.`relationships`
  where status = 'active'
    
),

relat_type as (

  select
    id as id_relat_type,
    name as nm_relat_type, 
    case when name = 'Self' then 1 else 0 end as ind_relat_self,
    case
      when name in ('Neighbor','Voter I canvassed') 
      then 1 else 0 end as ind_relat_neighb,
    case
      when name in ('Self','Non-supporter')
      then 1 else 0 end as ind_relat_exclude,
    case
      when name not in ('Self', 'Non-supporter','Neighbor','Voter I canvassed')
      then 1 else 0 end as ind_relat_friend
  from `reach-vote`.`reach_txpatel24_share`.`relationship_types`

),

survey_support as (

  select
    recorded_by_user_id as id_reach_user,
    reach_id as id_reach_voter,
    1 as ind_response_support
  from `reach-vote`.`reach_txpatel24_share`.`responses`
  where question_id = '5W9GPQ6G'
  qualify row_number() over (partition by recorded_by_user_id, reach_id, question_id order by updated_on desc) = 1

)

select

  nm_reach_user,
  count(distinct id_reach_voter) as n_relationships,
  sum(ind_relat_self) as n_relat_self,
  sum(ind_relat_neighb) as n_relat_neighbor,
  sum(ind_relat_friend) as n_relat_friend,
  sum(ind_response_support) as n_response_support

from

  users
  left join relat using (id_reach_user)
  left join relat_type using (id_relat_type)
  left join survey_support using (id_reach_user, id_reach_voter)

group by 1
order by 2 desc
;
