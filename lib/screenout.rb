class Screenout
  DEFAULT_STATUSLINE = '%H %`%-w%{=b bw}%n %t%{-}%+w'
  DEFAULT_SCREEN_CMD = 'screen'
  SCREEN_COLOR = {
      :black  => 'dd',
      :green  => 'gw',
      :yellow => 'yk',
      :red    => 'rw'
    }

  def self.message(msg, color = :black)
    col = SCREEN_COLOR[color]
    msg = %Q[ %{=b #{col}} #{msg} %{-}]
    send_cmd(msg)
  end

  def self.clear
    send_cmd('')
  end

  def self.run_screen_session?
    str = `#{screen_cmd} -ls`
    str.match(/(\d+) Socket/) && ($1.to_i > 0)
  end

  def self.execute?
    !($TESTING || !run_screen_session?)
  end

  @statusline, @screen_cmd = nil
  def self.statusline; @statusline || DEFAULT_STATUSLINE.dup; end
  def self.statusline=(a); @statusline = a; end
  def self.screen_cmd; @screen_cmd || DEFAULT_SCREEN_CMD.dup; end
  def self.screen_cmd=(a); @screen_cmd = a; end

  def self.send_cmd(msg)
    cmd = %(#{screen_cmd} -X eval 'hardstatus alwayslastline "#{(statusline + msg).gsub('"', '\"')}"') #' stupid ruby-mode
    system cmd
    nil
  end

  @last_message = {}
end
