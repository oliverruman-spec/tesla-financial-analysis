# Beta of Tesla relative to the S&P 500

The first part of the project estimates the beta of Tesla (TSLA) relative to the S&P 500 using daily log returns from 2023 to 2025. The analysis is done in R.

## Data

- Source: Yahoo Finance, downloaded with the `quantmod` package on 5 October 2026
- Period: January 2023 to December 2025
- Observations: 751 daily log returns, computed from adjusted close prices
- The first observation was removed because a return is not defined for it
- Data files (in data folder): `data/tesla_sp500.csv` and `data/tesla_sp500.rds`

The first column of the CSV file contains the date. The other two columns are the daily log returns of Tesla and the S&P 500.

## Method

Beta is estimated with a simple linear regression of Tesla returns on S&P 500 returns:

`tesla = alpha + beta * sp500 + error`

- `alpha` is the intercept: the average Tesla return on a day when the S&P 500 return is zero.
- `beta` is the slope: how much the Tesla return changes on average when the S&P 500 return changes by one unit.
- `error` is the part of the Tesla return that the market does not explain.

## Results

- Beta: 2.305 (standard error 0.118, 95% confidence interval 2.07 to 2.54)
- Alpha: 0.0001 (not statistically significant, p = 0.92)
- R-squared: 0.34

![Scatter plot of Tesla vs S&P 500 daily log returns](scatter_tesla_sp500.png)

The dashed grey line has a slope of 1 (the market). The red line is the estimated regression line for Tesla.

## Conclusion

Tesla amplifies market movements: when the S&P 500 moves by 1%, Tesla moves by about 2.3% on average. However, the market explains only about one third of Tesla's daily variation, so most of its movement is specific to the company.

## Rolling beta

The beta in the previous section is a single number for the whole period. To see whether it is stable over time, I estimated it again in a moving window of 120 trading days (about six months). For each day, the regression of Tesla returns on S&P 500 returns uses only the previous 120 days. The window then moves forward by one day.

- Window: 120 trading days
- Number of estimates: 632 (the first 119 days have no value because the first window needs 120 observations)
- First value: 27 June 2023 (beta 2.12)
- Minimum: 1.34, maximum: 3.13, median: 2.34

![120-day rolling beta of Tesla vs S&P 500](rolling_beta_tesla.png)

The dashed red line is the overall beta (2.305). The dotted line is beta = 1, which is a stock that moves one-for-one with the market.

The rolling beta changes a lot over time. It is close to the overall value in the second half of 2023, falls to its lowest level in 2024, and rises above 3 in early 2025. It never falls below 1, so Tesla was more sensitive to the market than the index itself in every window. This shows that a single beta for the whole period hides large changes in how Tesla reacts to the market.

Two limitations should be kept in mind. Neighbouring windows overlap, so neighbouring points are not independent and the line looks smoother than the real uncertainty. Sudden jumps can also be caused by one extreme day entering or leaving the window, not by a real change in behaviour.
