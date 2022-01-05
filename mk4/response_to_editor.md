Thanks for your responses to addressing the reviewer's concerns. I would
like to ask the authors to address the following concerns regarding the
paper. These are essential before accepting the paper.

The authors state that "Here we show that both, the use of Venn diagrams to
find genes which are thought to be specific for a certain comparison, as
well as gene set enrichment analysis applied to such subsets is a fallacy.
A statistically correct approach involves testing for interaction."

To start with, no one uses "Venn diagrams to find genes which are thought to be
specific for a certain comparison". It is just a visualization tool. 

**We do agree in principle. However, the term "venn diagram analysis" (and
related formulations) is firmly (even though rather unfortunately)
established in the field of differential expression and many authors are
using it essentially as a shorthand for stating that the supposedly
treatment specific genes are found by comparing which genes are significant
in one, but not the other comparison. We have now explained this in more
detail in the Introduction as follows:**

XXX


The flaw
is not in the Venn diagram but in how one could interpret it. Also, applying
gene set enrichment analysis to such subsets could be done even without the use
of Venn diagrams. 

**We fully agree; we have already addressed this issue in the
"Discussion".**

The title and abstract are misleading and more journalistic
than scientific.  An analogous example to how the authors presented the paper
would be to condemn the use of a knife for murders. 

**We understand that point. However, we do observe a substantial fraction of
papers using Venn diagrams misinterpreting the results. The given analogy
would only work if every fourth use of a knife resulted in a homicide. This
point has already been addressed in the Discussion. Nonetheless we have now
removed references to Venn diagrams in the title and in the abstract.**

This style is misleading
and not acceptable for a scientific paper. The title and abstract should be
completely reformatted to focus on the underlying issue.

**We have completely rewritten the title and the abstract and hope that
they are now acceptable.**

The authors state that "We have noticed a widespread fallacy related to gene
set enrichment analysis" however, no single example (or reference) has been
provided. 

**We do not want to single out a paper or point fingers at specific
authors.  However, given that the sources of all our calculations are
available from github, we placed there the list of links to papers which –
in our view – have incorrectly interpreted Venn diagrams. For example, the
file `literature_survey_sci_immunol.md` includes six (out of 14 analysed)
links to papers in Science Immunology which incorrectly interpreted Venn
diagrams. The file `literature_survey_scirep.md` contains 73 links to
papers from Scientific Reports (out of 238 reviewed).**

The literature review results with incorrect use cases should be provided as
supplementary materials to support the claims made in the paper. 
Justification
for the claims made in the paper is essential.

**They have been all along. We have now included the following statement in the
Methods section:**

*"The results of the literature survey (including links to papers classified
as incorrectly analysing the interaction) are included in the manuscript
sources."*

XXX

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

**This conclusion is based on the assumption that the fraction of FP among
significant genes is controlled by the Benjamini-Hochberg procedure, in
other words, that the false discovery rate (FDR) is not more than 5% (as
stated in the quoted paragraph).**

Also, splitting samples of a dataset into two groups results in
smaller sample sizes for each group. 

**We agree, but the total number of samples in the analysis is still 80,
with 40 samples per group and 20 per group/treatment combination. This is
not an unusually small sample size for this type of transcriptomic
analysis (see below for more on the chosen sample size). Also, the design of our in
silico experiment *requires* splitting the data set into two randomly selected groups,
because that is the whole idea of the paper: take a situation in which 
there should not be any significant enrichments (because there are no
real differences between the groups) and show that with an incorrect (but
widely spread) procedure you will get convincing evidence for differences
between groups.**

This comes with two major shortcomings:
(1) the test for differential expression of genes are more sensitive to noise
and outliers, resulting in false positives

**We find the claim that the number of false positives is higher for small
sample sizes surprising. Statistical theory tells us that the FDR is
controlled by the BH false discovery rate controlling procedure.  If BH
(which is a widely accepted method for the analysis of DE data) is correct,
we should not expect more than 5% FP among significant results
independently of sample size.  See Benjamini, Yoav, and Yosef Hochberg.
"Controlling the false discovery rate: a practical and powerful approach to
multiple testing." Journal of the Royal statistical society: series B
(Methodological) 57.1 (1995): 289-300. We are not aware of any sources that
would claim otherwise.**

, and (2) the test for differential
expression of genes might not have the power to reject the null hypothesis (no
differential expression), resulting in introducing false negatives. 

**We fully agree that FNs are the core of the problem! However, we know
from other studies (and basic statistics) that even in most favorable
circumstances the FNR will likely be above 20%; and that in case of transcriptomic
studies, the FNR may be much larger (please see the relevant fragment already
included in the paper). In other words, it does not matter whether one
looks at 80 samples or 193 samples: FNs are bound to occur. That is the
reason – we claim – for the fact that the gene set enrichments found in
this manner are related to the studied problem. However, we have addressed
this isssue by testing different sample sizes (see below).**

Therefore,
the design of the experiment is biased in favour of the "desired" conclusion.

**We have mimicked an RNA-Seq experiment using a sample size
well above the median used by others precisely to avoid this allegation. We
have now included a relevant reference (Baccarella et al.) which includes a
literature survey on RNA sample size in real world data. In there you will
see that half of the studies used sample sizes sizes of 6 or less per
group.

Nonetheless, we think that showing how the artifacts depend on sample size
is, in itself, interesting, not least because it shows that sample size has
a direct effect on the number of observed artifacts: the larger the sample
size, the more artifacts are observed. We have now included a section
comparing the results for 10, 20 (our example) and 40 samples per
group/treatment combination (thus, total sample sizes of 40, 80 and 160).
The reason for this is, of course, that the more DEGs you observe, the more
powerfull the hypergeometric test is.

For each sample size, we have run 100 replicates of the group sampling,
replicated the whole procedure and gathered all test results. Results are
shown on the new Fig. 3, C and D.

However, we also think that the core of the problem is the incorrect
statistical procedure (selecting genes by comparing significance with lack
thereof) which will not become more correct by increasing the sample size,
even should we fail to observe any artifacts (which is not the case,
artifacts appear even for abs(lfc) >= 3).**

XXX

The authors use a small log-fold change value of 1 to define the
differential expression. This leads to a high number of false positives.

**Statistical theory (e.g. the above reference to the original Benjamini &
Hochberg paper) tells us that the false discovery rate in differential
expression analysis is controlled by the BH procedure, not by the log fold
change threshold, except incidentally (beause log fold change is correlated
to the p-value, thus setting a more conservative log2 fold change results
in eliminating most of the larger p-values). Genes with large fold changes
may still not be significant and vice versa, true positives may have small
log2 fold changes. Therefore you cannot predict what will be the precise
effect of raising the LFC threshold on FDR except in very broad terms,
whereas setting the FDR threshold gives you clear information about the
expected proportion of false positives in your results.

This is analogous to using an effect size filter (say, Cohen's d) on
results of a t-test. The p-value from the t-test controls the type I error
rate, but a statistically significant difference does not necessarily
indicate a biologically meaningfull effect. For this, we turn to the effect
size (see for example Sullivan, Gail M., and Richard Feinn. "Using effect
size—or why the P value is not enough." Journal of graduate medical
education 4.3 (2012): 279-282.).

Thus, the threshold serves to eliminate genes that do show statistically
significant change (even if they are true positives), but which are not
biologically relevant (because the effect size, for which log2 fold change
is a proxy, is too small). The proportion of false positives is 5% even with no
log2 FC treshold.  Nonetheless, we have compared the effect of the log2
fold change threshold on the results.**

Higher values of log-fold change should also be used, and the results
should be compared and discussed.

**We have now included a section in the manuscript which shows the
dependence of the artifacts on the log2 fold change thresholds used.
For this, we have replicated the whole procedure of group randomization 100
times, and repeated the analysis for different threshold values. Summary
overview can be found in the new Fig. 3.**


The paper also needs to be edited to have a more scientific tone, improve long and complicated sentences, and correct the typos and grammatical errors.

**We thank the Editor for this suggestion. We did our best, and we hope
that the manuscript reads now much better.**
