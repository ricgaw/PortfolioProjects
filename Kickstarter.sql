SELECT * FROM kickstarter.campaign;

SELECT *
FROM kickstarter.campaign C
JOIN kickstarter.sub_category sc on sc.id = c.sub_category_id
join kickstarter.category cat on cat.id = sc.category_id
JOIN kickstarter.currency cur on cur.id = c.currency_id
JOIN kickstarter.country cou on cou.id = c.country_id

-- Are the goals for dollars raised significantly different between campaigns that are successful and unsuccessful?
select outcome, count(outcome) as OutcomeCount, round(avg(goal), 2) as GoalAverage, round(sum(goal)) as TotalGoal, round(sum(pledged)) as TotalPledged, sum(backers) as TotalBackers
from kickstarter.campaign
group by outcome
order by TotalGoal desc

-- What are the top/bottom 3 categories with the most backers? What are the top/bottom 3 subcategories by backers?	
-- Category with more backers
SELECT cat.name as CategoryName, sum(c.backers) as TotalBackers
FROM kickstarter.campaign C
JOIN kickstarter.sub_category sc on sc.id = c.sub_category_id
join kickstarter.category cat on cat.id = sc.category_id
group by cat.name
order by sum(c.backers) desc 
limit 3

-- Subcategory with more backers
SELECT sc.name as SubcategoryName, sum(c.backers) as TotalBackers
FROM kickstarter.campaign C
JOIN kickstarter.sub_category sc on sc.id = c.sub_category_id
join kickstarter.category cat on cat.id = sc.category_id
group by sc.name
order by sum(c.backers) desc 
limit 3

-- Category with less backers
SELECT cat.name as CategoryName, sum(c.backers) as TotalBackers
FROM kickstarter.campaign C
JOIN kickstarter.sub_category sc on sc.id = c.sub_category_id
join kickstarter.category cat on cat.id = sc.category_id
group by cat.name
order by sum(c.backers) asc
limit 3


-- Subcategory with less backers
SELECT sc.name as SubcategoryName, sum(c.backers) as TotalBackers
FROM kickstarter.campaign C
JOIN kickstarter.sub_category sc on sc.id = c.sub_category_id
join kickstarter.category cat on cat.id = sc.category_id
group by sc.name
order by sum(c.backers) asc
limit 3



-- What are the top/bottom 3 subcategories that have raised the most money?
-- Category that raised more money
SELECT cat.name as CategoryName, round(sum(c.pledged),2) as MoneyRaised
FROM kickstarter.campaign C
JOIN kickstarter.sub_category sc on sc.id = c.sub_category_id
join kickstarter.category cat on cat.id = sc.category_id
group by cat.name
order by round(sum(c.pledged),2) desc 
limit 3

-- Category that raised less money
SELECT cat.name as CategoryName, round(sum(c.pledged),2) as MoneyRaised
FROM kickstarter.campaign C
JOIN kickstarter.sub_category sc on sc.id = c.sub_category_id
join kickstarter.category cat on cat.id = sc.category_id
group by cat.name
order by round(sum(c.pledged),2) asc
limit 3

-- Subcategory that raised less money
SELECT sc.name as SubcategoryName, round(sum(c.pledged),2) as MoneyRaised
FROM kickstarter.campaign C
JOIN kickstarter.sub_category sc on sc.id = c.sub_category_id
join kickstarter.category cat on cat.id = sc.category_id
group by sc.name
order by round(sum(c.pledged),2) asc
limit 3

-- Subcategory that raised more money
SELECT sc.name as SubcategoryName, round(sum(c.pledged),2) as MoneyRaised
FROM kickstarter.campaign C
JOIN kickstarter.sub_category sc on sc.id = c.sub_category_id
join kickstarter.category cat on cat.id = sc.category_id
group by sc.name
order by round(sum(c.pledged),2) desc
limit 3


-- What was the amount the most successful board game company raised? How many backers did they have?
-- The most successful board game is Gloomhaven (Second Printing) raising $3999795.77 from 40642 backers.

SELECT c.name, cat.name as Category, sc.name as SubCategory, c.goal as Goal, c.pledged, cur.name as Currency, c.backers as Backers, c.Outcome as Outcome
FROM kickstarter.campaign C
JOIN kickstarter.sub_category sc on sc.id = c.sub_category_id
JOIN kickstarter.category cat on cat.id = sc.category_id
JOIN kickstarter.currency cur on cur.id = c.currency_id
WHERE c.outcome = 'successful' and sc.name = 'Tabletop Games'
ORDER BY c.pledged desc
limit 5


-- Rank the top three countries with the most successful campaigns in terms of dollars (total amount pledged), and in terms of the number of campaigns backed.
-- USA, Great Britain, and Canada are the countries with most successfull campaigns in terms of dollars. In terms of campaigns backed USA, Great Britain, and Australia are the top three.

select cou.name as Country, round(sum(c.pledged), 2) as TotalAmountPledged, sum(c.backers) as TotalBackers
FROM kickstarter.campaign C
JOIN kickstarter.sub_category sc on sc.id = c.sub_category_id
join kickstarter.category cat on cat.id = sc.category_id
JOIN kickstarter.currency cur on cur.id = c.currency_id
JOIN kickstarter.country cou on cou.id = c.country_id
where c.outcome = 'Successful'
group by cou.name
order by round(sum(c.pledged), 2) desc
limit 5


-- Do longer, or shorter campaigns tend to raise more money? Why?

select round(avg(goal), 2) as GoalAverage, round(sum(goal)) as TotalGoal, round(sum(pledged)) as TotalPledged, avg(DATEDIFF(c.deadline, c.launched)) as LengthAVG,
case
	WHEN DATEDIFF(c.deadline, c.launched) < 30 THEN 'Shorter'
    WHEN DATEDIFF(c.deadline, c.launched) < 60 THEN 'Medium'
    Else 'Long'
	end as LengthCategory
from kickstarter.campaign c 
JOIN kickstarter.sub_category sc on sc.id = c.sub_category_id
join kickstarter.category cat on cat.id = sc.category_id
JOIN kickstarter.currency cur on cur.id = c.currency_id
JOIN kickstarter.country cou on cou.id = c.country_id
group by lengthcategory
order by TotalPledged desc
