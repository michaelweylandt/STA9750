Hello {{team_name}}, 

Please see below for instructor feedback on your team contract. 

Team Name: {{ team_name }} (Will be updated after proposals are graded)

Team Members:
{% for m in members %}
- {{ m.name }} (@{{m.github}} / {{ m.email }})
{%- endfor %}

See https://michael-weylandt.com/STA9750/project.html#team-contract for details.

Required elements: 

- Names and Biographies: 
- Communication Plan: 
- Workload Expectation: 
- Accountability Mechanisms: 
- Dissolution Plan: 

Additional Comments: 
- 
