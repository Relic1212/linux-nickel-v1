{
  DinitService = {
    type
      | doc "internal, triggered, process, bgprocess or
scripted"
      | std.contract.from_validator (match {
        "internal" => 'Ok,
        "triggered" => 'Ok,
        "process" => 'Ok,
        "bgprocess" => 'Ok,
        "scripted" => 'Ok,
        value =>
          'Error {
            message = "Got %{value},\nbut type be one of internal, triggered, process, bgprocess or
scripted"
          }
      }
      ),
    command | doc "command to be execeuted" | String,
    restart | Bool,
    default = true,
    needs | doc "hard depends (depends-on)" | Array | optional,
    milestones | doc "dependencies needed before starting, but may stop without stopping the dependand (depends-ms)" | Array | optional,
    "waits-for" | doc "services to wait for before starting, but continue without if they fail" | Array | optional,
  }
}
