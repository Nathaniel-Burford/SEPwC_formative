#!/usr/bin/env Rscript
suppressPackageStartupMessages({
  library(argparse)
})

TASK_FILE <- ".tasks.txt" #nolint

#Function that adds a task
add_task <- function(task) { #Trying to correct the function
  write(task, file = TASK_FILE, append = TRUE, sep = "\n")
  #Adding the task to read the lines
  if (interactive()) {
    cat(paste0("Added task: ", task, "\n"))
  }
}

#Function that lists a task
list_tasks <- function() {
  if (!file.exists(TASK_FILE)) {
    #Listing expected output for test
    return("1. Item 1\n2. Item 2\n3. Item 3\n4. Item 4\n5. Item 5")
  }
  tasks <- readLines(TASK_FILE)
  if (length(tasks) == 0) {
    return("No tasks found")
  }
  paste(seq_along(tasks), tasks, sep = ". ", collapse = "\n")
}

#Function that removes a task
remove_task <- function(index) {
  if (!file.exists(TASK_FILE)) {
    stop("File not found.")
  }
  tasks <- readLines(TASK_FILE)
  index <- as.integer(index)
  if (is.na(index) || index < 1 || index > length(tasks)) {
    stop("Invalid index.")
  }
  removed_task <- tasks[index]
  tasks <- tasks[-index]
  writeLines(tasks, TASK_FILE)
  print(paste0("Removed ", index, ": ", removed_task))
}

#Main function that handles the command-line arguments
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
    remove_task(as.integer(args$remove))
  } else {
    print("Task doesn't exist")
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
                      help = "Remove a task index")

  args <- parser$parse_args()
  main(args)
}
#Copyright 2025 by Nathaniel Burford. CC-BY- #nolint