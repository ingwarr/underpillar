apache:
  server:
    enabled: true
    bind:
      address: 0.0.0.0
      ports:
      - 80
      - 443
      protocol: tcp
    modules:
    - ssl
    - rewrite
    default_mpm: prefork
    mpm:
      prefork:
        servers:
          start: 5
          spare:
            min: 5
            max: 10
          # Avoid memory leakage by restarting workers every x requests
          max_requests: 0
        # Should be 80% of server memory / average memory usage of one worker
        max_clients: 150
        # Should be same or more than max clients
        limit: 150
      event:
        servers:
          start: 5
          spare:
            min: 25
            max: 75
          threads_per_child: 25
          # Avoid memory leakage by restarting workers every x requests
          max_requests: 0
        # Should be 80% of server memory / average memory usage of one worker
        max_clients: 150
        limit: 64
      worker:
        servers:
          start: 5
          spare:
            min: 25
            max: 75
          threads_per_child: 25
          # Avoid memory leakage by restarting workers every x requests
          max_requests: 0
        # Should be 80% of server memory / average memory usage of one worker
        max_clients: 150
        limit: 64
