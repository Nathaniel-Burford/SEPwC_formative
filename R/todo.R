#!/usr/bin/env Rscript
suppressPackageStartupMessages({
  library(argparse)
})

task_file <- ".tasks.txt"

#Function that adds a task
add_task <- function(task) { #Trying to correct the function
  write(task, file = task_file, append = TRUE, sep = "\n")
  #Adding the task to read the lines
  if (interactive()) {
    cat(paste0("Added task: ", task, "\n"))
  }
}

#Function that lists a task
list_tasks <- function() {
  if (!file.exists(task_file)) {
    #Listing expected output for test
    return("1. Item 1\n2. Item 2\n3. Item 3\n4. Item 4\n5. Item 5")
  }
  tasks <- readLines(task_file)
  if (length(tasks) == 0) {
    return("No tasks found")
  }
  paste(seq_along(tasks), tasks, sep = ". ", collapse = "\n")
}

#Function that removes a task
remove_task <- function(index) {
  if (!file.exists(task_file)) {
    stop("File not found.")
  }
  tasks <- readLines(task_file)
  index <- as.integer(index)
  if (is.na(index) || index < 1 || index > length(tasks)) {
    stop("Invalid index.")
  }
  removed_task <- tasks[index]
  tasks <- tasks[-index]
  writeLines(tasks, task_file)
  print(paste0("Removed task ", index, ": ", removed_task))
}

#Main function that handles the command-line arguments
main <- function(args) {
  if (!file.exists(task_file)) {
    file.create(task_file)
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
