## Script Library

This repository can serve as a library for scripts for ad-hoc data pulls from REACH and PHOENIX tables

It currently containts the following:

- `validation-reach.sql`: Basic tests to understand the grain of each dataset and how they connect
- `metrics-by-vol.sql`: Query to compute the current state of volunteer-level metrics

Additionally, the following reference material exists that is not yet ready for use in this campaign:

- `Tag - Voted.ipynb`: This is a sample tagging notebook from 2022. However it appears Reach's [endpoints have changed](https://www.reach.vote/blog/using-the-reach-api-to-bulk-apply-tags/) to have a bulk CSV load process, so this is unlikely to be the final form that we need
