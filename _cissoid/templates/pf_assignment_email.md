Hello {{ name }} (Github: {{ gh }}), 

The Peer Feedback cycle for Mini-Project #0{{ project_id }} is
now underway. You have been asked to provide peer feedback on the
{{ assignments|length }} submissions listed below. 

For each, please review the project rubric at 
https://michael-weylandt.com/STA9750/miniprojects/mini0{{ project_id }}.html#rubric
and the general peer feedback instructions at 
https://michael-weylandt.com/STA9750/miniprojects.html#peer-feedback. 

You will submit your feedback as a comment in the relevant GitHub issue, 
following the format at the second link. Once you have submitted your peer
feedback for an individual, you may verify that it is properly formatted by
running the following set of R commands: 

> source("https://michael-weylandt.com/STA9750/load_helpers.R")
> mp_feedback_verify({{project_id}}, "{{gh}}", "PEERNAME")

As always, please take advantage of this opportunity to improve your
own skills in this course. Identify things which your peers may have done
in a more elegant, efficient, or insightful way than you or, if you think 
your approach is better, use this exercise as an opportunity to learn to
explain why you think one approach is better than another. 

Thank you for your assistance in making this the best learning experience
it can be for yourself and your peers.

Peer Assignments:

{% for author, url in assignments -%}
- {{author}}. See links and initial automated assessment at at {{url}}
{% endfor %}
