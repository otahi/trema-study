# Traffic Monitor

## Description

- Traffic Monitor count packets and packets sizes by MAC
- Traffic Monitor show counters on terminal every 10 seconds

## How to run

- Run a controller
  - % trema run ./traffic-monitor.rb -c ./traffic-monitor.conf
- Send packets to hosts
  - % trema send_packets --source host1 --dest host2 --n_pkts 10 --pps 10
  - % trema send_packets --source host2 --dest host1 --n_pkts 10 --pps 10

## How to test

- Run a test
  - % rspec -fs -c ./spec/traffic-monitor_spec.rb


## Reference

- [Test first Trema-ja](https://github.com/trema/testfirst-trema-ja)
