-- Self Join Tutorials

-- 1 How many stops are in the database.
SELECT COUNT(id) FROM stops

-- 2 Find the id value for the stop 'Craiglockhart'
SELECT id FROM stops WHERE name = 'Craiglockhart'

-- 3 Give the id and the name for the stops on the '4' 'LRT' service.
SELECT id, name FROM stops JOIN route ON  id = stop 
  WHERE num = 4 AND company = 'LRT';

-- 4 The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). Run the query and notice the two services that link these stops have a count of 2. Add a HAVING clause to restrict the output to these two routes.
SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*) = 2

-- 5 Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, without changing routes. Change the query so that it shows the services from Craiglockhart to London Road
SELECT a.company, a.num, a.stop, b.stop 
FROM route a 
JOIN route b ON (a.company=b.company AND a.num=b.num)
  WHERE a.stop=53 AND b.stop = 149

-- 6 Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. If you are tired of these places try 'Fairmilehead' against 'Tollcross'
SELECT a.company, a.num, stopa.name, stopb.name FROM route a JOIN route b ON (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
    WHERE stopa.name='Craiglockhart' AND stopb.name = 'London Road';

-- 7 Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
SELECT DISTINCT a.company, a.num FROM route a JOIN route b ON (a.company=b.company AND a.num=b.num)
  WHERE a.stop=115 AND b.stop = 137;

-- 8 Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
SELECT a.company, a.num FROM route a JOIN route b ON (a.company = b.company AND a.num = b.num) JOIN stops stopa ON (a.stop = stopa.id) JOIN stops stopb ON (b.stop = stopb.id) 
  WHERE stopa.name ='Craiglockhart' AND stopb.name = 'Tollcross';

-- 9 Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.
SELECT stopb.name, a.company, a.num
  FROM route a JOIN route b ON (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
    WHERE stopa.name='Craiglockhart';
-- 10 Find the routes involving two buses that can go from Craiglockhart to Lochend. Show the bus no. and company for the first bus, the name of the stop for the transfer, and the bus no. and company for the second bus.
SELECT DISTINCT a.num, a.company, name, b.num, b.company
FROM stops
JOIN route a ON a.stop = id
JOIN route b ON b.stop = id
WHERE EXISTS(SELECT 1
             FROM route c 
             JOIN stops x ON c.stop = x.id
             WHERE x.name = 'Craiglockhart' AND c.num = a.num AND c.company = a.company)
AND EXISTS(SELECT 1
           FROM route d 
           JOIN stops y ON d.stop = y.id
           WHERE y.name = 'Lochend' AND d.num = b.num AND d.company = b.company);