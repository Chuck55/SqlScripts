select route.airline from route left join airport a 
on route.source_airport_id = a.id left join airport b
on route.destination_airport_id = b.id
where a.altitude > 10000 and b.altitude > 10000
group by route.airline;

select distinct b.source_airport_id, e.city, e.country, e.name from route A
inner join route b on a.destinationn_airport_id = b.source_airport_id inner join airport c on a.source_airport_id = c.id 
inner join airport d on b.destination_airport_id = d.id inner join airport e on e.id = b.source_airport_id where 
c.city = 'Minneapolis' and c.country = 'United States' and d.city = 'Athens' and d.country = 'Greece';

select distinct a.name from airline a inner join route b on a.id = b.airline_id inner join 
airport c on b.source_airport_id = c.id where c.city = 'Minneapolis' and c.country = 'United States' and 
a.country <> 'ALASKA';

Create view lonelyroute as
select a.source_airport, a.destination_airport from route a left join route b on a.source_airport_id = b.destination_airport_id
and b.source_airport_id = a.destination_airport_id where b.airline = null;

select destination_airport, count(destination_airport) AS howmany
from lonelyroute 
group by destination_airport 
order by howmany desc;