local main = "192.168.0.1"

return {
  -- ref: https://wezfurlong.org/wezterm/config/lua/SshDomain.html
  ssh_domains = {
    {
      name = "main_ssh",
      remote_address = main,
      username='chs',
    },
  },
  unix_domains = {},
  -- ref: https://wezterm.org/config/lua/config/tls_clients.html
  tls_clients = {
    {
      -- A handy alias for this session; you will use `wezterm connect server.name`
      -- to connect to it.
      name = 'main_tls',
      -- The host:port for the remote host
      remote_address = main .. ':8088',
      -- The value can be "user@host:port"; it accepts the same syntax as the
      -- `wezterm ssh` subcommand.
      bootstrap_via_ssh = 'chs@' .. main,
    },
  },
  tls_servers = {},
}
