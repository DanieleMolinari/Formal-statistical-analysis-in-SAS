libname LabRep "/courses/dc36fc35ba27fe300/DMASAssessments";
proc copy in = LabRep out = work;
run;

/* Exploratpry Analysis */
options nodate nonumber;
proc means data=earthquakes mean stddev min max clm q1 median q3;
 footnote1 bold justify=left 'Table 1';
 footnote3 font='Times New Roman' italic justify=left height=3 'Table of descriptive statistics';
run;

*Counting missing values;
proc means data=earthquakes
  NMISS;
  footnote1 bold justify=left 'Table 2';
  footnote3 font='Times New Roman' italic justify=left height=3 'Missing values for each variable';
run;


*correlation table;
%let Vars = lat long dist depth md richter mw ms mb;
ods noproctitle;
options nodate nonumber;
proc corr data=earthquakes rank nosimple;
 var &vars;
 footnote1 bold justify=left 'Table 5';
 footnote3 font='Times New Roman' italic justify=left height=3 'Table of correlation of all variables except id and the two character variables country and direction';
run;

*make histograms for each variables;
ods noproctitle;
proc univariate data=earthquakes noprint;
  histogram md / kernel;
  footnote1 bold justify=left 'Figure 1a';
  footnote2 font='Times New Roman' italic justify=left height=3 'Histogram of the variable md with zero values';
run;
ods noproctitle;
proc univariate data=earthquakes noprint;
  histogram md / kernel;
  where md ne 0;
  footnote1 bold justify=left 'Figure 1b';
  footnote2 font='Times New Roman' italic justify=left height=3 'Histogram of the variable md without zero values';
run;

ods noproctitle;
proc univariate data=earthquakes noprint;
  histogram mw / kernel;
  footnote1 bold justify=left 'Figure 2';
  footnote2 font='Times New Roman' italic justify=left height=3 'Histogram of the variable mw';
run;

ods noproctitle;
proc univariate data=earthquakes noprint;
  histogram ms / kernel;
  where ms ne 0;
  footnote1 bold justify=left 'Figure 3';
  footnote2 font='Times New Roman' italic justify=left height=3 'Histogram of the variable ms';
run;

proc univariate data=earthquakes noprint;
  histogram richter / kernel;
  where richter ne 0;
  footnote1 bold justify=left 'Figure 4';
  footnote3 font='Times New Roman' italic justify=left height=3 'Histogram of the variable richter';
run;

proc univariate data=earthquakes noprint;
  histogram mb / kernel;
  where mb ne 0;
  footnote1 bold justify=left 'Figure 5';
  footnote3 font='Times New Roman' italic justify=left height=3 'Histogram of the variable mb';
run;

proc sgplot data=earthquakes;
  vbar country / dataskin=gloss categoryorder=respdesc; 
  footnote1 bold justify=left 'Figure 6';
  footnote3 font='Times New Roman' italic justify=left 'Bar chart';
run;

proc sgscatter data=earthquakes;
  matrix &vars;
run;

title 'Distasnce vs Depth';
footnote5 bold justify=left "Figure 1";
footnote6 font='Georgia' italic justify=left "The distance seems to quickly decrease with the increasing of depth." ;
proc sgplot data=earthquakes;
  scatter x=depth y=dist;
run;

title 'Magnitude of earthquake vs Distance';
proc sgplot data=earthquakes;
  scatter x=dist y=md;
footnote1 bold justify=left "Figure 2";
footnote2 font='Georgia' italic justify=left "The Magnitude of the earthquakes seems to quickly decrease with the increasing of distance." ;
run;

proc sgplot data=earthquakes;
  scatter x=depth y=richter;
  title 'Richter vs Depth';
  footnote1 bold justify=left "Figure 3";
  footnote2 font='Garamond' italic justify=left "The intensity of the earthquake seems to quickly decrease with the increasing of depth." ;
run;

proc sgplot data=earthquakes;
  vbox mw / category=country;
  title 'Moment magnitude in different countries';
  footnote1 bold justify=left "Figure 4";
  footnote2 font='Garamond' italic justify=left "Box plots of Mw (Moment Magnitude) in different countries." ;
run;

 

*question 1;
*The code will find the max value for each row between the columns specified in array command;
data earthquakes;
set earthquakes;
array values md mw ms mb richter;
xm = max(of values[*]);
run;

proc univariate data=earthquakes noprint;
  histogram xm / kernel;
run;

proc means data = earthquakes;
  var xm;
run;

ods output Statistics = Statis;
ods output ConfLimits = ConfLim;
ods output TTests = TTest;
proc ttest data=earthquakes H0=4.1 ;
  var xm;
run;

proc print data=Statis;
run;
proc print data=conflim;
run;
proc print data=ttest;
footnote1 bold justify=left "Table 6";
footnote2 font='Garamond' italic justify=left height=4 "Statistics and T test";
run;

ods select SummaryPanel;
proc ttest data=earthquakes H0=4.1 ;
  var xm;
  footnote1 bold justify=left "figure 7";
  footnote2 font='Garamond' italic justify=left height=4 "Histogram of xm with overimposed the Normal and Kernel distributin";
run;

ods select QQPlot;
proc ttest data=earthquakes H0=4.1 ;
  var xm;
  footnote1 bold justify=left "figure 8";
  footnote2 font='Garamond' italic justify=left height=4 "QQ plot of xm";
run;

data earthquakes;
  set earthquakes;
  logxm = log(xm);
run;
proc ttest data=earthquakes H0=4.1 ;
  var logxm;
  title 'One sample T-test. Mean of logxm different from 4.1?';
run;

data earthquakes;
  set earthquakes;
  sqrtxm = sqrt(xm);
run;
proc ttest data=earthquakes H0=4.1 ;
  var sqrtxm;
  title 'One sample T-test. Mean of logxm different from 4.1?';
run;

data earthquakes;
  set earthquakes;
  Invxm = 1/xm;
run;
proc univariate data=earthquakes noprint;
  histogram Invxm / kernel;
run;

ods trace on;
proc ttest data=earthquakes H0=4.1;
  var Invxm;
  title 'One sample T-test. Mean of logxm different from 4.1?';
run;
ods trace off;

ods output Statistics = Statis;
ods output ConfLimits = ConfLim;
ods output TTests = TTest;
proc ttest data=earthquakes H0=4.1;
  var Invxm;
  title 'One sample T-test. Mean of logxm different from 4.1?';
run;

proc print data=Statis;
run;
proc print data=conflim;
run;
proc print data=ttest;
footnote1 bold justify=left "Table 7";
footnote2 font='Garamond' italic justify=left height=4 "Statistics and T test of the inverse of xm";
run;

ods select SummaryPanel;
proc ttest data=earthquakes H0=4.1;
  var Invxm;
  footnote1 bold justify=left "figure 9";
  footnote2 font='Garamond' italic justify=left height=4 "Histogram of the incverse of xm with overimposed the Normal and Kernel distributin";
run;

ods select QQPlot;
proc ttest data=earthquakes H0=4.1;
  var Invxm;
  footnote1 bold justify=left "figure 10";
  footnote2 font='Garamond' italic justify=left height=4 "QQ plot of the inverse of xm";
run;

*question 2;
ods trace on;
proc glm data=earthquakes plots=diagnostics PLOTS(MAXPOINTS=NONE);
  class country;
  model mw=country;
  output out=Q2 predicted=predict cookd=cook;
run;
quit;
ods trace off;

ods output ClassLevels = Claslev;
ods output Nobs = Nobs;
ods output overallanova = OvOAnova;
ods output FitStatistics = fitstat;
ods output modelanova = modanov;
proc glm data=earthquakes plots=diagnostics PLOTS(MAXPOINTS=NONE);
  class country;
  model mw=country;
  output out=Q2 predicted=predict cookd=cook;
run;
quit;

proc print data=claslev;
run;
proc print data=nobs;
run;
proc print data=ovoanova;
run;
proc print data=fitstat;
run;
proc print data=modanov;
footnote1 bold justify=left "Table 8";
footnote2 font='Garamond' italic justify=left height=4 "Statistics and ANOVA model";
run;

ods select DiagnosticsPanel;
proc glm data=earthquakes plots=diagnostics PLOTS(MAXPOINTS=NONE);
  class country;
  model mw=country;
  output out=Q2 predicted=predict cookd=cook;
  footnote1 bold justify= left height=3 "Figure 11";
  footnote2 font='Garamond' italic justify=left height=5"Diagnostic plots";
run;

ods select BoxPlot;
proc glm data=earthquakes plots=diagnostics PLOTS(MAXPOINTS=NONE);
  class country;
  model mw=country;
  output out=Q2 predicted=predict cookd=cook;
  footnote1 bold justify=left "Figure 12";
  footnote2 font='Garamond' italic justify=left height=4 "Box plot";
run;

ods trace on;
proc glm data=earthquakes plots(only)=(diffplot(center));
  class country;
  model mw=country;
  lsmeans country / pdiff=all adjust=tukey;
run;
quit;
ods trace off;

ods select LSMeans;
proc glm data=earthquakes plots(only)=(diffplot(center));
  class country;
  model mw=country;
  lsmeans country / pdiff=all adjust=tukey;
  footnote1 bold justify=left "Table 9";
  footnote2 font='Garamond' italic justify=left height=4 "Index for each level of the variable country";
run;

ods select Diff;
proc glm data=earthquakes plots(only)=(diffplot(center));
  class country;
  model mw=country;
  lsmeans country / pdiff=all adjust=tukey;
  footnote1 bold justify=left "Table 10";
  footnote2 font='Garamond' italic justify=left height=4 "Significance of each level of the variable country";
run;

ods select DiffPlot;
proc glm data=earthquakes plots(only)=(diffplot(center));
  class country;
  model mw=country;
  lsmeans country / pdiff=all adjust=tukey;
  footnote1 bold justify=left "Figure 13";
  footnote2 font='Garamond' italic justify=left height=4 "Confidence interval for the difference between the mean of mw for each country";
run;



*question 3;
*complete model;
ods trace on;
proc glm data=earthquakes plots(only)=diagnostics;
  class country direction;
  model richter=lat long dist depth md mw ms mb country direction/ solution clparm;
run;
quit;
ods trace off;

ods select OverallANOVA;
proc glm data=earthquakes plots(only)=diagnostics;
  class country direction;
  model richter=lat long dist depth md mw ms mb country direction/ solution clparm;
  footnote1 bold justify=left "Table 11";
  footnote2 font='Garamond' italic justify=left height=4 "ANOVA table of the general model";
run;
quit;

ods select FitStatistics;
proc glm data=earthquakes plots(only)=diagnostics;
  class country direction;
  model richter=lat long dist depth md mw ms mb country direction/ solution clparm;
  footnote1 bold justify=left "Table 12";
  footnote2 font='Garamond' italic justify=left height=4 "Statistics of the general model";
run;
quit;

ods select ParameterEstimates;
proc glm data=earthquakes plots(only)=diagnostics;
  class country direction;
  model richter=lat long dist depth md mw ms mb country direction/ solution clparm;
  footnote1 bold justify=left "Table 13";
  footnote2 font='Garamond' italic justify=left height=4 "Parameters estimates of the general model";
run;
quit;

ods select DiagnosticsPanel;
proc glm data=earthquakes plots(only)=diagnostics;
  class country direction;
  model richter=lat long dist depth md mw ms mb country direction/ solution clparm;
  footnote1 bold justify=left "Figure 13";
  footnote2 font='Garamond' italic justify=left height=4 "Diagnostic plots";
run;
quit;

*Hoeffdings and Spearman statistics;
%let varNames = lat long dist depth md mw ms mb;

ods output spearmancorr=spearman hoeffdingcorr=hoeffding;

proc corr data=earthquakes spearman hoeffding;
  var richter;
  with &varNames;
run;

proc sort data=spearman;
  by variable;
run;

proc sort data=hoeffding;
  by variable;
run;

data coefficients;
  merge spearman(rename=(richter=scoef prichter=spvalue)) hoeffding(rename=(richter=hcoef prichter=hpvalue));
  by variable;
  scoef_abs=abs(scoef);
  hcoef_abs=abs(hcoef);
run;

proc rank data=coefficients out=coefficients_rank;
  var scoef_abs hcoef_abs;
  ranks ranksp rankho;
run;

proc print data=coefficients_rank;
  var variable ranksp rankho scoef spvalue hcoef hpvalue;
  footnote1 bold justify=left "Table 14";
  footnote2 font='Garamond' italic justify=left height=4 "Spearman and Hoeffding ranks";
run;

proc sgplot data=coefficients_rank;
  scatter y=ranksp x=rankho / datalabel=variable;
  footnote1 bold justify=left "Figure 14";
  footnote2 font='Garamond' italic justify=left "Spearman and Hoeffding ranks";
run;

*automated model selection;
ods trace on;
proc glmselect data=earthquakes plots=all;
  class country direction;
  model richter=lat long dist depth md mw ms mb country direction/selection=forward select=SL slentry=0.05
                                                                  showpvalues;
run;
ods trace off;

ods select SelectionSummary;
ods select StopReason;
ods select  StopDetails;
proc glmselect data=earthquakes plots=all;
  class country direction;
  model richter=lat long dist depth md mw ms mb country direction/selection=forward select=SL slentry=0.05
                                                                  showpvalues;
  footnote1 bold justify=left "Table 15";
  footnote2 font='Garamond' italic justify=left height=4 "Variable selection";                                                                
run;

ods select CoefficientPanel;
proc glmselect data=earthquakes plots=all;
  class country direction;
  model richter=lat long dist depth md mw ms mb country direction/selection=forward select=SL slentry=0.05
                                                                  showpvalues;
  footnote1 bold justify=left "Figure 15";
  footnote2 font='Garamond' italic justify=left height=4 "Coefficients at each iteration"; 
run;

ods select CriterionPanel;
proc glmselect data=earthquakes plots=all;
  class country direction;
  model richter=lat long dist depth md mw ms mb country direction/selection=forward select=SL slentry=0.05
                                                                  showpvalues;
  footnote1 bold justify=left "Figure 16";
  footnote2 font='Garamond' italic justify=left height=4 "Fit criteria"; 
run;

ods select ASEPlot;
proc glmselect data=earthquakes plots=all;
  class country direction;
  model richter=lat long dist depth md mw ms mb country direction/selection=forward select=SL slentry=0.05
                                                                  showpvalues;
  footnote1 bold justify=left "Figure 17";
  footnote2 font='Garamond' italic justify=left height=4 "Average Square Error"; 
run;

ods select SelectedEffects;
ods select ANOVA;
ods select FitStatistics;
ods select ParameterEstimates;
proc glmselect data=earthquakes plots=all;
  class country direction;
  model richter=lat long dist depth md mw ms mb country direction/selection=forward select=SL slentry=0.05
                                                                  showpvalues;
  footnote1 bold justify=left "Table 16";
  footnote2 font='Garamond' italic justify=left height=4 "Selected model";                                                                
run;


*question 4 and 5;
data earthquakes;
  set earthquakes;
  if richter >= 5 then serious = 1;
  else serious = 0;
run;

*dividing the data set;
proc sort data=earthquakes out=earthquakes_sort;
  by serious;
run;

proc surveyselect noprint data=earthquakes_sort samprate=.7
  outall out=earthquakes_sampling;
  strata serious;
run;

data train test;
  set earthquakes_sampling;
  if selected then output train;
  else output test;
run;

ods trace on;
proc logistic data=train plot(only)=(effect oddsratio) PLOTS(MAXPOINTS=NONE);
  class country direction;
  model serious(event='1')=lat long dist depth md ms mb country direction / clodds=pl;
  score data=test out=testAssess(rename=(p_1=p_complex))
  outroc=roc;
run;
ods trace off;

ods select ConvergenceStatus;
proc logistic data=train plot(only)=(effect oddsratio) PLOTS(MAXPOINTS=NONE);
  class country direction;
  model serious(event='1')=lat long dist depth md ms mb country direction / clodds=pl;
  score data=test out=testAssess(rename=(p_1=p_complex))
  outroc=roc;
  footnote1 bold justify=left "Table 17";
  footnote2 font='Garamond' italic justify=left height=4 "Convergence status"; 
run;

*ods select GlobalTests;
*proc logistic data=train plot(only)=(effect oddsratio) PLOTS(MAXPOINTS=NONE);
  *class country direction;
  *model serious(event='1')=lat long dist depth md ms mb country direction / clodds=pl;
  *score data=test out=testAssess(rename=(p_1=p_complex))
  outroc=roc;
  *footnote1 bold justify=left "Table 18";
  *footnote2 font='Garamond' italic justify=left height=4 "Testing Null Hypothesis"; 
*run;

ods select ParameterEstimates;
proc logistic data=train plot(only)=(effect oddsratio) PLOTS(MAXPOINTS=NONE);
  class country direction;
  model serious(event='1')=lat long dist depth md ms mb country direction / clodds=pl;
  score data=test out=testAssess(rename=(p_1=p_complex))
  outroc=roc;
  footnote1 bold justify=left "Table 18";
  footnote2 font='Garamond' italic justify=left height=4 "Parameters estimates"; 
run;

ods select ORPlot;
proc logistic data=train plot(only)=(effect oddsratio) PLOTS(MAXPOINTS=NONE);
  class country direction;
  model serious(event='1')=lat long dist depth md ms mb country direction / clodds=pl;
  score data=test out=testAssess(rename=(p_1=p_complex))
  outroc=roc;
  footnote1 bold justify=left "Figure 18";
  footnote2 font='Garamond' italic justify=left height=4 "95% Confidence Interval of the ods ratios"; 
run;




proc logistic data=train plot(only)=(effect oddsratio) PLOTS(MAXPOINTS=NONE);
  model serious(event='1')=xm / clodds=pl;
  score data=testAssess out=testAssess(rename=(p_1=p_simple))
  outroc=roc;
run;

ods select ConvergenceStatus;
proc logistic data=train plot(only)=(effect oddsratio) PLOTS(MAXPOINTS=NONE);
  model serious(event='1')=xm / clodds=pl;
  score data=testAssess out=testAssess(rename=(p_1=p_simple))
  outroc=roc;
  footnote1 bold justify=left "Table 19";
  footnote2 font='Garamond' italic justify=left height=4 "Convergence status";
run;

*ods select GlobalTests;
*proc logistic data=train plot(only)=(effect oddsratio) PLOTS(MAXPOINTS=NONE);
  *model serious(event='1')=xm / clodds=pl;
  *score data=testAssess out=testAssess(rename=(p_1=p_simple))
  *outroc=roc;
*run;

ods select ParameterEstimates;
proc logistic data=train plot(only)=(effect oddsratio) PLOTS(MAXPOINTS=NONE);
  model serious(event='1')=xm / clodds=pl;
  score data=testAssess out=testAssess(rename=(p_1=p_simple))
  outroc=roc;
  footnote1 bold justify=left "Table 20";
  footnote2 font='Garamond' italic justify=left height=4 "Parameters estimates"; 
run;

ods select ORPlot;
proc logistic data=train plot(only)=(effect oddsratio) PLOTS(MAXPOINTS=NONE);
  model serious(event='1')=xm / clodds=pl;
  score data=testAssess out=testAssess(rename=(p_1=p_simple))
  outroc=roc;
  footnote1 bold justify=left "Figure 19";
  footnote2 font='Garamond' italic justify=left height=4 "95% Confidence Interval of the ods ratios";
run;

ods trace on;
proc logistic data=testAssess;
  model serious(event='1')=p_complex p_simple / nofit;
  roc 'Complex Model' p_complex;
  roc 'Simple Model' p_simple;
  roccontrast 'Comparing two Models';
run;
ods trace off;

ods select ROCOverlay;
proc logistic data=testAssess;
  model serious(event='1')=p_complex p_simple / nofit;
  roc 'Complex Model' p_complex;
  roc 'Simple Model' p_simple;
  roccontrast 'Comparing two Models';
  footnote1 bold justify=left "Figure 20";
  footnote2 font='Garamond' italic justify=left height=4 "ROC curve and AUC value for the two logistic models";
run;

ods select ROCContrastTest;
 proc logistic data=testAssess;
  model serious(event='1')=p_complex p_simple / nofit;
  roc 'Complex Model' p_complex;
  roc 'Simple Model' p_simple;
  roccontrast 'Comparing two Models';
  footnote1 bold justify=left "Table 21";
  footnote2 font='Garamond' italic justify=left height=4 "Chi-squared test for the two ROC curves"; 
run;
