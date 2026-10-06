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
#Saving data frame
dir.create("data", showWarnings = FALSE)
saveRDS(df, "data/tesla_sp500.rds")
write.csv(df, file = "data/tesla_sp500.csv")

beta<-lm(tesla~sp500,data=df)
print(summary(beta))

#graphs
library(ggplot2)
scatter<-ggplot(df,aes(x=sp500,y=tesla))+geom_point(color='blue',size=1,alpha=0.3)+labs(title='Daily log returns: Tesla vs S&P500',x='S&P500',y='TESLA',caption='Source: Yahoo Finance via quantmod, 2023-2025, n = 751,\n Dashed grey: beta = 1. Red: estimated Tesla beta (2.305).')+geom_smooth(method='lm',col='red')+theme_minimal()+geom_abline(linetype='dashed',col='grey',linewidth = 0.8)
ggsave("scatter_tesla_sp500.png", plot = scatter, width = 7, height = 5, dpi = 300)



