library(quantmod)
getSymbols('TSLA',src='yahoo', from='2023-01-01', to='2026-01-01')
getSymbols('^GSPC',src='yahoo', from='2023-01-01', to='2026-01-01')
tesla<-Ad(TSLA)
sp500<-Ad(GSPC)
tesla_return<-dailyReturn(tesla,type='log')
sp500_return<-dailyReturn(sp500,type='log')

df<-data.frame(tesla=tesla_return,sp500=sp500_return)
df<-df[-1,]
colnames(df)<-c('tesla','sp500')
#saving data frame
#dir.create("data", showWarnings = FALSE)
#saveRDS(df, "data/tesla_sp500.rds")
#write.csv(df, file = "data/tesla_sp500.csv")

beta<-lm(tesla~sp500,data=df)
print(summary(beta))

#graphs of daily log returns
library(ggplot2)
scatter<-ggplot(df,aes(x=sp500,y=tesla))+geom_point(color='blue',size=1,alpha=0.3)+labs(title='Daily log returns: Tesla vs S&P500',x='S&P500',y='TESLA',caption='Source: Yahoo Finance via quantmod, 2023-2025, n = 751,\n Dashed grey: beta = 1. Red: estimated Tesla beta (2.305).')+geom_smooth(method='lm',col='red')+theme_minimal()+geom_abline(linetype='dashed',col='grey',linewidth = 0.8)
ggsave('scatter_tesla_sp500.png', plot = scatter, width = 7, height = 5, dpi = 300)

#rolling beta
library(roll)
df_dates<-as.Date(rownames(df))
rb<-roll_lm(df$sp500,df$tesla,width=120)
print(summary(rb))
slope<-rb$coefficients[,'x1'] 
print(summary(slope))

dff<-data.frame(date=df_dates,beta=slope)
dff<-na.omit(dff)

rbeta<-ggplot(dff,aes(x=date,y=beta))+geom_hline(yintercept=1,linetype='dotted',col='grey50',linewidth=1)+theme_minimal()+geom_line(color='blue')+labs(title='120-day rolling beta: Tesla vs S&P 500',x='Date',y='Beta',caption='Source: Yahoo Finance via quantmod, 2023-2025. Window: 120 trading days (windows overlap).\n Dashed red: overall beta (2.305). Dotted grey: beta = 1 (market).')+geom_hline(yintercept=2.305,col='red',linetype='dashed')
ggsave('rolling_beta_tesla.png', plot = rbeta,width = 7, height = 5, dpi = 300)