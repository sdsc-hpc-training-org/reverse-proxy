#!/bin/bash

# Run all the tests in this repository for the Reverse Proxy Service
# The idea is to be able to start a a notebook using the script, then check that its
# token is redeemed. If all the test batch scripts execute and redeem their token then
# this is a strong indicator that the RPS works.


./start_notebook -b ./tests/basic_notebook.sh

./start_notebook -b ./tests/basic_jupyterlab.sh
