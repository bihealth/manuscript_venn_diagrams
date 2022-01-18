Thanks for your responses to addressing the reviewer's concerns. I would
like to ask the authors to address the following concerns regarding the
paper. These are essential before accepting the paper.

The authors state that "Here we show that both, the use of Venn diagrams to
find genes which are thought to be specific for a certain comparison, as
well as gene set enrichment analysis applied to such subsets is a fallacy.
A statistically correct approach involves testing for interaction."

To start with, no one uses "Venn diagrams to find genes which are thought to be
specific for a certain comparison". It is just a visualization tool. 
The flaw
is not in the Venn diagram but in how one could interpret it. Also, applying
gene set enrichment analysis to such subsets could be done even without the use
of Venn diagrams. 

The title and abstract are misleading and more journalistic
than scientific.  An analogous example to how the authors presented the paper
would be to condemn the use of a knife for murders. 
This style is misleading
and not acceptable for a scientific paper. The title and abstract should be
completely reformatted to focus on the underlying issue.

**We agree with these observations and understand your concerns. We have
reformulated abstract and discussion to state more clearly that Venn
diagrams are not the cause of flawed statistics but are very easily
misinterpreted and a readily identifiable symptom of erroneous statistical
reasoning, since we do observe a substantial fraction of papers using Venn
diagrams misinterpreting the results. Extending your metaphor, if knives
were like VDs in this context, then every fourth use of a knife would
result in a homicide.**

**We regret if our manuscript is perceived as too journalistic, even though
we think that communicating such a matter is to a large part an educational
mission and requires somewhat less complex and more pointed language. We
hope that our rewritten title, abstract and discussion strike a good
balance between scientific restraint and accessibility for
non-specialists.**

The authors state that "We have noticed a widespread fallacy related to gene
set enrichment analysis" however, no single example (or reference) has been
provided. 

**We do not want to single out specific papers or point fingers at specific
authors.  However, given that the sources of all our calculations are
available from github, we placed there the lists of links to papers which –
in our view – have incorrectly interpreted Venn diagrams. For example, the
file `literature_survey_sci_immunol.md` includes six (out of 14 analysed)
links to papers in Science Immunology which incorrectly interpreted Venn
diagrams. The file `literature_survey_scirep.md` contains 73 links to
papers from Scientific Reports (out of 238 reviewed). We now mention that
explicitely in "Methods".**

The literature review results with incorrect use cases should be provided as
supplementary materials to support the claims made in the paper. 
Justification
for the claims made in the paper is essential.

**We have now included the following statement in the
Methods section:**

*"The results of the literature survey (including links to papers classified
as incorrectly analysing the interaction) are included in the manuscript
sources."*

Authors state that "Of the 431 genes significant in G1, but not in G2, 199
(46%) are significant in the full data set; of the 278 genes significant in G2,
but not in G1, 99 (36%) are significant in the full data set. Given that G1 and
G2 were sampled from the total population, and since the FDR was set to 0.05,
we can assume that at least between a third and a half of the genes that
appeared to be specific" in the initial analysis were, in fact, false negatives
in one of the comparisons." The conclusion made is based on the assumption that
there are no false positives when analyzing the whole dataset. 
This is not
justifiable. 

**Our conclusion is based on the assumption that the fraction of FP among
significant genes is controlled by the Benjamini-Hochberg procedure, in
other words, that the false discovery rate (FDR) is not more than 5% (as
stated in the quoted paragraph). This implies that in the whole data set
there are at most 30 DEGs which are FP. Since 199+99 = 298
supposedly specific genes are significant when analysing the whole data
set, even if all 30 FPs are among them, there are still 268 genes which are
not FP and which appear to be group specific. 100% * 268 / (431 + 278) =
37%. We have now made these simple calculations more explicit in the
text.**

Also, splitting samples of a dataset into two groups results in
smaller sample sizes for each group. 
This comes with two major shortcomings:
(1) the test for differential expression of genes are more sensitive to noise
and outliers, resulting in false positives
, and (2) the test for differential
expression of genes might not have the power to reject the null hypothesis (no
differential expression), resulting in introducing false negatives. 

**We agree that splitting the dataset results in decreased statistical
power. However, we don't find it obvious that the false discovery rate will
increase, since it's controlled by the standard BH false discovery rate
procedure and the FDR cutoff of 0.05. Instead, we fully agree that FNs are
the core of the problem and used the FDR cutoff of 0.05 to not unduely
inflate the number of false negatives (a more conservative threshold would
result in a higher false negative rate). Even in most favorable
circumstances the FNR will likely be above 20%, especially for
transcriptomic studies (see also
https://academic.oup.com/bib/article/19/4/713/2920205).**

**In any case, there are 80 samples in our analysis (40 samples per
group and 20 per group/treatment combination), which is not a small sample
size for this type of transcriptomic analysis. In fact, a survey on RNA
sample size in real world data (Baccarella et al.) finds that half of the
studies in humans used sample sizes sizes of 6 or less per group. Nevertheless, we
welcome the suggestion to analyze the sample size dependence: in fact, the
larger the sample size, the more artefactual enrichments are observed,
because the differential expression yields more results and the
hypergeometric test gets more powerful with more DEGs. We have now included
a section comparing the results for 10, 20 (our example) and 40 samples per
group/treatment combination (thus, total sample sizes of 40, 80 and 160).
For each sample size, we have run 100 replicates of the group sampling,
replicated the whole procedure and gathered all test results. We hope that
the new results shown ion the new Fig. 4, C and D provide a useful
illustration of this reasoning.**

Therefore, the design of the experiment is biased in favour of the
"desired" conclusion.

**We respectfully disagree. Our approach is quite similar to
cross-validation and a straightforward way to construct two groups that
should not have differences and then show how an incorrect (but widely
used) statistical procedure will result in convincing evidence for
differences between them.**

**Essentially, we think that the core of the problem is the incorrect
statistical procedure (selecting genes by comparing significance with lack
thereof), which will not become more correct by increasing the sample size.**

The authors use a small log-fold change value of 1 to define the
differential expression. This leads to a high number of false positives.

**log2-fold change cutoffs (on top of FDR control) are widely used in the
literature, and a cutoff of 1 is in our experience not small for human
data. The threshold serves to eliminate genes that show statistically
significant change (they are true positives), but are not biologically
relevant (because the effect size, for which log2 fold change is a proxy,
is too small). In any case, the false discovery rate in differential
expression analysis is controlled via BH by a cutoff on the p-value, not
the log fold change, except indirectly (beause log fold change is
correlated to the p-value, setting a more conservative log2 fold change
results in eliminating most of the larger p-values). The precise effect of
raising the LFC threshold on FDR is therefore unclear except in very broad
terms.**

**We have now included a section in the manuscript which shows the
dependence of the artifacts on the log2 fold change thresholds used. For
this, we have replicated the whole procedure of group randomization 100
times. Summary overview can be found in the new Fig. 4. We find that
increasing the threshold can, of course, result in not observing any
enrichments (see Fig. 4, A and B). Without a sufficient number of DEGs, no
enrichments can be calculated using a hypergeometric test. However, even
though increasing the log2 fold change cutoff may sometimes eliminate the
symptoms, it does not remedy the core problem of erroneous analysis of
interactions. Many replicates in the simulations have artifactual
enrichments even at high log fold change thresholds.**


The paper also needs to be edited to have a more scientific tone, improve
long and complicated sentences, and correct the typos and grammatical
errors.

**We thank the Editor for this suggestion. We did our best, and we hope
that the manuscript reads now much better.**
