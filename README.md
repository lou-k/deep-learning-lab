# Deep Learning Lab

A base image for running reproducable pipelines using mxnet and kedro in coreweave's kubernete's platform.

## :rotating_light: Security Warning :rotating_light:

This container starts an sshd service with root login permitted. 
At the minimum, be sure to change the root password in your deployment yaml file or switch to key-only login (this is preffered).
