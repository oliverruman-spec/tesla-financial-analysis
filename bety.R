getSymbols('TSLA',src='yahoo', from='2023-01-01', to='2026-01-01')
getSymbols('^GSPC',src='yahoo', from='2023-01-01', to='2026-01-01')
tesla<-Ad(TSLA)
sp500<-Ad(GSPC)
tesla_return<-dailyReturn(tesla,type='log')
sp500_return<-dailyReturn(sp500,type='log')

df<-data.frame(tesla=tesla_return,sp500=sp500_return)
colnames(df)<-c('tesla','sp500')

beta<-lm(tesla~sp500,data=df)
print(summary(beta))

