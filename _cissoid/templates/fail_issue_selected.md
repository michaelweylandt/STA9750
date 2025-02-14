Hi @{{ gh }},

Thanks for submitting [MP 0{{ project_id }}](https://michael-weylandt.com/STA9750/miniprojects/mini0{{ project_id }}.html)!

We are now starting the *peer feedback* portion of the cycle.

---

This submission did not pass the automated formatting checks. 

In particular, the checks noted `{{ check_message }}`. Peer evaluators, 
please make sure to check this. The automated checks are not foolproof, 
however, and this may be a false positive or an otherwise inconsequential 
difference.

Additionally, the checks were unable to find an exact match to the expected
issue title, and this issue was selected instead. 

---

The following students have been assigned to provide peer feedback
on your submission: 

{% for peer in peers %}
- @{{ peer }}
{%- endfor %}

Peers, please a look at the submission associated with 
this GitHub repo and provide peer feedback to @{{ gh }}.

{%- if project_id > 0 -%}

A rubric for peer evaluation of this Mini-Project can be found
in the [Instructions for this Mini-Project](https://michael-weylandt.com/STA9750/miniprojects/mini0{{ project_id }}.html).

Note that your feedback should follow the format specified 
in the [relevant documentation](https://michael-weylandt.com/STA9750/miniprojects.html#peer-feedback).
After submitting your feedback, you can verify that it is properly formatted
using the [`mp_feedback_verify`](https://michael-weylandt.com/STA9750/tips.html#verify-peer-feedback-properly-formatted)
function from the course helper functions. 

{% else %}

This submission is ungraded, so you don't need to provide a numerical score.

Instead, at a minimum, please note: 

1. Something you like about the submission.
2. A suggestion on how to improve it.

Feel free to link to other repos, the course documentation, or other useful
examples.

{% endif %}

The submission should be visible at 

> [{{ sub_url }}]({{ sub_url }})

The source code for that document should found at 

> [{{ raw_url }}]({{ raw_url }})

Thank you for your active participation in this feedback cycle!

- @michaelweylandt

**This is an automated message. Please contact the course staff with any questions.**
