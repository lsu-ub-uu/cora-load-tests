# cora-load-tests

## Requirements
- jmeter installed and added to PATH

## Load tests
2. Run the command test.sh with which type of test as argument. For example, to run the load test, run `./test.sh load`
3. The results will be saved in the `output` folder.
4. To view the report, open the `index.html` file in the `report` folder with a web browser. The report will show you the results of the test, including the response times, throughput, and error rates.

### Load test types (profiles)
- baseline: simulates a normal load on the system to establish a baseline for performance metrics
- load: simulates a normal load on the system
- stress: simulates a high load on the system to test its limits
- spike: simulates a sudden increase in load to test the system's ability to handle spikes

## Health check
2. Run the command `./health.sh`. The test will run a one thread, one iteration CRUD test on the system to validate that the system is up and running.
3. The results will be saved in the `output` folder.

## Notes
- For development purposes the script will look for a local environment file named `env.local` in the root of the project. This file should contain values you want to override from the test profile's `env` file. For example, you can set the `HOST` variable to point to a custom host for testing.

## Environment variables for tests
```
# System to test
HOST=somesystem.com
PORT=30982
PROTOCOL=http

# Authentication
ADMIN_USER=adminUser@somesystem.com
ADMIN_APPTOKEN=admin-token # Apptoken is not stored in any environment file, it should be set elsewhere when running the tests. For development purposes, you can set it in the `env.local` file.

# Load configuration
USER_LOAD=100
RAMP_SECONDS=90
DURATION_SECONDS=900

# User request pacing (per user/thread)
PACING_BASE_MILLIS=3000
PACING_VARIANCE_MILLIS=2000
```
