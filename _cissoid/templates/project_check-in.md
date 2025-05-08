Hello {{team_name}}, 

Please see below for instructor feedback on your project check-in presentation.

Team Name: {{ team_name }}

Team Members:
{% for m in members %}
- {{ m.name }} ({{ m.email }})
{%- endfor %}

Presentation Length: MM:SS

Rubric Element: 

- Quality of Presentation (<= 10 points): NN
- Initial Analysis of Proposed Data Sources (<= 15 points): NN
- Quality of Specific Questions (<= 10 points): NN
- Engagement with Relevant Literature (<= 10 points): NN
- Timing of Presentation (<= 5 points): NN

See https://michael-weylandt.com/STA9750/project.html#rubric-check-in for details.

Additional Comments: 
- 
