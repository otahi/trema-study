require File.join( File.dirname( __FILE__ ), "spec_helper" )

require "traffic-monitor"

describe TrafficMonitor do
  it "transfers all packets" do
    network {
      vswitch ( "tmsw" )  { datapath_id "0xabc" }
      vhost   ( "host1" ) { mac "00:00:00:01:00:01" }
      vhost   ( "host2" ) { mac "00:00:00:01:00:02" }
      link "tmsw", "host1"
      link "tmsw", "host2"
    }.run( TrafficMonitor ) {
      send_packets "host1", "host2",  :n_pkts => 10, :pps => 10
      vhost( "host2" ).stats( :rx ).should have( 10 ).packets
    }
  end
  it "counts packets" do
    network {
      vswitch ( "tmsw" )  { datapath_id "0xabc" }
      vhost   ( "host1" ) { mac "00:00:00:01:00:01" }
      vhost   ( "host2" ) { mac "00:00:00:01:00:02" }
      link "tmsw", "host1"
      link "tmsw", "host2"
    }.run( TrafficMonitor ) {
      send_packets "host1", "host2",  :n_pkts => 10, :pps => 10
      controller("TrafficMonitor").get_packet_count( "00:00:00:01:00:01" ).should == 10
      controller("TrafficMonitor").get_packet_count( "00:00:00:01:00:02" ).should == 10
    }
  end
  it "counts packets size" do
    network {
      vswitch ( "tmsw" )  { datapath_id "0xabc" }
      vhost   ( "host1" ) { mac "00:00:00:01:00:01" }
      vhost   ( "host2" ) { mac "00:00:00:01:00:02" }
      link "tmsw", "host1"
      link "tmsw", "host2"
    }.run( TrafficMonitor ) {
      send_packets "host1", "host2",  :n_pkts => 10, :pps => 10
      controller("TrafficMonitor").get_packet_size( "00:00:00:01:00:01" ).should == 100
      controller("TrafficMonitor").get_packet_size( "00:00:00:01:00:02" ).should == 100
    }
  end
end

