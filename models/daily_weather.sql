with daily_weather AS
(
    select  
    DATE(TIME) AS daily_weather,
    weather,
    temp,
    pressure,
    humidity,
    clouds
    from
    {{ source('demo', 'weather') }}

),

daily_weather_agg AS (

    select  
    weather,
    daily_weather,
    round(avg(temp),2) AS avg_temp,
    round(avg(pressure),2) AS avg_pressure,
    round(avg(humidity),2) AS avg_humidity,
    round(avg(clouds),2) AS avg_clouds
    --count(weather) ,
   -- ROW_NUMBER() OVER (PARTITION BY daily_weather ORDER BY count(weather) DESC) AS RN
    from
    daily_weather
    group by weather,daily_weather
    qualify ROW_NUMBER() OVER (PARTITION BY daily_weather ORDER BY count(weather) DESC) = 1
)
select * from daily_weather_agg --WHERE RN=1