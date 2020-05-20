ods rtf file="/home/u47236280/Project-Drug_Usage/score_final.rtf";
/*Now we prepare the validation dataset based on the same guidelines that we prepared the
training dataset*/

data drug.drug_valid_n (drop=Selected SelectionProb SamplingWeight);
	set drug.drug_usage_valid;
	%include rfile1;
	%include rfile2;
	%include rfile3;
	%include rfile4;
	%include sfile1;
	%include sfile2;
	%include rclus;
	if Age= '18-24' then Age_C=0;
	else Age_C=1;
	Gender_C= (Gender=Male);
	if Education_clus=1 then Education_clus_C=0;
	else Education_clus_C=1;
run;

/*We will select the list of variables selected by All possible best subset selection in to a
macro variable selected. */

proc sql;
select variablesinmodel into :selected from work.score
where numberofvariables=8;
quit;
%put &selected;

/*Now we run the logistic regression to fit the model using the input variables selected from backwards selection.
After that we again run logistic regression to fit the model using the input variables selected from all possible
best subset selection method. Then we compare the ROC curve for the two methods 
which is the curve of Sensitivity vs 1-specificity for all possible cut offs for the probability. If the Area under
the curve is larger for one of the methods, then that model has greater predictive ability.*/


proc logistic data=drug.drug_usage_n namelen=50;
	class &categorical/ param=ref ref=first;
	model Cannabis(event='1')= B_neuro B_cons B_open B_agree Ethnic_swoe Country_swoe &categorical B_neuro*B_agree;
	score data=drug.drug_valid_n out=drug.drug_valid_scored(rename=(P_1=P_backward));
run;

proc logistic data=drug.drug_usage_n namelen=50;
	model Cannabis(event='1')= &selected;
	score data=drug.drug_valid_scored out=drug.drug_valid_scored(rename=(P_1=P_sel));
run;

title "Validation Dataset Performance Compared for two different models";
ods select ROCOverlay ROCAssociation ROCContrastTest;

proc logistic data=drug.drug_valid_scored;
	model Cannabis(event='1')=P_backward P_sel/ nofit;
	roc "Model from Backward Selection" P_backward;
	roc "Model from All possible best subset selection" P_sel;
	roccontrast "Comparing the Two models";
run;

/*We can see that definitely the model from backward selection process has slightly higher C-value or 
the area under the curve is greater than the model from all possible best subset selection. However,
the difference is not large is not significant. But still, the model with backward selection shows a bit
better predictive ability. Therefore, we will finally go with the input variables selected from backward selection 
process for the final model that will be used to score new cases.  */ 
	
ods rtf close;











