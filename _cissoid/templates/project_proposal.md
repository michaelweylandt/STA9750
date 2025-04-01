Hello {{team_name}}, 

Please see below for instructor feedback on your project proposal. 

Team Name: {{ team_name }}

Team Members:
{% for m in members %}
- {{ m.name }} ({{ m.email }})
{%- endfor %}

Presentation Length: MM:SS

Rubric Element: 

- Quality of Presentation (<= 10 points): NN
- Clarity of Motivating Question (<= 15 points): NN
- Quality of Proposed Data Sources (<= 5 points): NN
- Quality of Specific Questions (<= 10 points): NN
- Timing of Presentation (<= 10 points): NN

See http://michael-weylandt.com/STA9750/project.html#rubric-proposal for details.

Additional Comments: 
- 
