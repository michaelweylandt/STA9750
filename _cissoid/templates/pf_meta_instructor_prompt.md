Peer Feedback {{ix_feedback}} of {{n_feedback}} ({{progress}}% completed)

- SUBMITTED BY: {{submittor}}
- PEER REVIEW BY: {{evaluator}}

{% if comments is not none %}
The following overall comments on the submission were received.

{% if "positive" in comments %}
POSITIVE: {{ comments["positive"] }}
{% endif %}
 
{% if "negative" in comments %}
NEGATIVE: {{ comments["negative"] }}
{% endif %}

{% if "advice" in comments %}
ADVICE: {{ comments["advice"] }}
{% endif %}
{% endif %}

{% if scores is not none %}
The following peer scores on the submission were received: 
{% for k, v in scores.items() %}
  - {{k}}: {{v["score"]}}. {{v["comment"]|wordwrap(width=80)}}
{% endfor %}
{% endif %}

===========

Please place any instructor comments here
Any lines beginning with a ## will be automatically removed

Pre-Canned Comments:

{% if defaults %}{% for d in defaults %}
{{ d }}
{% endfor %}{% endif %}
