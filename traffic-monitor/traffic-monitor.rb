require 'counter'

class TrafficMonitor < Trema::Controller
  timer_event :show_counter, interval: 10.sec

  def start(_args)
    @fdb = {}
    @counter = Counter.new
  end

  def packet_in(datapath_id, message)
    @fdb[message.macsa] = message.in_port
    port_no = @fdb[message.macda]
    if port_no
      flow_mod datapath_id, message, port_no
      packet_out datapath_id, message, port_no
    else
      flood datapath_id, message
    end
    @counter.add message.macsa, 1, message.total_len
  end

  def flow_removed(_datapath_id, message)
    @counter.add message.match.dl_src, message.packet_count, message.byte_count
  end

  def get_packet_count(mac)
    @counter.get_packet_count Mac.new(mac)
  end

  def get_packet_size(mac)
    @counter.get_packet_size Mac.new(mac)
  end

  private

  def show_counter
    puts Time.now
    @counter.each_pair do | mac, counter |
      s =  "#{mac} #{counter[:packet_count]} packets"
      s += "(#{counter[:byte_count]} bytes)"
      puts s
    end
  end

  def flow_mod(datapath_id, message, port_no)
    # ExactMatch includes mac, ip, tcp/udp...
    # in real cases it shuold not be ExactMatch
    send_flow_mod_add(datapath_id,
                      hard_timeout: 10,
                      match: ExactMatch.from(message),
                      actions: SendOutPort.new(port_no))
  end

  def packet_out(datapath_id, message, port_no)
    send_packet_out(datapath_id,
                    packet_in: message,
                    actions: SendOutPort.new(port_no))
  end

  def flood(datapath_id, message)
    packet_out(datapath_id, message, OFPP_FLOOD)
  end
end
