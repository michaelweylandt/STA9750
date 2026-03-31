CHECK RESULT: {{issue_ok}}
CHECK STATUS: {{issue_status}}
STUDENT {{n_student}} of {{total_students}} ({{progress}} completed)

{% if overall_score %} Total Peer Score {{overall_score["Total"]}} {% endif %}

{% if scores is not none %}
The following peer scores on the submission were received: 

{% for k, v in scores.items() %}
{{k}}: Median Peer Score {{overall_score[k]}}{% for k2, v2 in v.items() %}
  - {{k2}}: {{v2["score"]}}. {{v2["comment"]|wordwrap(width=80)}}
  {% endfor %}
{% endfor %}

{% endif %}

{% if comments is not none %}
The following overall comments on the submission were received.

{% if "positive" in comments %}
POSITIVE:
{% for k, v in comments["positive"].items() %}
- {{k}}: "{{v}}" 
{% endfor %}{% endif %}
 
{% if "negative" in comments %}
NEGATIVE:
{% for k, v in comments["negative"].items() %}
- {{k}}: "{{v}}" 
{% endfor %}{% endif %}

{% if "advice" in comments %}
ADVICE
{% for k, v in comments["advice"].items() %}
- {{k}}: "{{v}}" 
{% endfor %}{% endif %}
{% endif %}

Please place any instructor comments here
Any lines beginning with a ## will be automatically removed
