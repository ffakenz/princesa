# princesa

## testing
stack test

## running
### fire up infrastructure
docker-compose -f ./assets/docker-compose.yml up -d
#### access db
docker exec -it postgres_container psql -U princesa
### fire up application
stack run

## building
stack build

## cleaning
stack clean

## dev playground
stack ghci

## dev hot reload
ghcid

## api doc => @todo servant-doc
### create job
curl -X POST http://localhost:8081/jobs -H 'Content-Type: application/json' -d '{"jobId": { "getJobId" : 3}, "jobDescription": "lol"}'