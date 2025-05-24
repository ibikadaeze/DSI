# ASSIGNMENT: Sampling and Reproducibility in Python

Read the blog post [Contact tracing can give a biased sample of COVID-19 cases](https://andrewwhitby.com/2020/11/24/contact-tracing-biased/) by Andrew Whitby to understand the context and motivation behind the simulation model we will be examining.

Examine the code in `whitby_covid_tracing.py`. Identify all stages at which sampling is occurring in the model. Describe in words the sampling procedure, referencing the functions used, sample size, sampling frame, any underlying distributions involved, and how these relate to the procedure outlined in the blog post.

Run the Python script file called whitby_covid_tracing.py as is and compare the results to the graphs in the original blog post. Does this code appear to reproduce the graphs from the original blog post?

Modify the number of repetitions in the simulation to 100 (from the original 1000). Run the script multiple times and observe the outputted graphs. Comment on the reproducibility of the results.

Alter the code so that it is reproducible. Describe the changes you made to the code and how they affected the reproducibility of the script file. The output does not need to match Whitby’s original blogpost/graphs, it just needs to produce the same output when run multiple times

# Author: ADAEZE IBIK

```
Sampling Stages in the model

Infection sampling
-Sample size: 10% of all attendees (ATTACK_RATE = 0.10) using the function 'np.random.choice()'
-Sampling frame: All 1000 event attendees which includes 200 weddings and 800 brunches.
-Distribution: Random selection without replacement.
-This represents the random infection process where some attendees get infected regardless of event type.

Primary contact tracing sampling
-Sample size: 20% of infected individuals (TRACE_SUCCESS = 0.20)using function 'np.random.rand()'
-Sampling frame: All infected individuals.
-Distribution: Binomial distribution
-This represents the imperfect process where only some infections are successfully traced.

Secondary contact tracing sampling
-Sample size: All infected attendees of events with >= 2 primary traces (If two infections are independently traced to the same source event, a special effort is made to test every person who attended that event)---this is the same size as the initial infected sample.
-Sampling frame: Infected individuals at events that meet the above threshold.
-Distribution: Non-probabilistic methods since it depends on the primary contact tracing.
-This overestimate the proportion of cases that result from weddings (and equivalently, underestimate this that come from brunches).

The code whiteby_covid_tracing.py does not reproduce the plot in the blog post exactly but it is similar since it has similar structure and is centered around 20% of infections from weddings.

When I re-run the script with m=100, the plot still maintained similar pattern with the original plot since it centers around 20% but the noise in the distribution increased. The overal shape of the plot changed at each run as a result of random sampling. This also led to increased variation and extreme outliers.

To make sure that teh code can reproduce its result multiple times, I added a random seed to teh script. This ensured that I could get teh same result as intended many times.

```


## Criteria

|Criteria|Complete|Incomplete|
|--------|----|----|
|Altercation of the code|The code changes made, made it reproducible.|The code is still not reproducible.|
|Description of changes|The author explained the reasonings for the changes made well.|The author did not explain the reasonings for the changes made well.|

## Submission Information

🚨 **Please review our [Assignment Submission Guide](https://github.com/UofT-DSI/onboarding/blob/main/onboarding_documents/submissions.md)** 🚨 for detailed instructions on how to format, branch, and submit your work. Following these guidelines is crucial for your submissions to be evaluated correctly.

### Submission Parameters:
* Submission Due Date: `23:59 - 09/04/2025`
* The branch name for your repo should be: `assignment-1`
* What to submit for this assignment:
    * This markdown file (a1_sampling_and_reproducibility.md) should be populated.
    * The `whitby_covid_tracing.py` should be changed.
* What the pull request link should look like for this assignment: `https://github.com/<your_github_username>/sampling/pull/<pr_id>`
    * Open a private window in your browser. Copy and paste the link to your pull request into the address bar. Make sure you can see your pull request properly. This helps the technical facilitator and learning support staff review your submission easily.

Checklist:
- [ ] Create a branch called `assignment-1`.
- [ ] Ensure that the repository is public.
- [ ] Review [the PR description guidelines](https://github.com/UofT-DSI/onboarding/blob/main/onboarding_documents/submissions.md#guidelines-for-pull-request-descriptions) and adhere to them.
- [ ] Verify that the link is accessible in a private browser window.

If you encounter any difficulties or have questions, please don't hesitate to reach out to our team via the help channel in Slack. Our Technical Facilitators and Learning Support staff are here to help you navigate any challenges.
