# princesa

![princesa crown](./assets/docs/images/princess_crown.jpeg)

An Application to support TAs on helping people find their ideal job

## testing
To run the test suite, simply execute
```
stack test
```
## running
To run the application proceed as following
### fire up infrastructure
First we need to start up our db (Postgres) by firing up the docker container, like so
```
docker-compose -f ./assets/docker-compose.yml up -d
```
#### access db
If you need to enter the started db you need to execute the following
```
docker exec -it postgres_container psql -U princesa
```
### fire up application
Finally we can start up our application by executing
```
stack run
```
One aspect of the application is that it mantains 2 different clients
- one for CLI (called Cli)
- another one for HTTP (called Normal)
We can run each of them by doing
```
stack run -- "--appMode=Cli"
```
or
```
stack run -- "--appMode=Normal"
```
respectively
## building
To build the application and create the executable you need to run the following
```
stack build
```
## cleaning
To clean up built stuff just run
```
stack clean
```
## dev playground
If you need to load up all the application in the REPL execute the following on your terminal
```
stack ghci
```
## dev hot reload
Is strongly recomended to have ghcid  running during your development cycle
```
ghcid
```

## Playground
Hurray !! 
Here comes the fun part !!
Now that you have your application up and running 
you start playing around with it.
Try the following http calls
![princesa title](./assets/docs/images/princess_title.jpeg)
## Jobs
These are the basic endpoints to manage the jobs module
### get jobs > [Get /jobs]
```
curl http://localhost:8081/jobs
```
### create job > [POST /jobs]
```
curl -X POST http://localhost:8081/jobs -H 'Content-Type: application/json' -d '{"jobId": { "getJobId" : 1}, "jobDescription": "hola princesa"}'
```
### find job > [Get /jobs/:jobid]
```
curl http://localhost:8081/jobs/1
```

## Candidates
These are the basic endpoints to manage the candidates module
### get candidates > [Get /candidates]
```
curl http://localhost:8081/candidates
```
### create candidate > [POST /candidates]
```
curl -X POST http://localhost:8081/candidates -H 'Content-Type: application/json' -d '{"candidateId": { "getCandidateId" : 1}, "candidateDescription": "hola princesa"}'
```
### find candidate > [Get /candidates/:candidateid]
```
curl http://localhost:8081/candidates/1
```

![princesa image](./assets/docs/images/princess_image.jpeg)