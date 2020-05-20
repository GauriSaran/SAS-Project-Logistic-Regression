ods rtf file="/home/u47236280/Project-Drug_Usage/score.rtf";
/*Now we will try to determine multicollinearity among different numeric variables
and try to find out if any input variables that shows high level of multicollinearity
can be eliminated from the model selection process.
For this we use Proc Varclus to cluster the variable. This algorithm
uses iterative algorithm- Principal Component Analysis for clustering different
input variables. In each cluster, the 1-Rsquare ratio is calculated.
This is the ratio of 1-Rsquare within cluster/ 1- Rsquare with next cluster.
This ratio must be small for an input variable within a cluster as it shows
high level of correlation with the variables within cluster and low level
of correlation with variables in next cluster. 
The variables with the smallest 1- Rsquare ratio is selected as the chosen variable in that cluster. 
In Principal component analysis, eigenvectors are formed which are linear combinations of input variables.
As many eigenvectors are formed as there are variables in the cluster.
We split the input variables into clusters based on the second eigenvalue. If the threshold for second 
eigenvalue is below the clusters 2nd eigenvalue, then the cluster will split. If we choose a higher threshold,
we will maintain lesser variance in our input variables. However if we choose a smaller threshold, we maintain greater
level of variance in the model. */

%let interval = B_neuro B_cons B_open B_agree Impulsiveness Sensation Ethnic_swoe Country_swoe;

ods output clusterquality=work.summary
			rsquare=work.clusters;
proc varclus data=drug.drug_usage_n maxeigen=0.7 hi;
var &interval;
run;

/*From proc varclus results, we can see that the last cluster that is formed is the 6 cluster solution.
The first cluster contains 2 variables, B_Neuro and B_Cons. B_Neuro shows slightly lower 1-Rsquare Ratio.
Similarly B_Open and Country_Swoe shows slight difference in 1-Rsquare ratio with Openness being slightly lower.

Therefore, ifference is not very large. And based on understanding of the subject, Neuroticism and Conscientiousness
can both be equally important as predictors of being Cannabis user. Similarly both Country and Openness
can be potential predictors. Therefore, we will keep all the variables in the model development and validation process. */
options symbolgen;
data _null_;
	set work.summary;
	call symput('nvar', compress(NumberOfClusters));
run;
%put &nvar;
proc print data=work.clusters noobs label split='*';
	where NumberofClusters=&nvar;
	var Cluster Variable RsquareRatio;
	label RsquareRatio= '1-Rsqaure*Ratio';
run;

/*Now we will use Proc Logistics to determine which interactions in the model will be influential enough or
significant enough to keep. We will use Forward Selection method that includes all the main effects in the final
selected model and selects only those interactions in the final model which are significant. 
We choose the significance level based on the value of BIC (Bayesian Information criteria). The significance
level that lowers BIC is calculated by determining the 1 minus p-value for chi-square statistic of ln of n where
n is the number of cases.*/

proc sql noprint;
select 1-probchi(log(sum(Cannabis ge 0)), 1) into :sl from drug.drug_usage_n;
quit;
%put &sl;
%let categorical=Age Gender Education_clus;


proc logistic data= drug.drug_usage_n namelen=50;
 class &categorical/ param=ref ref=first;
 model Cannabis(event='1')= &interval &categorical 
 							 Age|Gender|B_neuro|B_cons|B_open|B_agree|Impulsiveness|Sensation|Ethnic_swoe|Country_swoe|Education_clus/
 							 selection=forward slentry=&sl include=11 clodds=pl;
run;

/*The results shows that model converged. Therefore, we can trust the results.
Only one effect entered the model, i.e. B_neuro*B_agree. From Type 3 Analysis of effects table,
we can also see that the main effect B_agree is not statistically significant. However, to maintain the
hierarchy of model it is will be included in the model if the interaction is present in the model.
Now we will further use Backward selection technique to form a subset of input variables that best explains
the variation in the response variable based on significance level or p-value.
We use Fast Backward Selection method which gives us an approximation of the parameters selected.*/

proc logistic data=drug.drug_usage_n namelen=50;
	class &categorical/ param=ref ref=first;
	model Cannabis(event='1')= &interval &categorical B_neuro*B_agree/selection=backward clodds=pl slstay=&sl
	 							hier=single fast;
run;

/*The variables Impulsiveness and Sensation were removed from the final model. Again we can see from
Type 3 Analysis of Effects table that B_agree is not significant but still it remains in final model to 
maintain the hierarchy of the model as the interaction effect B_neuro*B_agree is in the final model.
The Global Null Hypothesis table shows that at least one of parameters are statistically significant and different
from zero.*/
/*The c statistic of 0.883 shows that model has good predictive ability. We also make an oddratio plot
for the interaction effect B_neuro at different values of B_agree. The Oddratio plot shows that
the oddratios for B_neuro are statistically significant.*/
proc logistic data=drug.drug_usage_n namelen=50;
	class &categorical/ param=ref ref=first;
	model Cannabis(event='1')= B_neuro B_cons B_open B_agree Ethnic_swoe Country_swoe &categorical B_neuro*B_agree;
	units B_neuro=10/ default=5;
	oddsratio B_neuro/ at (B_agree=5,20,50) cl=pl;
run;
/*Therefore based on the model selected, we will include these variables for final validation of the model.
Now we will use the all possible subset regression technique where all the possible models with different number
of variables are selected and rank ordered based on the value of their score-chi-square statistic.
We will use the best option to select only 1 model from every single model size comprising of different
number of variables based on the highest score chi square value.
Since score chi square value simply increases as the number of variables increases, we will instead use 
fitstat option by scoring the same dataset that use to build the model. We use different fit statistics 
on the insample evaluation performed to determine the best model to use for further validation. For this
we use macro function to automate this selection process.
*/

data drug.drug_usage_n;
	set drug.drug_usage_n;
	if Age= '18-24' then Age_C=0;
	else Age_C=1;
	Gender_C= (Gender=Male);
	if Education_clus=1 then Education_clus_C=0;
	else Education_clus_C=1;
run;

%macro fitstat(data=, var=, target=, event=, best=);

ods output bestsubsets=work.score;
proc logistic data=&data namelen=50;
	*class &categorical/ param=ref ref=first;
	model &target(event="&event")= &var/ selection=score best=&best;
run;


proc sql;
select variablesinmodel into :inputs1 -
from work.score;
quit;

proc sql;
select NumberOfVariables into :ic1 -
from work.score;
quit;

%let lastindx= &SqlObs;

%do model_index= 1 %to &lastindx;

%let im= &&inputs&model_index;
%let ic= &&ic&model_index;

ods output scorefitstat=work.stat&ic;
proc logistic data=&data namelen=50;
	model &target(event="&event")= &im;
	score data=&data out=work.scored fitstat;
run;
%end;
proc datasets library=work nodetails nolist; delete scored;
run;
quit;
data work.model_fit;
	set work.stat1-work.stat&lastindx;
	model=_n_;
run;

%mend fitstat;

%fitstat(data= drug.drug_usage_n, var=B_neuro B_cons B_open B_agree Impulsiveness Sensation Ethnic_swoe Country_swoe Age_C Education_clus_C Gender_C B_neuro*B_agree, target=Cannabis,
event=1, best=1);

proc print data=work.model_fit;
run;
/*We see that model with 11 variables has the highest AUC which is equivalent to the c statistic that
shows the predictive ability of the model. Higher the c statistics, better is our model fit.
However there are also other fit statistics such as BIC and misclassfication (number of false positives and
number of false negatives divided by total sample size using a central cutoff of 0.5 for the probability).
We will sort the dataset by BIC to see which model gives lowest BIC as low BIC shows better fit of the model.
*/

proc sort data=work.model_fit;
by BIC;
run;

proc print data=work.model_fit;
run;

/*The lowest BIC is of the model with 8 variables. Also other criterias such as AIC, AICC, misclassification
are low for the model with 8 variables. Since these criterias represents the fit of the model where 
lower is better, we will go with the model with 8 variables for further validation.*/

ods rtf close;


































