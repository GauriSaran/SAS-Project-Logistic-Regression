/*Now we will handle the Categorical variables and solve the problem with Quasi complete separation
with the categorical variables Ethnicity and Country by the method of Smoothed weight of evidence.
In this method, we replace the levels of Categorical variables with adjusted log odds with a smoothing factor c=24)
The formula for smoothed weight of evidence= #ofevents+ c*rho1/#ofnon-events + c*rho0 
*/
ods rtf file="/home/u47236280/Project-Drug_Usage/Project_Logistic_Regression2.rtf";
proc means data=drug.drug_usage_n sum noprint;
class Country;
var Cannabis;
ways 1;
output out=drug.drug_country sum=event_country;
run;	
proc sql noprint;
select mean(Cannabis) into :rho1 from drug.drug_usage_n;
quit;
filename sfile1 "/home/u47236280/Project-Drug_Usage/swoe_coun.sas";
data _null_;
	file sfile1;
	set drug.drug_country end=last;
	logit= log((event_country+ 24*&rho1)/(_Freq_ - event_country + (24*(1-&rho1))));
	if _n_=1 then put "select (Country);";
	put " when ('" Country +(-1) "') Country_swoe = " logit ";";
	if last then do;
	logit= log(event_country/(_Freq_ - event_country));
	put " otherwise Country_swoe = " logit ";"/ "end;";
	end;
run;

data drug.drug_usage_n;
	set drug.drug_usage_n;
	%include sfile1/source2;
run;

proc means data=drug.drug_usage_n sum noprint;
class Ethnicity;
var Cannabis;
ways 1;
output out=drug.drug_ethnic sum=event_ethnic;
run;	
proc sql noprint;
select mean(Cannabis) into :rho1 from drug.drug_usage_n;
quit;
filename sfile2 "/home/u47236280/Project-Drug_Usage/swoe_ethnic.sas";
data _null_;
	file sfile2;
	set drug.drug_ethnic end=last;
	logit= log((event_ethnic+ 24*&rho1)/(_Freq_ - event_ethnic + (24*(1-&rho1))));
	if _n_=1 then put "select (Ethnicity);";
	put " when ('" Ethnicity +(-1) "') Ethnic_swoe = " logit ";";
	if last then do;
	logit= log(event_ethnic/(_Freq_ - event_ethnic));
	put " otherwise Ethnic_swoe = " logit ";"/ "end;";
	end;
run;

data drug.drug_usage_n;
	set drug.drug_usage_n;
	%include sfile2/source2;
run;
/*Let's check the frequency table for all character variables*/
proc freq data=drug.drug_usage_n;
tables _character_;
run;

/*GREENACCRES METHOD TO REDUCE THE NUMBER OF LEVELS OF CATEGORICAL VARIABLE: */

/*Education has way too many levels. This can lead to problems with high dimensionality as a large number
of dummy variables will need to be created for Education. Therefore, we will use Proc cluster to cluster the
levels based on minimum reduction in chi-square value*/
proc means data=drug.drug_usage_n noprint;
class Education;
var Cannabis;
output out=drug.clust mean=prop;
run;
ods output clusterhistory=work.cluster;
proc cluster data=drug.clust method=ward outtree=work.fortree
plots=dendogram(vertical height=rsq);
freq _freq_;
var prop;
id Education;
run; 
/*To find which cluster to stop, we will multiply the proportion of chi-square value remaining after
clustering with the overall chi-square value of association. This will give us the chi-square value of 
association for different clusters. This can then be used to find the log of p value for each of those
chi-square values based on chi-square distribution curve. The cluster that has lowest value of
log of p value is selected as the cluster to stop.*/
proc freq data=drug.drug_usage_n noprint;
tables Education*Cannabis/ chisq;
output out=work.drug_freq(keep=_pchi_) chisq;
run;

data drug.cutoff;
	if _n_=1 then set work.drug_freq;
	set work.cluster;
	chisquare= _pchi_*rsquared;
	degfr= NumberofClusters - 1;
	logpf= logsdf('CHISQ', chisquare, degfr);
run;
	
proc sgplot data=drug.cutoff;
	scatter y=logpf x= numberofclusters/
	markerattrs=(color=blue symbol=circlefilled);
	xaxis label="Number of Clusters";
	yaxis label="Log of P value";
run;
	
/*From the scatter plot it is clear that the 4th cluster shows the lowest P-value and therefore,
highest chi-square association with the response variable. Now we can also find out which level
belongs to which cluster using proc tree. */
proc sql noprint;
select numberofclusters into :Nclus from drug.cutoff having logpf=min(logpf);
quit;

proc tree data=work.fortree nclusters=&NClus out=work.clus noprint;
id Education;
run;

proc sort data=work.clus;
by clusname;
run;

proc print data=work.clus;
by clusname;
id clusname;
run;

/*Now we will write set of rules to a file to create clusters in our original dataset:
drug.drug_usage_n */

filename rclus "/home/u47236280/Project-Drug_Usage/clus.sas";

data _null_;
	file rclus;
	set work.clus end=last;
	if _n_=1 then put "select (Education);";
	put " when ('" Education +(-1) "') Education_clus = '" Cluster +(-1) "';";
	if last then do;
	put " otherwise Education_clus = 'U';"/ "end;";
	end;
run;

data drug.drug_usage_n;
	set drug.drug_usage_n;
	%include rclus/ source2;
run;

ods rtf close;





























	