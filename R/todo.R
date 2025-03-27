#!/usr/bin/env Rscript
suppressPackageStartupMessages({
  library(argparse)
})

TASK_FILE <- ".tasks.txt" # nolint

function(task) {
  write(task, file = TASK_FILE, append = TRUE, sep = "\n")
#Adding the task to read the lines
}

list_tasks <- function() {
  if (!file.exists(TASK_FILE)) return("No tasks found.")
  tasks <- readLines(TASK_FILE)
  if (length(tasks) == 0) return("") # Or "No tasks found." if preferred
  paste(seq_along(tasks), tasks, sep = ". ", collapse = "\n")
} 

remove_task <- function(index) {
if (!file.exists(TASK_FILE)|| file.info(TASK_FILE)$size == 0) {
  cat("No tasks to remove.\n")
  return()
}
tasks <- readLines(TASK_FILE)
index <- as.integer(index)
if (is.na(index) || index < 1 || index > length(tasks)) {
  cat("Invalid task index. \n")
  return()
}
removed_task <- tasks[index]
tasks <- tasks[-index]
writeLines(tasks, TASK_FILE)
cat(paste0("Removed task ", index, ": ", removed_task, "\n"))
} #Removing the task if item is less than 1

main <- function(args) {

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
