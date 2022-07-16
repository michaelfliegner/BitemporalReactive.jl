using Genie.Configuration, Logging
println("running dev.jl")
const config = Settings(
  server_port=8000,
  server_host="127.0.0.1",
  websockets_server=true,
  ws_port=8001,
  log_level=Logging.Info,
  log_to_file=false,
  server_handle_static_files=true,
  path_build="build",
  format_julia_builds=true,
  format_html_output=true
)

ENV["JULIA_REVISE"] = "auto"