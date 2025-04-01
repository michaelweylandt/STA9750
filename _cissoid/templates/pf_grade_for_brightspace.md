Hi {{ name }},

For MP#0{{ project_id }} (https://michael-weylandt.com/STA9750/miniprojects/mini0{{ project_id }}.html), you received an
overall score of {{ total }} out of 50 ({{ 2*total }}%). Your submission and peer feedback can be found at https://github.com/michael-weylandt/{{course_repo}}/issues/{{issue_num}}.

This score was obtained by summing the following: 
{% for c in categories %}
- {{ c }}: {{ scores[c] }} (Median of {{ scores_dict[c] }})
{%- endfor %}

{% if penalty %}
A penalty of 5 points was deducted from your overall score because you did not submit on time and
an instructor-opened GitHub issue was used instead. If you believe this penalty has been applied
incorrectly, please contact the course staff ASAP. 
{% endif %}

Your peers provided the following comments: 

{% for c in categories %}

{{ c }}:  {% for author, comment in comments[c] %}
  - @{{ author }} said "{{ comment }}"
{%- endfor %}
{%- endfor %}

You can find the rubric used to grade this mini-project at the link above. 

If you have any questions or concerns about your grades, please contact the course staff directly, in accordance with the 
regrading policy (https://michael-weylandt.com/STA9750/syllabus.html#regrading-policy). We will be happy to look more closely
at any element you feel was misgraded. 

**This is an automated message. Please contact the course staff with any questions.**
