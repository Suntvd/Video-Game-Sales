-- The ten best-selling video games

SELECT *
FROM game_sales
ORDER BY games_sold desc
LIMIT 10

-- Missing review scores

SELECT count(g.game)
FROM game_sales g LEFT JOIN reviews r
ON g.game = r.game
WHERE user_score IS NULL AND critic_score IS NULL

-- Years that video game critics loved

SELECT year, ROUND(avg(critic_score), 2) as avg_critic_score
FROM game_sales gs INNER JOIN reviews r
ON gs.game = r.game
GROUP BY year
ORDER BY 2 DESC
LIMIT 10

-- Was 1982 really that great?

SELECT g.year ,COUNT(g.game) as num_games, ROUND(AVG(r.critic_score),2) AS avg_critic_score
FROM game_sales g INNER JOIN reviews r
ON g.game = r.game
GROUP BY g.year
HAVING COUNT(g.game) > 4
ORDER BY 3 DESC
LIMIT 10

-- Years that dropped off the critics' favorites list

SELECT year, avg_critic_score
FROM top_critic_years
EXCEPT
SELECT year, avg_critic_score
FROM top_critic_years_more_than_four_games
ORDER BY 2 DESC

-- Years video game players loved

SELECT g.year, COUNT(g.game) AS num_games, ROUND(AVG(r.user_score),2) AS avg_user_score
FROM game_sales g
INNER JOIN reviews r
ON g.game = r.game
GROUP BY g.year
HAVING COUNT(g.game) > 4
ORDER BY avg_user_score DESC
LIMIT 10

-- Years that both players and critics loved

SELECT year
FROM top_critic_years_more_than_four_games
INTERSECT
SELECT year
FROM top_user_years_more_than_four_games

-- Sales in the best video game years

SELECT year, sum(games_sold) as total_games_sold
FROM game_sales
WHERE year in (SELECT year
                FROM top_critic_years_more_than_four_games
                INTERSECT
                SELECT year
                FROM top_user_years_more_than_four_games)
GROUP BY year
ORDER BY total_games_sold DESC
