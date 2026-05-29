Hello {{team_name}}, 

Please see below for instructor feedback on your final project presentation.

Team Name: {{ team_name }}

Team Members:
{% for m in members %}
- {{ m.name }} ({{ m.email }})
{%- endfor %}

Presentation Length: MM:SS

Rubric Element: 

- Quality of Presentation (<= 15 points): NN
- Relationship of Motivating and Specific Questions (<= 10 points): NN
- Discussion of Data Sources (<= 15 points): NN
- Communication of Findings (<= 20 points): NN
- Contextualization of Project (<= 10 points): NN
- Timing of Presentation (<= 5 points): NN

See https://michael-weylandt.com/STA9750/project.html#rubric-final for details.

Additional Comments: 
- 
