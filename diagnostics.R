library(lmtest)
library(sandwich)
library(ggplot2)

# linear regression model: Tesla returns on S&P 500 returns
df<-readRDS('data/tesla_sp500.rds')
beta<-lm(tesla~sp500,data=df) 
res<-resid(beta)
dejta<-data.frame(date=as.Date(rownames(df)),resid=res)

#graphs
rezid<-ggplot(dejta,aes(x=date,y=resid))+geom_point(color='blue',size=0.8, alpha=0.8)+geom_hline(yintercept=0,linetype='dashed')+labs(title='Residuals over time: Tesla vs S&P 500',x='Date',y='Residual (daily log returns)',caption='Source: Yahoo Finance via quantmod, 2023-2025, n = 751,\n dashed black line = zero residual')+theme_minimal()
ggsave('residuals_time.png',plot=rezid, width = 7,height = 5, dpi = 300)

#tests
bp<-bptest(beta) #Breusch-Pagan Test
dw<-dwtest(beta) #Durbin-Watson Test
rob<-coeftest(beta, vcov = vcovHC(beta, type = "HC3")) #Inference for Estimated Coefficients

print(bp)
print(dw)
print(rob)

#QQ plot
qqnorm(res,main='Normal QQ plot of residuals: Tesla vs S&P 500')
qqline(res)
#save by "Export"

