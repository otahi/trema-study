class SwitchMonitor < Trema::Controller
  timer_event :show_switches, interval: 10.sec

  def start(_args)
    @switches = []
  end

  def switch_ready( datapath_id )
    @switches << datapath_id.to_hex
    logger.info "Switch #{ datapath_id.to_hex } is UP"
  end

  def switch_disconnected( datapath_id )
    @swtich -= [datapath_id.to_hex]
    logger.info "Switch #{ datapath_id.to_hex } is DOWN"
  end

  private

  def show_switches
    logger.info "All switches = " + @switches.sort.join( ",")
  end

end
