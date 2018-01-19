## Swirlify

new_lesson("Lesson 1", "My First Course")

wq_message() # adds template for message question

wq_command() # enter some R code after a question

add_to_manifest()

test_lesson() #check formatting of the lesson

demo_lesson() # go to the swirl lesson

get_current_lesson() # info about the current lesson

new_lesson("Lesson 2", "My First Course")

wq_multiple() # multiple choice question

add_to_manifest()

test_lesson()

demo_lesson()

wq_figure() # figure question, figure is an R script (fig1.R) in the lesson 2 directory

demo_lesson()

wq_figure() # add something to the figure, calls a new fig2.R file

