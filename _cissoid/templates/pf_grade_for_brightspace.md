Hi {{ name }} (@{{gh}}),

For MP#0{{ project_id }} (https://michael-weylandt.com/STA9750/mini/mini0{{ project_id }}.html), 
you received a peer feedback from {{n_reviewers}} of your classmates. 

{%if overall_score is none %}
This mini-project was ungraded so no scores were collected. I hope the peer
comments below are still helpful.
{% else %}
You received a {{overall_score["Total"]}} on this assignment. 

{% if bs_penalty %}
A penalty of 5 points was deducted from your overall score because you did not 
make a submission on Brightspace. If you feel this penalty has been applied
incorrectly, please contact the course staff immediately.
{% endif %}

{% if check_penalty %}
A penalty of 5 points was deducted from your overall score because your submission
did not pass all automated checks. If you feel this penalty has been applied
incorrectly, please contact the course staff immediately.
{% endif %}
{% endif %}

{%- if scores -%}
You can find the rubric used to grade this mini-project at the link above. 
The following peer scores on the submission were received: 

{% for k, v in scores.items() %}
{{k}}: Median Peer Score {{overall_score[k]}}{% for k2, v2 in v.items() %}
  - {{k2}}: {{v2["score"]}}. {{v2["comment"]|wordwrap(width=80)}}
  {% endfor %}
{% endfor %}

{% endif %}

{% if comments is not none %}
The following overall comments on your submission were received.

{% if "positive" in comments %}
Your peers noted the following strengths of your submission:
{% for k, v in comments["positive"].items() %}
  - {{k}}: "{{v}}" 
{% endfor %}{% endif %}

{% if "negative" in comments %}
Your peers noted the following places where your submission could be improved:
{% for k, v in comments["negative"].items() %}
  - {{k}}: "{{v}}" 
{% endfor %}{% endif %}

{% if "advice" in comments %}
Your peers provided the following suggestions on improving your submission:
{% for k, v in comments["advice"].items() %}
  - {{k}}: "{{v}}" 
{% endfor %}{% endif %}

{% endif %}

{% if instructor_comment %}
Additionally, you received the following comments from the course staff:

> {{instructor_comment}}
{% endif %}

---
If you have any questions or concerns about your grade, please contact the course staff directly, in accordance with the 
regrading policy (https://michael-weylandt.com/STA9750/syllabus.html#regrading-policy). We will be happy to look more closely
at any element you feel was misgraded. 

**This is an automated message. Please contact the course staff with any questions.**

