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

survey_plan as (

  select
    recorded_by_user_id as id_reach_user,
    reach_id as id_reach_voter,
    1 as ind_response_plan
  from 
    `reach-vote.reach_txpatel24_share.responses` as res
    inner join 
    `reach-vote.reach_txpatel24_share.question_choice_response_associations` as res_assoc
    on res.id = res_assoc.response_id
  where
    choice_id in (
    '5e00ff99-e01d-40f6-8a0d-878af4d6aff2',
    '693049d0-f3a8-47f4-af87-b450cf08403a',
    '5e00ff99-e01d-40f6-8a0d-878af4d6aff2')
  qualify row_number() over (partition by recorded_by_user_id, reach_id, question_id order by res.updated_on desc) = 1

)

select

  nm_reach_user,
  count(distinct id_reach_voter) as n_relationships,
  sum(ind_relat_self) as n_relat_self,
  sum(ind_relat_neighb) as n_relat_neighbor,
  sum(ind_relat_friend) as n_relat_friend,
  sum(ind_response_plan) as n_response_plan

from

  users
  left join relat using (id_reach_user)
  left join relat_type using (id_relat_type)
  left join survey_plan using (id_reach_user, id_reach_voter)

group by 1
order by 2 desc
;
