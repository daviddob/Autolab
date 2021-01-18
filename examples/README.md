# Examples

this directory contains examples for a few features of the autograder

## Assessments

The Hello folder and Hello.tar contain various examples of different styles of Assessments


## Importing Assessments

whether you are importing one or more assessments the procedure is the same

multiple assessment import starter.tar is the starter file for importing one or more assessments


```bash
multiple assessment import starter.tar
├── assessment1
│   ├── assessment1.yml
│   ├── autograde.tar
│   └── autograde-Makefile
└── assessment2
    └── assessment1.yml

```

every folder in the tar represents a separate assessment

assessment1 is an example of an assessment with an autograding component

properties.yml
```YAML
---
general:
  name: assessment1
  description: ''
  display_name: ASSESSMENT WITH AUTOGRADING
  handin_filename: handin.zip
  handin_directory: handin
  max_grace_days: 0
  handout: ''
  writeup: ''
  max_submissions: -1
  disable_handins: false
  max_size: 2
  has_svn: false
  category_name: Lab Activities
handin:
  start_at: '1523557920'
  visible_at: '1523557967'
  due_at: '1543692720'
  end_at: '1543699920'
  grading_deadline: '1543693720'
problems:
- name: Score
  description: ''
  max_score: 3.0
  optional: false
autograder:
  autograde_timeout: 180
  autograde_image: autograding_image
  release_score: true
  makefile: autograde-Makefile
  tarfile: autograde.tar
book_keeping:
  interface_number: 1000

```
this file must be named properties.yml

name: must be url safe

handin: times are seconds after epoch in UTC

book_keeping: the interface number will be used to provided migration steps if the system changes too much to support old versions

problems even if there is only 1 must be denoted as a list
~~~
autograde-Makefile, autograde.tar
~~~
will contain your assessment files to ship to tango and be graded, names of these must be provided in the YAML file

assessment2 is an assessment without autograding same rules apply as assessment1 the only difference being the assessment.yml file does not contain the autograder section

```YAML
---
general:
  name: assessment2
  description: ''
  display_name: ASSESSMENT WITH OUT AUOTGRADING
  handin_filename: objects.zip
  handin_directory: handin
  max_grace_days: 0
  handout: ''
  writeup: ''
  max_submissions: -1
  disable_handins: false
  max_size: 5
  has_svn: false
  category_name: RecitationQuiz
handin:
  start_at: '1523557920'
  visible_at: '1523557967'
  due_at: '1543692720'
  end_at: '1543699920'
  grading_deadline: '1543693720'
problems:
- name: quiz02
  description: ''
  max_score: 100.0
  optional: false
```
