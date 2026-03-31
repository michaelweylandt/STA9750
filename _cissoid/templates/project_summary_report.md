Hello {{team_name}},

Please see below for instructor feedback on your
final summary report (submitted as a team).

Team Name: {{ team_name }}

Team Members:
{% for m in members %}
- {{ m.name }} ({{ m.email }})
{%- endfor %}

URL of Version Used for Grading: {{ report_url }}

Word Count: NN

Rubric Element:

- Clarity of writing and motivation (<= 50 points):
  - Motivation of OQ and SQs (<= 10):
  - Clarity of SQ Findings (<= 10):
  - Integration of SQ Findings to OQ (<= 20):
  - Engagement with Prior Literature (<= 10):
- Clarity of visuals (<= 25 points): 
  - Accessibilty (<= 10): 
  - Formatting (<= 10):
  - Technical Content of Viz (<= 5):

See https://michael-weylandt.com/STA9750/project.html#rubric-group-report for details.

Additional Comments:
-
