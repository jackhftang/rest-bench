# REST Server Performance

Compare simple REST server performance in Node.js and Go.

Both servers do the same - parse the JSON body and return it back in the response.
No external libraries are used, just the builtin APIs.

Install
- Node.js
- Go
- [wrk](https://github.com/wg/wrk)

The POST request is defined in [post.lua](post.lua).
The content is ~4KB JSON.

```
$ node -v
v10.1.0
$ go version
go version go1.10.1 linux/amd64
$ cat /etc/issue
Ubuntu 16.04.4 LTS \n \l
```
CPU: Intel® Core™ i7 CPU @ 2.20GHz × 4

## Node.js
Start the server
```
$ node server.js
Listening on port 3000
```
Run the test in a separate console
```
$ wrk -d 20s -s post.lua http://localhost:3000
Running 20s test @ http://localhost:3000
  2 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     1.05ms  410.09us  12.83ms   85.53%
    Req/Sec     4.85k   729.92     5.84k    65.42%
  194145 requests in 20.10s, 432.14MB read
Requests/sec:   9658.75
Transfer/sec:     21.50MB
```
During the test the _node_ process runs at ~100% CPU and ~70MB memory.

## Go with GOMAXPROCS=1
Start the server
```
$ GOMAXPROCS=1 go run server.go
2018/05/19 23:45:39 Listening on port 3000
```
To get comparable results we start the go server with `GOMAXPROCS=1` as Node.js executes JavaScript in a single thread. To utilize multiple CPU cores with Node.js you could use the _cluster_ module. Anyway, in the cloud your process usually gets one core or even less.

Run the test in a separate console
```
$ wrk -d 20s -s post.lua http://localhost:3000
Running 20s test @ http://localhost:3000
  2 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   689.89us  401.59us   7.40ms   68.67%
    Req/Sec     7.44k   728.13     8.14k    89.55%
  297390 requests in 20.10s, 671.60MB read
Requests/sec:  14795.37
Transfer/sec:     33.41MB
```
During the test the _server_ process runs at ~100% CPU and ~10MB memory.

## Go
Start the server
```
$ go run server.go
2018/05/19 23:45:39 Listening on port 3000
```
Run the test in a separate console
```
$ wrk -d 20s -s post.lua http://localhost:3000
Running 20s test @ http://localhost:3000
  2 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   283.51us  284.38us  10.48ms   93.11%
    Req/Sec    19.23k     1.59k   21.29k    79.60%
  769098 requests in 20.10s, 1.70GB read
Requests/sec:  38262.62
Transfer/sec:     86.41MB
```