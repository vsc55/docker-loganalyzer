#!/bin/bash

docker build --squash  --network=host -t loganalyzer .
