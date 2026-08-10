# Building the Ridership Dataset

A starter project for organizing the SQL work, data files, and supporting materials used to build a bike-share ridership dataset.

## Folder Guide

- `sql/` — SQL scripts for creating tables, writing queries, and building the ridership dataset.
- `data/` — Raw and cleaned data files used in the project.
- `docs/` — Project notes, assignment instructions, and reference materials.
- `output/` — Query results, exported tables, and other generated deliverables.

In this project, I built linear regression models to predict daily Citi Bike ridership from weather, calendar, and time-trend information. Before modeling, I used the cleaned daily dataset and made sure the ride date was stored as a date field. I used day-of-week dummy variables so the model could use weekday information, and I used `days_since_launch` to represent the overall growth of Citi Bike over time. I also checked that the weather columns were included correctly in the feature list. In particular, the cleaned dataset used the column names `precip_in` and `wind_speed_knots`, so I corrected the model feature list to include them.

My core model used temperature, precipitation, wind speed, the time trend, and day-of-week indicators. I split the data into 80% training data and 20% test data, using a fixed random state so the results were reproducible. The core model had a test R² of 0.7505. This means it explained about 75% of the variation in daily ridership on unseen test data. Its test MAE was about 6,987 rides, meaning that the prediction was typically off by roughly 6,987 rides per day. The test RMSE was about 8,876 rides, which showed that some days had larger prediction errors.

I examined the coefficients and found results that matched reasonable expectations. Higher temperature was associated with more rides, while precipitation and wind speed were associated with fewer rides. Sundays and Saturdays were predicted to have fewer rides than the Friday reference day. I also inspected residual plots. The residuals were not completely random over time, which suggested that the model was missing some time-related or unusual-day patterns.

For one improvement, I added `temp_f_squared` so the model could capture a curved relationship between temperature and ridership. The improved model achieved a test R² of 0.7613, a test MAE of about 6,749 rides, and a test RMSE of about 8,680 rides. The improvement was modest but consistent across all test metrics. The biggest weakness of this model is that it does not include important outside factors such as holidays, special events, transit disruptions, bike availability, or the number of active stations. To improve the model further, I would add holiday and event data along with daily information about station and bike availability.