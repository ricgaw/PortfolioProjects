select *
from gamessales.gamessales

-- Total units sold. How many games the gaming industry sold by year?
select name, total_shipped
from gamessales.gamessales
order by 2 desc

-- - Total units sold per game order by publisher. Which publisher sells most?
select name, publisher, total_shipped
from gamessales.gamessales
group by name
order by publisher, total_shipped desc

-- Total units sold by platform. Which platform is more profitable?
select platform, Round(sum(total_shipped),2)
from gamessales.gamessales
group by platform
order by sum(total_shipped) desc

-- Total shipped by year. How many games was sold each year?
select Round(sum(Total_Shipped), 2), year
from gamessales.gamessales
group by year
order by sum(Total_Shipped) desc


-- top 10 games with better critic score and user score. Do critic and user like the same?
select name, critic_score
from gamessales.gamessales
order by critic_score desc
limit 10

select name, User_Score
from gamessales.gamessales
order by User_Score desc
limit 10

-- Games classified by critic score 
select name, critic_score, 
case
	when critic_score > 8.0 then "Great"
    when critic_score > 6.0 then "Good"
    when critic_score > 4.0 then "Average"
    when critic_score > 2.0 then "Bad"
	else "Worst"
end as ScoreCategory
from gamessales.gamessales
order by critic_score desc

-- Does the Critic Score or User Score influence in shipments?
select name, critic_score, Total_Shipped
from gamessales.gamessales
order by critic_score desc
limit 10

select name, User_Score, Total_Shipped
from gamessales.gamessales
order by User_Score desc
limit 10