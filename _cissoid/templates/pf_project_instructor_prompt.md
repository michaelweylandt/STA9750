STUDENT {{n_student}} of {{total_students}} ({{progress}} completed)

Total Peer Score {{overall_score}} of {{maximum_score}} 

The following peer scores on the submission were received for {{name}} ({{gh}}) from the {{team_name}} team.

{% for k, v in scores.items() %}
{{k[1]}} ({{k[0]}}): Median Peer Score: {{v["Median"]}} (Median of {{v["ALL"].values()|list}}){% for k2, v2 in v["ALL"].items() %}
  - {{k2}}: {{v2}}
{% endfor %}
{% endfor %}

The following overall comments on the submission were received.

{% for k, v in comments.items() %}
{{k[1]}}: {%for k2, v2 in v.items() %}
  - {{k2}}: {{v2}}
{% endfor %}
{% endfor %}

Please place any instructor comments here
Any lines beginning with a ## will be automatically removed
