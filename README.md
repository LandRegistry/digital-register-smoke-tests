# Digital register smoke tests
This repository contains the smoke tests to check that our system is working correctly after deployment

This is written in ruby and we are using rubocop to ensure code standards are kept consistent throughout all our repositories.

To run rubocop use this command:

```
rubocop --except Style/GlobalVars,Metrics/LineLength,Metrics/MethodLength
```

## Setup

### Setup for local running

This is to be ran in your vagrant set up using centos-dev-env.  Instructions to start are on that github repository.

 1. Start up Digital Register by doing lr-start-all.

 2. Seed the database for titles and user by running lr-seed-data.

 3. In test_variables.rb amend SMOKE_TITLE_NUMBER, SMOKE_PARTIAL_ADDRESS, and SMOKE_POSTCODE with the title you
 want the smoke tests to use. These variables are set to match the dev environment data.
 4. Run the following command:

    ./run_tests.sh
