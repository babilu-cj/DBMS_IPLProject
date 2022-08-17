use ipl;

# Correcting typos in the table ipl_match

update ipl_match set MATCH_WINNER=2 where MATCH_ID=1054;
update ipl_match set MATCH_WINNER=1 where MATCH_ID=1056;
update ipl_match set MATCH_WINNER=2 where MATCH_ID=1057;
update ipl_match set MATCH_WINNER=2 where MATCH_ID=1058;


# Q. Show the percentage of wins of each bidder in the order of highest to lowest percentage.
SELECT 
    t1.BIDDER_ID,
    BIDDER_NAME,
    ROUND(COUNT(bid_status) / no_of_bids * 100, 2) WIN_PERCENTAGE
FROM
    ipl_bidder_details t1
        NATURAL JOIN
    ipl_bidding_details t2
        JOIN
    ipl_bidder_points t3 ON t1.BIDDER_ID = t3.BIDDER_ID
WHERE
    BID_STATUS = 'WON'
GROUP BY t1.BIDDER_ID
ORDER BY win_percentage DESC;


# Q. Display the number of matches conducted at each stadium with stadium name, city from the database
SELECT 
    STADIUM_NAME, CITY, COUNT(*) NO_OF_MATCHES
FROM
    ipl_match_schedule t1
        NATURAL JOIN
    ipl_stadium t2
GROUP BY STADIUM_ID
ORDER BY NO_OF_MATCHES DESC;


# Q. In a given stadium, what is the percentage of wins by a team which has won the toss?
SELECT 
    STADIUM_NAME,
    ROUND(SUM(IF(TOSS_WINNER = MATCH_WINNER, 1, 0)) / COUNT(*) * 100,
            2) TOSS_WIN_PERCENTAGE
FROM
    ipl_match_schedule t1
        JOIN
    ipl_match t2 USING (match_id)
        NATURAL JOIN
    ipl_stadium
GROUP BY STADIUM_ID
ORDER BY TOSS_WIN_PERCENTAGE DESC;


# Q. Show the total bids along with bid team and team name
SELECT 
    BID_TEAM, TEAM_NAME, COUNT(*) NO_OF_BIDS
FROM
    ipl_bidding_details
        JOIN
    ipl_team ON BID_TEAM = TEAM_ID
GROUP BY TEAM_NAME
ORDER BY NO_OF_BIDS DESC;


# Q. Show the team id who won the match as per the win details
SELECT 
    WIN_DETAILS, TEAM_ID
FROM
    ipl_match
        JOIN
    ipl_team
WHERE
    IF(match_winner = 1, team_id1, team_id2) = team_id;
    

# Q. Display total matches played, total matches won and total matches lost by team along with its team name (Total matches across the years)
SELECT 
    TEAM_NAME,
    SUM(MATCHES_PLAYED) TOTAL_MATCHES,
    SUM(MATCHES_WON) MATCHES_WON,
    SUM(MATCHES_LOST) MATCHES_LOST
FROM
    ipl_team_standings
        JOIN
    ipl_team USING (team_id)
GROUP BY TEAM_NAME
ORDER BY MATCHES_WON DESC;


# Q. Display the bowlers for Mumbai Indians team
SELECT 
    PLAYER_NAME
FROM
    ipl_team_players
        JOIN
    ipl_team USING (team_id)
        JOIN
    ipl_player USING (player_id)
WHERE
    TEAM_NAME LIKE '%Mumbai%'
        AND PLAYER_ROLE IN ('Bowler' , 'All-Rounder')
ORDER BY PLAYER_NAME;


# Q. How many all-rounders are there in each team
SELECT 
    TEAM_NAME, COUNT(*) NO_OF_ALLROUNDERS
FROM
    ipl_team_players
        JOIN
    ipl_team USING (team_id)
WHERE
    PLAYER_ROLE LIKE 'all%'
GROUP BY TEAM_NAME
ORDER BY NO_OF_ALLROUNDERS;


# Q. Display the teams with more than 4 all-rounder in descending order
SELECT 
    TEAM_NAME, COUNT(PLAYER_ROLE) NO_OF_ALLROUNDERS
FROM
    ipl_team_players
        JOIN
    ipl_team USING (team_id)
WHERE
    PLAYER_ROLE LIKE 'all%'
GROUP BY TEAM_NAME
HAVING COUNT(PLAYER_ROLE) > 4
ORDER BY NO_OF_ALLROUNDERS DESC;