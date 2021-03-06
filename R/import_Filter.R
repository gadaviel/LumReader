#' Function to import a filter
#'
#' This function import the properties of a filter previously saved in a .FLT file.
#' @param file.name
#'  \link{character} (required): name of the .FLT file containing the filter properties.
#'
#' @param thickness
#'  \link{numeric} (default): Thickness of the filter (by default thickness = reference thickness).
#'
#' @return
#'  The function creates a new \code{\linkS4class{Filter}} object.
#'
#' @author David Strebler, University of Cologne (Germany).
#'
#' @examples
#' folder <- system.file("extdata", package="LumReader")
#'
#' file.name <- 'example' # !!! no extension !!! #
#'
#' file <-paste(folder, '/', file.name, sep="")
#'
#' example <- import_Filter(file)
#'
#' plot_Filter(example)
#'
#' @export import_Filter

import_Filter <- function(

  file.name,

  thickness= NULL

){
  if (missing(file.name)){
    stop("[import_Filter] Error: Input 'file.name' is missing.")
  }else if (!is(file.name,"character")){
    stop("[import_Filter] Error: Input 'file.name' is not of type 'character'.")
  }

  new.file.name <- file_path_sans_ext(file.name)
  ext <- ".FLT"
  new.file.name <- paste(new.file.name,ext,sep = "")

  data <- readLines(new.file.name)

  filter.name <- data[1]                                  ## 1st line contains "name: [name]"
  name <- strsplit(x = filter.name,split = ":")[[1]][2]
  name <- gsub(pattern = " ",replacement = "", x = name)
  new.name <- as.character(name)

  filter.description <- data[2]                           ## 2nd line contains "description: [description]"
  description <- strsplit(x = filter.description,split = ": ")[[1]][2]
  new.description <- as.character(description)

  filter.thickness <- data[3]                           ## 3rd line contains "Thickness [mm]: [thickness]"
  reference.thickness <- strsplit(x = filter.thickness,split = ": ")[[1]][2]
  reference.thickness <- gsub(pattern = ",",replacement = ".", x = reference.thickness)
  new.reference.thickness <- as.numeric(reference.thickness)

  filter.reflexion <- data[4]                          ## 4th line contains "reflexion (1-P) [%]: [reflexion]"
  reflexion <- strsplit(x = filter.reflexion,split = ": ")[[1]][2]
  reflexion <- gsub(pattern = ",",replacement = ".", x = reflexion)
  new.reflexion <- as.numeric(reflexion)

  temp.transmission <- data[5]                    ## 5th line contains "Transmission (T) [%]:"
  ## 6th-end line contain "[wavelength] [tau]"
  filter.transmission <- data[6:length(data)]

  new.reference.transmission <- matrix(nrow = length(filter.transmission),
                                       ncol = 2)

  for(i in 1: length(filter.transmission)){
    temp.transmission <- filter.transmission[i]
    temp.transmission <- unlist(strsplit(x=temp.transmission, split = c(" ", ";", "\t")))
    temp.transmission <- gsub(pattern = ",",replacement = ".", x = temp.transmission)
    temp.transmission <- suppressWarnings(as.numeric(temp.transmission))
    temp.transmission <- temp.transmission[!is.na(temp.transmission)]
    new.reference.transmission[i,] <- temp.transmission
  }

  if(is.null(thickness)){
    new.thickness <- new.reference.thickness

  }else if (!is.numeric(thickness)){
    stop("[import_Filter] Error: Input 'thickness' is not of type 'numeric'.")
  }else if(thickness<=0){
    stop("[import_Filter] Error: Input 'thickness' can not be <= 0.")
  }else if(thickness < new.reference.thickness){
    warning("[import_Filter] Warning: Input 'thickness' should not be < reference.thickness.")
    new.thickness <- thickness
  }else{
    new.thickness <- thickness
  }

  new.object <- setFilter(name = new.name,
                          description = new.description,
                          reference.thickness = new.reference.thickness,
                          thickness = new.thickness,
                          reflexion = new.reflexion,
                          reference.transmission = new.reference.transmission)

  return(new.object)
}
