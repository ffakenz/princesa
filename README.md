# princesa

## testing
stack test

## running
### fire up infrastructure
docker-compose -f ./assets/docker-compose.yml up -d
#### access db
docker exec -it postgres_container psql -U princesa
### fire up application
stack run -- "--appMode=Cli")
stack run -- "--appMode=Normal")

## building
stack build

## cleaning
stack clean

## dev playground
stack ghci

## dev hot reload
ghcid

## api doc => @todo servant-doc
### get jobs
curl http://localhost:8081/jobs
### create job
curl -X POST http://localhost:8081/jobs -H 'Content-Type: application/json' -d '{"jobId": { "getJobId" : 1}, "jobDescription": "hola princesa"}'
### find job
curl http://localhost:8081/jobs/1

### get candidates
curl http://localhost:8081/candidates
### create candidate
curl -X POST http://localhost:8081/candidates -H 'Content-Type: application/json' -d '{"candidateId": { "getCandidateId" : 1}, "candidateDescription": "hola princesa"}'
### find candidate
curl http://localhost:8081/candidates/1