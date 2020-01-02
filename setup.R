
installed_packages <- installed.packages()[, "Package"]

if (!("remotes" %in% installed_packages)) {
    install.packages("remotes")  
} 

reqPackages <- list(
        cran = c("here"),
        github = c("kasaai/simulationmachine") #, "rstudio/gt")
)

install_methods <- list(remotes::install_cran, remotes::install_github)

install_pkgs <- function(x, f) {
    # if the package has been installed from github then we need to check for the
    # package name, not the github_user/package_name. However, the later is still
    # what is needed to run install_github
    message("installing packages: ", paste0(x, collapse = ","))
    pkg_without_account <- gsub(pattern = "^[^\\/]+\\/", replacement = "", x = x)
    pkgs_to_install <- x[!pkg_without_account %in% installed_packages]
    f(pkgs_to_install)
}


purrr::walk2(reqPackages, install_methods, install_pkgs)

source("database/make_data.R")