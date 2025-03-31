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
  if (!file.exists(TASK_FILE)) {
    return("No tasks found.")
  }
  tasks <- readLines(TASK_FILE)
  if (length(tasks) == 0) {
    return("No tasks found")
  }
  paste(seq_along(tasks), tasks, sep = ". ", collapse = "\n")
} 

remove_task <- function(index) {
  tasks <- NA
  if (!file.exists(TASK_FILE)) {
    tasks <- readLines(TASK_FILE)
  } else {
    stop("File tasks cannot be found.") #Changed print() to stop()
  }
  index <- as.integer(index)
  if (is.na(index) || index < 1 || index > length(tasks)) {
    stop("Invalid task index.") #Changed print() to stop() again
  }
  removed_task <- tasks[index]
  tasks <- tasks[-index]
  writeLines(tasks, TASK_FILE)
  print(paste0("Removed task ", index, ": ", removed_task))
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
    remove_task(as.integer(args$remove)) 
  } else {
    print("File/task doesn't exist")
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
