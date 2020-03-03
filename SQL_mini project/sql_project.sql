
The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

select facid, name, membercost, guestcost
from Facilities where membercost != 0 
GROUP BY 2
ORDER BY 2



/* Q2: How many facilities do not charge a fee to members? */

SELECT *
FROM Facilities
WHERE membercost =0
LIMIT 0 , 30

---Finding the count for the above query

select count(*) 
FROM Facilities 
WHERE membercost = 0
LIMIT 0,30



/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

select facid,name,membercost,monthlymaintenance
FROM Facilities where membercost < (0.2 * monthlymaintenance)


/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

select * 
FROM Facilities 
where facid = 1 or facid =5


/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

select name, monthlymaintenance,
case
    when (monthlymaintenance > 100 )
    THEN 'Expensive' 
    ELSE 'Cheap' END as cost
FROM Facilities

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

select firstname,
       surname,
       max(joindate) as "recent_singup"      
from Members


/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */


SELECT  DISTINCT me.surname AS Last_name,
         me.firstname as Name,
        fc.name as Facility

FROM Members me 
JOIN Bookings bk on bk.memid = me.memid
JOIN Facilities fc on fc.facid = bk.facid
WHERE fc.name LIKE 'Tennis Court%'
order by 1


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT CONCAT(me.surname,' ',me.firstname) AS Full_name,
fc.name as Facility,
CASE 
WHEN fc.membercost=0 THEN bk.slots*fc.guestcost  
ELSE bk.slots*fc.membercost END as cost 
FROM Members me
JOIN Bookings bk ON bk.memid = me.memid
JOIN Facilities fc ON fc.facid = bk.facid
WHERE bk.starttime LIKE '2012-09-14%'
AND (bk.memid=0 AND (fc.guestcost * bk.slots >30)
OR (bk.memid!=0 AND fc.membercost * bk.slots >30))
ORDER BY 3 DESC

/* Q9: This time, produce the same result as in Q8, but using a subquery. */


SELECT * 
FROM
(
SELECT CONCAT(me.surname,' ',me.firstname) AS Full_name,
fc.name as Facility,
CASE 
WHEN me.memid=0 THEN bk.slots*fc.guestcost  
ELSE bk.slots*fc.membercost END as cost 
FROM Members me
JOIN Bookings bk ON bk.memid = me.memid
JOIN Facilities fc ON fc.facid = bk.facid
WHERE bk.starttime LIKE '2012-09-14%'

) sub
where cost > 30
ORDER by 3 DESC


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */


select sub1.Facility,sub1.Revenue
FROM
(
select sub.Facility,sum(sub.cost)  as Revenue
from (
select fc.name as Facility,
case 
when bk.memid = 0 then bk.slots*fc.guestcost
else bk.slots*fc.membercost END as cost
from Members me 
join Bookings bk on bk.memid = me.memid
join Facilities fc on fc.facid = bk.facid
) sub
group by sub.Facility
order by Revenue DESC
)sub1
where Revenue > 1000

