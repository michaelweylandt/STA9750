Hi {{ name }} (@{{gh}}),

As part of the STA 9750 course project (https://michael-weylandt.com/STA9750/project.html), peer evaluation
scores are collected to ensure that all teammates are substantially contributing to the success of the overall
project. Please see below for your peer scores following the {{cycle}} Peer Feedback Cycle. 

For this cycle, your fellow members of the {{team_name}} Team were asked to evaluate your contributions on
{{scores|length}} different aspects of team contribution. Individual scores were statistically corrected (if needed) 
and your median peer score for each component was summed to determine your overall score. For this cycle, you 
received a {{overall_score}} out of a maximum possible {{maximum_score}}. 

These broke down as follows: 

{% for k, v in scores.items() %}
{{k[1]}}: Median Peer Score {{v["Median"]}} (Median of {{v["ALL"].values()|list}})
{% endfor %}

Additionally, your peers provided confidential comments on your participation. A synthesized and anonymized
version of these comments follows below: 

{{instructor_comment}}

---
If you have any questions or concerns about your grade, please contact the course staff directly, in accordance with the 
regrading policy (https://michael-weylandt.com/STA9750/syllabus.html#regrading-policy). We will be happy to look more closely
at any element you feel was misgraded. 

**This is an automated message. Please contact the course staff with any questions.**

