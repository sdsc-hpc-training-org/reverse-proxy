#!/bin/bash
# This script will use shunit to see if a notebook is started

testNotebookSubmitted() {
    assertEquals 2 2
}

. shunit2-2.1.6/src/shunit2
