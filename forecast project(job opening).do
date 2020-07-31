generate time=tm(2000m12)+_n-1
format time %tm
tsset time
rename FinanialActivitiesJO opening
reg opening time
predict p
tsline opening p, title("Job Openings Trend")
label variable opening "job openings (%)"
graph rename job_openings
predict e, residuals
tsline e, title("Residuals")
graph rename residuals

ac opening,title("Autoregression")
graph rename auto

tsappend, add(12)
gen m = month(dofm(time))
regress opening b12.m
predict s
tsline s, title("Seasonal")
graph rename season
predict e2, residuals
tsline e2,title("seasonal residuals")
graph rename sea_res

reg opening L(1/1).opening if time>=tm(2001m10)
estimates store ar1
reg opening L(1/2).opening if time>=tm(2001m10)
estimates store ar2
reg opening L(1/3).opening if time>=tm(2001m10)
estimates store ar3
reg opening L(1/4).opening if time>=tm(2001m10)
estimates store ar4
reg opening L(1/5).opening if time>=tm(2001m10)
estimates store ar5
reg opening L(1/6).opening if time>=tm(2001m10)
estimates store ar6
reg opening L(1/7).opening if time>=tm(2001m10)
estimates store ar7
reg opening L(1/8).opening if time>=tm(2001m10)
estimates store ar8
reg opening L(1/9).opening if time>=tm(2001m10)
estimates store ar9
reg opening L(1/10).opening if time>=tm(2001m10)
estimates store ar10
estimates stats ar1 ar2 ar3 ar4 ar5 ar6 ar7 ar8 ar9 ar10

reg opening time L(1/9).opening b12.m
predict u, residuals
tsline u, title("improving residuals")
graph rename imp_res

reg opening time b12.m L(1/9).opening
predict y1
predict sf1,stdf
gen y1L=y1-1.645*sf1
gen y1U=y1+1.645*sf1
reg opening time b12.m L(2/10).opening
predict y2
predict sf2,stdf
gen y2L=y2-1.645*sf2
gen y2U=y2+1.645*sf2
reg opening time b12.m L(3/11).opening
predict y3
predict sf3,stdf
gen y3L=y3-1.645*sf3
gen y3U=y3+1.645*sf3
reg opening time b12.m L(4/12).opening
predict y4
predict sf4,stdf
gen y4L=y4-1.645*sf4
gen y4U=y4+1.645*sf4
reg opening time b12.m L(5/13).opening
predict y5
predict sf5,stdf
gen y5L=y5-1.645*sf5
gen y5U=y5+1.645*sf5
reg opening time b12.m L(6/14).opening
predict y6
predict sf6,stdf
gen y6L=y6-1.645*sf6
gen y6U=y6+1.645*sf6
reg opening time b12.m L(7/15).opening
predict y7
predict sf7,stdf
gen y7L=y7-1.645*sf7
gen y7U=y7+1.645*sf7
reg opening time b12.m L(8/16).opening
predict y8
predict sf8,stdf
gen y8L=y8-1.645*sf8
gen y8U=y8+1.645*sf8
reg opening time b12.m L(9/17).opening
predict y9
predict sf9,stdf
gen y9L=y9-1.645*sf9
gen y9U=y9+1.645*sf9
reg opening time b12.m L(10/18).opening
predict y10
predict sf10,stdf
gen y10L=y10-1.645*sf10
gen y10U=y10+1.645*sf10
reg opening time b12.m L(11/19).opening
predict y11
predict sf11,stdf
gen y11L=y11-1.645*sf11
gen y11U=y11+1.645*sf11
reg opening time b12.m L(12/20).opening
predict y12
predict sf12,stdf
gen y12L=y12-1.645*sf12
gen y12U=y12+1.645*sf12
egen pl=rowfirst(y1L y2L y3L y4L y5L y6L y7L y8L y9L y10L y11L y12L) if time>=tm(2020m2)
egen pu=rowfirst(y1U y2U y3U y4U y5U y6U y7U y8U y9U y10U y11U y12U) if time>=tm(2020m2)
egen pp=rowfirst(y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12) if time>=tm(2020m2)
rename pp point
rename pl lower
rename pu upper
list time point lower upper if time>=tm(2020m2)
label variable opening "job openings(%)"
label variable point "point forecast"
label variable lower "lower interval forecast(90%)"
label variable upper "upper interval forecast(90%)"
tsline opening point lower upper if time>=tm(2010m1), title("Financial Acitivites Job Openings with Direct Method") lpattern (solid longdash shortdash shortdash)
graph rename dir_partial_forecast
tsline opening point lower upper if time>=tm(2000m12), title("Financial Acitivites Job Openings with Direct Method") lpattern (solid longdash shortdash shortdash)
graph rename dir_all_forecast

reg opening L(1/9).opening b12.m
forecast create ar9, replace
estimate store model1
forecast estimates model1
forecast solve,simulate(errors,statistic(stddev,prefix(sd_)) reps(1000))
gen ppp = f_opening if time>tm(2020m1)
gen ppl = f_opening-1.645*sd_opening if time>tm(2020m1)
gen ppu = f_opening+1.645*sd_opening if time>tm(2020m1)
label variable ppp "point forecast"
label variable ppl "lower forecast interval (90%)"
label variable ppu "upper forecast interval (90%)"
tsline opening ppp ppl ppu if time>=tm(2000m12), title("Financial Activities Job Opening Forecast with Iterated Method") lpattern (solid dash longdash shortdash)
graph rename iter_all_forecast
tsline opening ppp ppl ppu if time>=tm(2010m1), title("Financial Activities Job Opening Forecast with Iterated Method") lpattern (solid dash longdash shortdash)
graph rename iter_partial_forecast
rename ppp pt_forecast
rename ppl lo_forecast
rename ppu up_forecast
list time pt_forecast lo_forecast up_forecast if time>=tm(2020m2)