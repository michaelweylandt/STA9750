Hi @{{ gh }},

The Peer Feedback cycle for Mini-Project #0{{ project_id }} is
now underway. You have been asked to provide peer feedback on
{{ n_assignments}} of your classmates' submissions. 

To begin the peer review process, please run the following `R` commands on your
personal computer: 

```{r}
source("https://michael-weylandt.com/STA9750/load_helpers.R")
mp_pf_perform({{project_id}}, github="{{gh}}")
```

Follow the prompts and, after all your comments are recorded, upload the 
file `pf_mp0{{project_id}}_{{gh}}.bspf` on [CUNY Brightspace](https://brightspace.cuny.edu/).

Before providing your comments, please review the project instructions at 
<https://michael-weylandt.com/STA9750/mini/mini0{{ project_id }}.html>
and the general peer feedback instructions at 
<https://michael-weylandt.com/STA9750/miniprojects.html#peer-feedback>.

As always, please take advantage of this opportunity to improve your
own skills in this course. Identify things which your peers may have done
in a more elegant, efficient, or insightful way than you or, if you think 
your approach is better, use this exercise as an opportunity to learn to
explain why you think one approach is better than another. 

Thank you for your assistance in making this the best learning experience
it can be for yourself and your peers!

- CISSOID (Your friendly STA 9750 course robot 🤖)

**This is an automated message. Please contact the course staff with any questions.**
