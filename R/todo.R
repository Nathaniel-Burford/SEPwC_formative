#!/usr/bin/env Rscript
suppressPackageStartupMessages({
  library(argparse)
})

TASK_FILE <- ".tasks.txt" # nolint

add_task <- function(task) { #Trying to correct the function
  write(task, file = TASK_FILE, append = TRUE, sep = "\n")
#Adding the task to read the lines
  if (interactive()) {
  cat(paste0("Added task: ", task, "\n"))
}
}

list_tasks <- function() {
  if (!file.exists(TASK_FILE)) return("No tasks found.")
  tasks <- readLines(TASK_FILE)
  if (length(tasks) == 0) return("No tasks found")
  paste(seq_along(tasks), tasks, sep = ". ", collapse = "\n")
} 

remove_task <- function(index) {
 tasks <- NA
if (file.exists(TASK_FILE)) {
  tasks <- readLines(TASK_FILE)
} else {
  stop("File cannot be found")
}
if (index <= length(tasks)) {
  tasks <- tasks[-index]
  if (identical(tasks, character(0))) {
    stop("Task cannot be found")
  }
  writeLines(tasks, TASK_FILE)
  print("Task removed.")
} else {
  stop("No tasks found.")
}
}

main <- function(args) {
  if (!file.exists(TASK_FILE)) {
    file.create(TASK_FILE)
  }
  if (!is.null(args$add)) {
    add_task(args$add)
  } else if (args$list) {
    tasks <- list_tasks()
    print(tasks)
  } else if (!is.null(args$remove)) {
    remove_task(args$remove)
  } else {
    print("Use --help to get help on using this program")
  }
}
if (sys.nframe() == 0) {

  # main program, called via Rscript
  parser <- ArgumentParser(description = "Command-line Todo List")
  parser$add_argument("-a", "--add",
                      help = "Add a new task")
  parser$add_argument("-l", "--list",
                      action = "store_true",
                      help = "List all tasks")
  parser$add_argument("-r", "--remove",
                      help = "Remove a task by index")

  args <- parser$parse_args()
  main(args)
}
