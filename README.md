# pycsep_workshop_scec23
## Start Docker on Laptop:
Start the Docker software on your laptop. Docker may take a minute to start-up. Wait until your
Docker Desktop software is “running”, before running any Docker commands. Note that even
though Docker Desktop includes a graphical interface, we will be running Docker commands
from the command-line.

## Open a terminal Window on your Laptop:
Open a terminal window on your computer. Confirm that your Docker software is running by
typing a docker command. For example, if you type (don’t type the $):
$ docker images
Docker should return a list of Docker images currently available on your system. If you get no
response, or an error message, please confirm your Docker software is running.

## Retrieve and Run SCEC pyCSEP and/or GMSV Jupyter Notebook Tutorials from Dockerhub:
SCEC’s pyCSEP and GMSV tutorials are distributed in Jupyter notebook form. This means you
will view the tutorial in a Web Browser on your Laptop. To view the notebooks, start by
retrieving and running the Docker container.
When you issue a Docker run command, like the ones below, Docker will check on your local
computer for the image you specify. If it does not find it locally, it will retrieve the image from
an online repository called Dockerhub. You will need an internet connection to download
images from Dockerhub. The download process will take a length of time that depends on your
download internet speed.
The Docker command to run the SCEC pyCSEP tutorial is (don’t type the $):
$ docker run -p 8888:8888 sceccode/pycsep_scec_workshop
