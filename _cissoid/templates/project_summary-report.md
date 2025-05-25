Hello {{team_name}},

Please see below for instructor feedback on your
final summary report (submitted as a team).

Team Name: {{ team_name }}

Team Members:
{% for m in members %}
- {{ m.name }} ({{ m.email }})
{%- endfor %}

URL of Version Used for Grading: {{ report_url }}

Rubric Element:

- Clarity of writing and motivation (<= 50 points): NN
- Clarity of visuals (<= 25 points): NN

See https://michael-weylandt.com/STA9750/project.html#final-summary-report for details.

Additional Comments:
-
